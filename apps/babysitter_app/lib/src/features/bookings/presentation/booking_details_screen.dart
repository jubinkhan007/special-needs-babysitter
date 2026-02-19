import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../routing/routes.dart';
import '../domain/review/review_args.dart';
import '../../../theme/app_tokens.dart';
import '../domain/booking_details.dart';
import '../domain/booking_status.dart';
import 'models/booking_details_ui_model.dart';
import 'models/booking_details_variant.dart';
import 'widgets/booking_details_app_bar.dart';
import 'widgets/bottom_cta_bar.dart';
import 'widgets/dashed_divider.dart';
import 'widgets/key_value_row.dart';
import 'widgets/section_header_row.dart';
import 'widgets/sitter_details_card.dart';
import 'providers/booking_details_provider.dart';
import '../../parent/booking_flow/data/providers/bookings_di.dart';
import '../application/bookings_controller.dart';
import 'package:babysitter_app/src/common_widgets/app_toast.dart';
import '../../messages/domain/chat_thread_args.dart';

class BookingDetailsScreen extends ConsumerStatefulWidget {
  final BookingDetailsArgs args;

  const BookingDetailsScreen({
    super.key,
    required this.args,
  });

  @override
  ConsumerState<BookingDetailsScreen> createState() =>
      _BookingDetailsScreenState();
}

class _BookingDetailsScreenState extends ConsumerState<BookingDetailsScreen> {
  bool _isCancelling = false;

  Future<void> _cancelBooking(String bookingId) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        title:
            const Text('Cancel Booking', style: TextStyle(color: Colors.black)),
        content: const Text(
          'Are you sure you want to cancel this booking? This action cannot be undone.',
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          TextButton(
            onPressed: () => context.pop(false),
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () => context.pop(true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Yes, Cancel'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    setState(() => _isCancelling = true);

    try {
      final repo = ref.read(bookingsRepositoryProvider);
      await repo.cancelDirectBooking(bookingId);

      // Invalidate bookings list to refresh
      ref.invalidate(bookingsControllerProvider);

      if (mounted) {
        AppToast.show(context, 
          const SnackBar(
            content: Text('Booking cancelled successfully'),
            backgroundColor: Colors.green,
          ),
        );
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        AppToast.show(context, 
          SnackBar(
            content: Text('Error cancelling booking: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isCancelling = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final asyncDetails =
        ref.watch(bookingDetailsProvider(widget.args.bookingId));

    return asyncDetails.when(
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (err, stack) => Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: Center(child: Text('Failed to load details: $err')),
      ),
      data: (details) {
        // Debug: Log booking details data
        debugPrint('DEBUG BookingDetailsScreen: ======= BookingDetails received =======');
        debugPrint('DEBUG BookingDetailsScreen: id = ${details.id}');
        debugPrint('DEBUG BookingDetailsScreen: sitterId = ${details.sitterId}');
        debugPrint('DEBUG BookingDetailsScreen: sitterName = "${details.sitterName}"');
        debugPrint('DEBUG BookingDetailsScreen: sitterName length = ${details.sitterName.length}');
        debugPrint('DEBUG BookingDetailsScreen: sitterName contains DioException = ${details.sitterName.contains('DioException')}');
        debugPrint('DEBUG BookingDetailsScreen: status = ${details.status}');
        debugPrint('DEBUG BookingDetailsScreen: skills = ${details.skills}');
        debugPrint('DEBUG BookingDetailsScreen: =====================================');
        final variant = BookingDetailsVariant.fromStatus(details.status);
        final uiModel = BookingDetailsUiModel.fromDomain(details);
        final isPending = details.status == BookingStatus.pending;

        return MediaQuery(
          data:
              MediaQuery.of(context).copyWith(textScaler: TextScaler.noScaling),
          child: Scaffold(
            backgroundColor: AppTokens
                .bookingDetailsHeaderBg, // Use header bg for main to blend
            appBar: BookingDetailsAppBar(title: variant.appBarTitle),
            bottomNavigationBar: _isCancelling
                ? Container(
                    color: AppTokens.surfaceWhite,
                    child: const SafeArea(
                      top: false,
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Center(child: CircularProgressIndicator()),
                      ),
                    ),
                  )
                : isPending
                    ? _buildPendingBottomBar(details)
                    : BottomCtaBar(
                        label: variant.ctaLabel,
                        onTap: () {
                          if (details.status == BookingStatus.completed) {
                            context.push(
                              Routes.parentReview,
                              extra: ReviewArgs(
                                bookingId: widget.args.bookingId,
                                sitterId: details.sitterId,
                                sitterName: details.sitterName,
                                sitterData: uiModel,
                                status: details.status,
                                jobId: details.jobId,
                              ),
                            );
                          }
                        },
                      ),
            body: Container(
                color: AppTokens.screenBg, // Body bg
                child: CustomScrollView(
                  slivers: [
                    // Sitter Card
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppTokens.screenHorizontalPadding,
                        vertical: 24,
                      ),
                      sliver: SliverToBoxAdapter(
                        child: SitterDetailsCard(uiModel: uiModel),
                      ),
                    ),

                    // Service Details Header
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: AppTokens.screenHorizontalPadding),
                      sliver: SliverToBoxAdapter(
                        child: SectionHeaderRow(
                          title: 'Service Details',
                          status: details.status,
                        ),
                      ),
                    ),

                    // Service Details List
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: AppTokens.screenHorizontalPadding),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            final field = variant.visibleServiceFields[index];
                            return _buildServiceRow(field, uiModel);
                          },
                          childCount: variant.visibleServiceFields.length,
                        ),
                      ),
                    ),

                    // Payment Details Block (Completed Only)
                    if (variant.showPaymentBlock) ...[
                      const SliverPadding(
                        padding: EdgeInsets.symmetric(
                          horizontal: AppTokens.screenHorizontalPadding,
                          vertical: 8, // Spacing before divider
                        ),
                        sliver: SliverToBoxAdapter(
                          child: DashedDivider(
                              color: AppTokens.bookingDetailsDivider),
                        ),
                      ),

                      // Spacer after divider
                      const SliverPadding(padding: EdgeInsets.only(bottom: 24)),

                      SliverPadding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: AppTokens.screenHorizontalPadding),
                        sliver: SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              final field = variant.visiblePaymentFields[index];
                              return _buildPaymentRow(field, uiModel);
                            },
                            childCount: variant.visiblePaymentFields.length,
                          ),
                        ),
                      ),
                    ],

                    // Bottom Spacer to prevent content hiding behind sticky CTA
                    const SliverPadding(padding: EdgeInsets.only(bottom: 24)),
                  ],
                )),
          ),
        );
      },
    );
  }

  Widget _buildPendingBottomBar(BookingDetails details) {
    return Container(
      color: AppTokens.surfaceWhite,
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppTokens.screenHorizontalPadding,
            vertical: 16,
          ),
          child: Row(
            children: [
              // Message Button
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    if (details.sitterId.isNotEmpty) {
                      final args = ChatThreadArgs(
                        otherUserId: details.sitterId,
                        otherUserName: details.sitterName,
                        otherUserAvatarUrl: details.avatarUrl,
                        isVerified: details.isVerified,
                      );
                      context.push(
                        '/parent/messages/chat/${details.sitterId}',
                        extra: args,
                      );
                    }
                  },
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(double.infinity, AppTokens.buttonHeight),
                    side: const BorderSide(color: AppTokens.primaryBlue),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(AppTokens.buttonRadius),
                    ),
                  ),
                  child: const Text(
                    'Message',
                    style: TextStyle(
                      color: AppTokens.primaryBlue,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // Cancel Button
              Expanded(
                child: ElevatedButton(
                  onPressed: () => _cancelBooking(details.id),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, AppTokens.buttonHeight),
                    backgroundColor: Colors.red,
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(AppTokens.buttonRadius),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Cancel Booking',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildServiceRow(
      ServiceFieldType field, BookingDetailsUiModel uiModel) {
    switch (field) {
      case ServiceFieldType.familyName:
        return KeyValueRow(label: 'Family Name', value: uiModel.familyName);
      case ServiceFieldType.numberOfChildren:
        return KeyValueRow(
            label: 'No. Of Children', value: uiModel.numberOfChildren);
      case ServiceFieldType.date:
        return KeyValueRow(label: 'Date', value: uiModel.dateRange);
      case ServiceFieldType.time:
        return KeyValueRow(label: 'Time', value: uiModel.timeRange);
      case ServiceFieldType.hourlyRate:
        return KeyValueRow(label: 'Hourly Rate', value: uiModel.hourlyRate);
      case ServiceFieldType.numberOfDays:
        return KeyValueRow(label: 'No of Days', value: uiModel.numberOfDays);
      case ServiceFieldType.additionalNotes:
        return KeyValueRow(
            label: 'Additional Notes', value: uiModel.additionalNotes);
      case ServiceFieldType.address:
        return KeyValueRow(label: 'Address', value: uiModel.address);
    }
  }

  Widget _buildPaymentRow(
      PaymentFieldType field, BookingDetailsUiModel uiModel) {
    switch (field) {
      case PaymentFieldType.subTotal:
        return KeyValueRow(label: 'Sub Total', value: uiModel.subTotal);
      case PaymentFieldType.totalHours:
        return KeyValueRow(label: 'Total Hours', value: uiModel.totalHours);
      case PaymentFieldType.hourlyRate:
        return KeyValueRow(label: 'Hourly Rate', value: uiModel.hourlyRate);
      case PaymentFieldType.platformFee:
        return KeyValueRow(label: 'Platform Fee', value: uiModel.platformFee);
      case PaymentFieldType.discount:
        return KeyValueRow(label: 'Discount', value: uiModel.discount);
      case PaymentFieldType.estimatedTotal:
        return KeyValueRow(
          label: 'Estimated Total Cost',
          value: uiModel.estimatedTotalCost,
          isTotal: true,
        );
      case PaymentFieldType.actualMinutesWorked:
        if (uiModel.actualMinutesWorked == null) return const SizedBox.shrink();
        return KeyValueRow(
          label: 'Actual Minutes Worked', 
          value: uiModel.actualMinutesWorked!,
        );
      case PaymentFieldType.actualHoursWorked:
        if (uiModel.actualHoursWorked == null) return const SizedBox.shrink();
        return KeyValueRow(
          label: 'Actual Hours Worked', 
          value: uiModel.actualHoursWorked!,
        );
      case PaymentFieldType.actualPayout:
        if (uiModel.actualPayout == null) return const SizedBox.shrink();
        return KeyValueRow(
          label: 'Actual Payout to Sitter', 
          value: uiModel.actualPayout!,
        );
      case PaymentFieldType.totalCharged:
        if (uiModel.totalCharged == null) return const SizedBox.shrink();
        return KeyValueRow(
          label: 'Total Charged', 
          value: uiModel.totalCharged!,
        );
      case PaymentFieldType.refundAmount:
        if (uiModel.refundAmount == null) return const SizedBox.shrink();
        return KeyValueRow(
          label: 'Refund Amount', 
          value: uiModel.refundAmount!,
        );
      case PaymentFieldType.paymentStatus:
        if (uiModel.paymentStatus == null) return const SizedBox.shrink();
        return KeyValueRow(
          label: 'Payment Status', 
          value: uiModel.paymentStatus!,
        );
      case PaymentFieldType.clockInTimeActual:
        if (uiModel.clockInTimeActual == null) return const SizedBox.shrink();
        return KeyValueRow(
          label: 'Clock In Time', 
          value: uiModel.clockInTimeActual!,
        );
      case PaymentFieldType.clockOutTimeActual:
        if (uiModel.clockOutTimeActual == null) return const SizedBox.shrink();
        return KeyValueRow(
          label: 'Clock Out Time', 
          value: uiModel.clockOutTimeActual!,
        );
    }
  }
}
