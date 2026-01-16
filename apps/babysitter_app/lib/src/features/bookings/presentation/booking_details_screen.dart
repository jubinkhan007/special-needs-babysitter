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

class BookingDetailsScreen extends ConsumerWidget {
  final BookingDetailsArgs args;

  const BookingDetailsScreen({
    super.key,
    required this.args,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncDetails = ref.watch(bookingDetailsProvider(args.bookingId));

    return asyncDetails.when(
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (err, stack) => Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: Center(child: Text('Failed to load details: $err')),
      ),
      data: (details) {
        final variant = BookingDetailsVariant.fromStatus(details.status);
        final uiModel = BookingDetailsUiModel.fromDomain(details);

        return MediaQuery(
          data:
              MediaQuery.of(context).copyWith(textScaler: TextScaler.noScaling),
          child: Scaffold(
            backgroundColor: AppTokens
                .bookingDetailsHeaderBg, // Use header bg for main to blend
            appBar: BookingDetailsAppBar(title: variant.appBarTitle),
            bottomNavigationBar: BottomCtaBar(
              label: variant.ctaLabel,
              onTap: () {
                if (details.status == BookingStatus.completed) {
                  context.push(
                    Routes.parentReview,
                    extra: ReviewArgs(
                      bookingId: args.bookingId,
                      sitterId:
                          'sitter-123', // Placeholder as BookingDetails domain doesn't expose authId yet.
                      sitterName: details.sitterName,
                      sitterData: uiModel,
                      status: details.status,
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
    }
  }
}
