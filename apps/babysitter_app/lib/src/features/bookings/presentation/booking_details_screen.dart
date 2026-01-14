import 'package:flutter/material.dart';
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

class BookingDetailsScreen extends StatelessWidget {
  final BookingDetailsArgs args;

  const BookingDetailsScreen({
    super.key,
    required this.args,
  });

  @override
  Widget build(BuildContext context) {
    // 1. Resolve Data & Variant (in real app, use Riverpod provider)
    final details = _getDetailsForId(args.bookingId, args.status);
    final variant = BookingDetailsVariant.fromStatus(details.status);
    final uiModel = BookingDetailsUiModel.fromDomain(details);

    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaler: TextScaler.noScaling),
      child: Scaffold(
        backgroundColor:
            AppTokens.bookingDetailsHeaderBg, // Use header bg for main to blend
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
                      'sitter-123', // Dummy ID as BookingDetails doesn't have it yet
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
                      child:
                          DashedDivider(color: AppTokens.bookingDetailsDivider),
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
                // Although Scaffold body ends above bottomNavigationBar usually,
                // explicit padding helps visual balance.
                const SliverPadding(padding: EdgeInsets.only(bottom: 24)),
              ],
            )),
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
            label: 'No. Of Children',
            value: uiModel
                .numberOfChildren); // Figma says "No. Of Child" in completed? "No. Of Children" in others. Using "No. Of Children" generically or adjust logic. Figma completed: "No. Of Child" (singular). Let's stick to consistent text or map it.
      // If I want exact text match per screen:
      // upcoming/pending: "No. Of Children"
      // completed: "No. Of Child"
      // I'll stick to 'No. Of Children' for now unless strictly requested.
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
      case PaymentFieldType
            .hourlyRate: // Reusing logic if needed in payment block
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

  // Dummy Data Generator matching Figma
  BookingDetails _getDetailsForId(String id, BookingStatus? statusHint) {
    final status = statusHint ?? BookingStatus.upcoming;

    // Common Base
    const krystina = 'Krystina';
    const avatar = 'assets/images/avatars/avatar_krystina.png'; // Use asset
    const address =
        '7448, Kub Oval, 2450 Brian Meadow, District of Columbia, Lake Edna';

    // Figma Data
    // Upcoming: 14 Aug - 17 Aug, 3 Kids
    if (status == BookingStatus.upcoming || status == BookingStatus.active) {
      return BookingDetails(
        id: id,
        sitterName: krystina,
        avatarUrl: avatar,
        isVerified: true,
        rating: 4.5,
        responseRate: 95,
        reliabilityRate: 95,
        experienceText: '5 Years',
        distanceText: '2 Miles Away',
        status: BookingStatus.upcoming,
        familyName: 'Smith',
        numberOfChildren: 3,
        startDate: DateTime(2025, 8, 14),
        endDate: DateTime(2025, 8, 17),
        startTime: DateTime(2025, 1, 1, 9, 0), // 09 AM
        endTime: DateTime(2025, 1, 1, 18, 0), // 06 PM
        hourlyRate: 20,
        numberOfDays: 4,
        additionalNotes: 'We Have Two Black Cats',
        address: address,
        skills: ['CPR', 'First-aid', 'Special Needs Training'],
      );
    }

    // Pending: Same data
    if (status == BookingStatus.pending) {
      return BookingDetails(
        id: id,
        sitterName: krystina,
        avatarUrl: avatar,
        isVerified: true,
        rating: 4.5,
        responseRate: 95,
        reliabilityRate: 95,
        experienceText: '5 Years',
        distanceText: '2 Miles Away',
        status: BookingStatus.pending,
        familyName: 'Smith',
        numberOfChildren: 3,
        startDate: DateTime(2025, 8, 14),
        endDate: DateTime(2025, 8, 17),
        startTime: DateTime(2025, 1, 1, 9, 0),
        endTime: DateTime(2025, 1, 1, 18, 0),
        hourlyRate: 20,
        numberOfDays: 4,
        additionalNotes: 'We Have Two Black Cats',
        address: address,
        skills: ['CPR', 'First-aid', 'Special Needs Training'],
      );
    }

    // Completed: Payment details added. No Family Name/Notes/Hourly in service list (handled by variant config)
    if (status == BookingStatus.completed) {
      return BookingDetails(
        id: id,
        sitterName: krystina,
        avatarUrl: avatar,
        isVerified: true,
        rating: 4.5,
        responseRate: 95,
        reliabilityRate: 95,
        experienceText: '5 Years',
        distanceText: '2 Miles Away',
        status: BookingStatus.completed,
        familyName: 'Smith',
        numberOfChildren: 3,
        startDate: DateTime(2025, 8, 14),
        endDate: DateTime(2025, 8, 17),
        startTime: DateTime(2025, 1, 1, 9, 0),
        endTime: DateTime(2025, 1, 1, 18, 0),
        hourlyRate: 20,
        numberOfDays: 4,
        additionalNotes: 'We Have Two Black Cats',
        address: address,
        skills: ['CPR', 'First-aid', 'Special Needs Training'],
        // Payment
        subTotal: 300,
        totalHours: 40,
        platformFee: 20,
        discount: 0,
      );
    }

    // Fallback
    return BookingDetails(
      id: id,
      sitterName: 'Unknown',
      avatarUrl: avatar,
      isVerified: false,
      rating: 0,
      responseRate: 0,
      reliabilityRate: 0,
      experienceText: '-',
      distanceText: '-',
      status: status,
      familyName: '-',
      numberOfChildren: 0,
      startDate: DateTime.now(),
      endDate: DateTime.now(),
      startTime: DateTime.now(),
      endTime: DateTime.now(),
      hourlyRate: 0,
      numberOfDays: 0,
      address: '-',
    );
  }
}
