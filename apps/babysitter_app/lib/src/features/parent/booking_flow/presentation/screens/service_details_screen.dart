import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../data/providers/booking_flow_provider.dart';
import '../../data/models/booking_flow_state.dart';
import '../../data/providers/bookings_di.dart';
import '../../data/providers/paypal_di.dart';
import '../../data/models/paypal_models.dart';
import '../../data/services/paypal_pending_state.dart';
import '../theme/booking_ui_tokens.dart';
import '../widgets/booking_top_bar.dart';
import '../widgets/payment_detail_row.dart';
import '../widgets/payment_method_sheet.dart';
import '../widgets/dashed_divider.dart';
import 'booking_request_sent_screen.dart';
import 'package:babysitter_app/src/common_widgets/app_toast.dart';
import 'package:babysitter_app/src/common_widgets/payment_method_selector.dart';
import 'package:babysitter_app/src/services/paypal_deep_link_service.dart';

class ServiceDetailsScreen extends ConsumerStatefulWidget {
  const ServiceDetailsScreen({super.key});

  @override
  ConsumerState<ServiceDetailsScreen> createState() =>
      _ServiceDetailsScreenState();
}

class _ServiceDetailsScreenState extends ConsumerState<ServiceDetailsScreen> {
  bool _isLoading = false;
  StreamSubscription<PaypalDeepLinkEvent>? _paypalDeepLinkSub;

  @override
  void initState() {
    super.initState();
    _listenToPaypalDeepLinks();
  }

  @override
  void dispose() {
    _paypalDeepLinkSub?.cancel();
    super.dispose();
  }

  void _listenToPaypalDeepLinks() {
    _paypalDeepLinkSub =
        PaypalDeepLinkService.instance.events.listen((event) async {
      print('DEBUG: ServiceDetailsScreen received PayPal event: $event');

      if (event is PaypalPaymentSuccess) {
        await _handlePaypalSuccess(event.orderId);
      } else if (event is PaypalPaymentCancelled) {
        await _handlePaypalCancel();
      }
    });
  }

  Future<void> _handlePaypalSuccess(String orderId) async {
    final pending = await PaypalPendingState.get();
    final jobId = pending.jobId;

    if (jobId == null) {
      print('DEBUG: PayPal success but no pending jobId');
      if (mounted) {
        AppToast.show(
            context,
            const SnackBar(
              content: Text('Payment session expired. Please try again.'),
              backgroundColor: Color(0xFFD92D20),
            ));
      }
      return;
    }

    setState(() => _isLoading = true);

    try {
      final paypalService = ref.read(paypalPaymentServiceProvider);
      final result = await paypalService.captureOrder(
        jobId: jobId,
        orderId: orderId,
      );

      print(
          'DEBUG: PayPal capture result: ${result.success} - ${result.message}');

      await PaypalPendingState.clear();

      if (result.success && mounted) {
        ref.read(bookingFlowProvider.notifier).reset();
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => BookingRequestSentScreen(
              bookingId: result.jobId,
              sitterName:
                  ref.read(bookingFlowProvider).sitterName ?? 'your sitter',
            ),
          ),
        );
      } else if (mounted) {
        AppToast.show(
            context,
            SnackBar(
              content: Text('Payment failed: ${result.message}'),
              backgroundColor: const Color(0xFFD92D20),
            ));
      }
    } on PaypalError catch (e) {
      print('DEBUG: PayPal capture error: $e');
      await PaypalPendingState.clear();
      if (mounted) {
        AppToast.show(
            context,
            SnackBar(
              content: Text('Payment error: ${e.message}'),
              backgroundColor: const Color(0xFFD92D20),
            ));
      }
    } catch (e) {
      print('DEBUG: PayPal capture unexpected error: $e');
      await PaypalPendingState.clear();
      if (mounted) {
        AppToast.show(
            context,
            SnackBar(
              content: Text('Payment error: ${e.toString()}'),
              backgroundColor: const Color(0xFFD92D20),
            ));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _handlePaypalCancel() async {
    print('DEBUG: PayPal payment cancelled');
    await PaypalPendingState.clear();
    if (mounted) {
      AppToast.show(
          context,
          const SnackBar(
            content: Text('Payment cancelled'),
            backgroundColor: Color(0xFF667085),
          ));
    }
  }

  /// Handle PayPal payment flow
  /// 1. Create PayPal order via backend
  /// 2. Persist pending state
  /// 3. Open approval URL in browser
  Future<void> _handlePaypalFlow(
      String jobId, BookingFlowState bookingState) async {
    try {
      print('DEBUG: Starting PayPal flow for jobId: $jobId');

      final paypalService = ref.read(paypalPaymentServiceProvider);
      final order = await paypalService.createOrder(jobId);

      print('DEBUG: PayPal order created: ${order.orderId}');
      print('DEBUG: PayPal approval URL: ${order.approvalUrl}');

      // Persist state before opening browser
      await PaypalPendingState.save(
        jobId: jobId,
        orderId: order.orderId,
      );

      // Open PayPal approval URL in external browser
      final url = Uri.parse(order.approvalUrl);
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);

        if (mounted) {
          setState(() => _isLoading = false);
          AppToast.show(
              context,
              const SnackBar(
                content: Text('Complete payment in your browser'),
                backgroundColor: Color(0xFF667085),
                duration: Duration(seconds: 3),
              ));
        }
      } else {
        throw Exception('Cannot open PayPal');
      }
    } on PaypalError catch (e) {
      print('DEBUG: PayPal create order error: $e');
      if (mounted) {
        String message = 'Payment error: ${e.message}';
        if (e.isJobNotDraft) {
          message =
              'This booking is no longer available for payment. Please start a new booking.';
        }
        AppToast.show(
            context,
            SnackBar(
              content: Text(message),
              backgroundColor: const Color(0xFFD92D20),
              duration: const Duration(seconds: 5),
            ));
      }
    } catch (e) {
      print('DEBUG: PayPal flow unexpected error: $e');
      if (mounted) {
        AppToast.show(
            context,
            SnackBar(
              content: Text('Could not open PayPal: ${e.toString()}'),
              backgroundColor: const Color(0xFFD92D20),
            ));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  String? _validateBooking(BookingFlowState state) {
    // Validate required fields
    if (state.sitterId == null || state.sitterId!.isEmpty) {
      return 'Missing sitter details. Please return to the sitter profile and try again.';
    }

    if (state.selectedChildIds.isEmpty) {
      return 'Please select at least one child.';
    }

    if (state.startDate == null || state.endDate == null) {
      return 'Please select booking dates.';
    }

    if (state.startTime == null ||
        state.startTime!.isEmpty ||
        state.endTime == null ||
        state.endTime!.isEmpty) {
      return 'Please select booking times.';
    }

    if (state.payRate <= 0) {
      return 'Please set a valid hourly rate.';
    }

    // Validate hours calculation
    if (state.totalHours <= 0) {
      return 'Invalid booking duration. End time must be after start time.';
    }

    // Use the centralized amount validation from BookingFlowState
    final amountError = state.validateAmount();
    if (amountError != null) {
      return amountError;
    }

    return null;
  }

  String _parseErrorMessage(dynamic error) {
    final errorString = error.toString().toLowerCase();

    // Handle backend validation errors
    if (errorString.contains('value must be greater than or equal to 1')) {
      return 'Invalid booking duration. Please check that your end time is after your start time.';
    }

    if (error is StripeException) {
      final errorCode = error.error.code;
      final errorMessage = error.error.localizedMessage ?? '';

      // Handle specific Stripe error codes
      if (errorCode == 'Cancelled') {
        return 'Payment cancelled. Please try again.';
      } else if (errorCode == 'resource_missing' ||
          errorMessage.contains('minimum charge')) {
        return 'The booking amount is below the minimum required. Please adjust your hours or rate.';
      } else if (errorCode == 'card_declined' ||
          error.error.declineCode != null) {
        return 'Payment declined by your card. Please try a different card or contact your bank.';
      } else if (errorCode == 'incorrect_cvc') {
        return 'Invalid security code. Please check your card details.';
      } else if (errorCode == 'invalid_expiry_month' ||
          errorCode == 'invalid_expiry_year') {
        return 'Your card has expired. Please use a different card.';
      } else if (errorMessage.isNotEmpty) {
        return 'Payment error: $errorMessage';
      } else {
        return 'Payment failed. Please try again.';
      }
    } else if (error is SocketException) {
      return 'Network error. Please check your connection and try again.';
    } else if (error is TimeoutException) {
      return 'Request timed out. Please check your connection and try again.';
    } else {
      return 'Error: ${error.toString()}';
    }
  }

  Future<void> _onSubmit() async {
    final bookingState = ref.read(bookingFlowProvider);
    final repository = ref.read(bookingsRepositoryProvider);

    // Validate booking before submission
    final validationError = _validateBooking(bookingState);
    if (validationError != null) {
      if (mounted) {
        AppToast.show(
          context,
          SnackBar(
            content: Text(validationError),
            backgroundColor: const Color(0xFFD92D20),
            duration: const Duration(seconds: 5),
          ),
        );
      }
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Get the device timezone as a string (e.g., "America/Los_Angeles")
      final timezoneInfo = await FlutterTimezone.getLocalTimezone();
      final timezone = timezoneInfo.identifier;

      final payload = bookingState.toDirectBookingPayload();
      payload['timezone'] = timezone;
      payload['timeZone'] = timezone;
      print('DEBUG: ServiceDetailsScreen submitting booking: $payload');
      print(
          'DEBUG: Calculated amount - Hours: ${bookingState.totalHours}, Rate: ${bookingState.payRate}, SubTotal: ${bookingState.subTotal}, Fee: ${bookingState.platformFee}, Total: ${bookingState.totalCost}');

      final result = await repository.createDirectBooking(payload);

      print('DEBUG: ServiceDetailsScreen booking created: ${result.message}');
      print('DEBUG: ServiceDetailsScreen jobId: ${result.jobId}');
      print('DEBUG: ServiceDetailsScreen amount (cents): ${result.amount}');
      print(
          'DEBUG: ServiceDetailsScreen platformFee (cents): ${result.platformFee}');
      print('DEBUG: ServiceDetailsScreen clientSecret: ${result.clientSecret}');

      // The direct booking API returns clientSecret directly - use it for Stripe payment
      // Check which payment method is selected
      final selectedMethod = bookingState.selectedPaymentMethod.toLowerCase();
      print('DEBUG: Selected payment method: $selectedMethod');

      if (selectedMethod == 'paypal') {
        // PayPal flow
        await _handlePaypalFlow(result.jobId, bookingState);
      } else if (result.clientSecret.isNotEmpty) {
        // Stripe/Card flow
        print('DEBUG: Showing payment method selector...');

        if (mounted) {
          setState(() => _isLoading = false);

          // Show payment method selector with native Google Pay support
          await PaymentMethodSelector.show(
            context: context,
            amount: bookingState.totalCost,
            paymentIntentClientSecret: result.clientSecret,
            onPaymentSuccess: () {
              print('DEBUG: Payment completed successfully');
              // Reset booking state after successful creation
              ref.read(bookingFlowProvider.notifier).reset();

              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => BookingRequestSentScreen(
                    bookingId: result.jobId,
                    sitterName: bookingState.sitterName ?? 'your sitter',
                  ),
                ),
              );
            },
            onPaymentError: (error) {
              print('DEBUG: Payment error: $error');
              AppToast.show(
                context,
                SnackBar(
                  content: Text('Payment error: $error'),
                  backgroundColor: const Color(0xFFD92D20),
                  duration: const Duration(seconds: 5),
                ),
              );
            },
          );
        }
      } else {
        print('DEBUG: No clientSecret in response, skipping payment');
        if (mounted) {
          // Reset booking state after successful creation
          ref.read(bookingFlowProvider.notifier).reset();

          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => BookingRequestSentScreen(
                bookingId: result.jobId,
                sitterName: bookingState.sitterName ?? 'your sitter',
              ),
            ),
          );
        }
      }
    } catch (e) {
      print('DEBUG: ServiceDetailsScreen booking error: $e');
      print('DEBUG: Error type: ${e.runtimeType}');
      if (e is StripeException) {
        print('DEBUG: Stripe error code: ${e.error.code}');
        print('DEBUG: Stripe error message: ${e.error.localizedMessage}');
        print('DEBUG: Stripe error decline code: ${e.error.declineCode}');
      }

      if (mounted) {
        String errorMessage = _parseErrorMessage(e);

        AppToast.show(
          context,
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: const Color(0xFFD92D20),
            duration: const Duration(seconds: 5),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final bookingState = ref.watch(bookingFlowProvider);

    return Scaffold(
      backgroundColor: BookingUiTokens.pageBackground,
      appBar: BookingTopBar(
        title: 'Book ${bookingState.sitterName ?? 'Sitter'}',
        onBack: () => Navigator.of(context).pop(),
        onHelp: () {},
      ),
      body: Stack(
        children: [
          // Scrollable Content
          SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            padding: const EdgeInsets.symmetric(
                horizontal: BookingUiTokens.screenHorizontalPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 24),
                // Main Title
                const Text(
                  'Service Details',
                  style: BookingUiTokens.pageTitle,
                ),

                const SizedBox(height: 8),
                _buildDashedDivider(),
                const SizedBox(height: 4),

                // Service Data Rows
                PaymentDetailRow(
                    label: 'No. Of Child',
                    value: bookingState.selectedChildIds.length.toString()),
                _buildRowGap(),
                PaymentDetailRow(
                    label: 'Date', value: bookingState.dateRange ?? 'N/A'),
                _buildRowGap(),
                PaymentDetailRow(
                    label: 'No of Days',
                    value: bookingState.numberOfDays.toString()),
                _buildRowGap(),
                const PaymentDetailRow(label: 'Job Type', value: 'Part Time'),
                _buildRowGap(),
                PaymentDetailRow(
                    label: 'Time',
                    value:
                        '${bookingState.startTime ?? ''} - ${bookingState.endTime ?? ''}'),
                _buildRowGap(),
                PaymentDetailRow(
                    label: 'Address', value: bookingState.fullAddress),

                const SizedBox(height: 24),
                _buildDashedDivider(),
                const SizedBox(height: 8),

                // Cost Breakdown
                PaymentDetailRow(
                  label: 'Sub Total',
                  value: '\$ ${bookingState.subTotal.toStringAsFixed(2)}',
                ),
                _buildRowGap(),
                _buildDashedDivider(),
                _buildRowGap(),

                PaymentDetailRow(
                  label: 'Total Hours',
                  value: '${bookingState.totalHours.toStringAsFixed(1)} Hours',
                ),
                _buildRowGap(),
                PaymentDetailRow(
                  label: 'Hourly Rate',
                  value: '\$ ${bookingState.payRate.toStringAsFixed(2)}/hr',
                ),
                _buildRowGap(),
                _buildDashedDivider(),
                _buildRowGap(),

                PaymentDetailRow(
                  label: 'Platform Fee',
                  value: '\$ ${bookingState.platformFee.toStringAsFixed(2)}',
                ),
                _buildRowGap(),
                const PaymentDetailRow(label: 'Discount', value: '\$ 0.00'),

                // Bottom Spacing for Sticky Sheet
                SizedBox(
                  height: 300 + MediaQuery.of(context).padding.bottom,
                ),
              ],
            ),
          ),

          // Sticky Bottom Sheet
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: PaymentMethodSheet(
              totalCost: bookingState.totalCost,
              ctaLabel: _isLoading ? 'Submitting...' : 'Submit',
              showChange: false,
              onConfirm: _isLoading ? () {} : _onSubmit,
            ),
          ),

          // Loading Overlay
          if (_isLoading)
            Container(
              color: Colors.black26,
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildDashedDivider() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: DashedDivider(),
    );
  }

  Widget _buildRowGap() {
    return const SizedBox(height: 4);
  }
}
