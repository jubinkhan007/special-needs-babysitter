import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import '../../data/providers/booking_flow_provider.dart';
import '../../data/providers/bookings_di.dart';
import '../theme/booking_ui_tokens.dart';
import '../widgets/booking_top_bar.dart';
import '../widgets/payment_detail_row.dart';
import '../widgets/payment_method_sheet.dart';
import '../widgets/dashed_divider.dart';
import 'booking_request_sent_screen.dart';

class ServiceDetailsScreen extends ConsumerStatefulWidget {
  const ServiceDetailsScreen({super.key});

  @override
  ConsumerState<ServiceDetailsScreen> createState() =>
      _ServiceDetailsScreenState();
}

class _ServiceDetailsScreenState extends ConsumerState<ServiceDetailsScreen> {
  bool _isLoading = false;

  Future<void> _onSubmit() async {
    final bookingState = ref.read(bookingFlowProvider);
    final repository = ref.read(bookingsRepositoryProvider);
    final selectedPaymentMethod = bookingState.selectedPaymentMethod;

    setState(() {
      _isLoading = true;
    });

    try {
      final payload = bookingState.toDirectBookingPayload();
      print('DEBUG: ServiceDetailsScreen submitting booking: $payload');

      final result = await repository.createDirectBooking(payload);

      print('DEBUG: ServiceDetailsScreen booking created: ${result.message}');
      print(
          'DEBUG: ServiceDetailsScreen applicationId: ${result.applicationId}');

      // If Stripe is selected, create payment intent
      if (selectedPaymentMethod == 'Stripe') {
        print('DEBUG: Creating Stripe payment intent...');
        final paymentIntent =
            await repository.createPaymentIntent(result.applicationId);
        print(
            'DEBUG: Payment intent created: ${paymentIntent.paymentIntentId}');

        // Initialize Stripe Payment Sheet
        await Stripe.instance.initPaymentSheet(
          paymentSheetParameters: SetupPaymentSheetParameters(
            paymentIntentClientSecret: paymentIntent.clientSecret,
            merchantDisplayName: 'Special Needs Sitters',
            // style: ThemeMode.light, // Optional: customize style
          ),
        );

        // Present Stripe Payment Sheet
        await Stripe.instance.presentPaymentSheet();
        print('DEBUG: Payment completed successfully');
      }

      if (mounted) {
        // Reset booking state after successful creation
        ref.read(bookingFlowProvider.notifier).reset();

        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const BookingRequestSentScreen(),
          ),
        );
      }
    } catch (e) {
      print('DEBUG: ServiceDetailsScreen booking error: $e');
      if (mounted) {
        String errorMessage = 'Failed to create booking';
        if (e is StripeException) {
          errorMessage =
              'Payment cancelled or failed: ${e.error.localizedMessage}';
        } else {
          errorMessage = 'Error: ${e.toString()}';
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: const Color(0xFFD92D20),
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
                  height: 280 + MediaQuery.of(context).padding.bottom,
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
