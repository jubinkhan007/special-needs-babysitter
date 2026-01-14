import 'package:flutter/material.dart';
import '../../../../theme/app_tokens.dart';
import '../../domain/applications/booking_application.dart';
import '../widgets/jobs_app_bar.dart'; // Reuse
import '../job_details/widgets/section_title.dart'; // Reuse
import '../job_details/widgets/key_value_row.dart'; // Reuse
import 'models/booking_application_ui_model.dart';
import 'widgets/sitter_header_card.dart';
import 'widgets/dashed_divider.dart';
import 'widgets/transport_preferences_table.dart';
import 'widgets/bottom_decision_bar.dart';

class BookingApplicationScreen extends StatelessWidget {
  final BookingApplication application;

  const BookingApplicationScreen({
    super.key,
    required this.application,
  });

  @override
  Widget build(BuildContext context) {
    final ui = BookingApplicationUiModel.fromDomain(application);

    return Scaffold(
      backgroundColor: AppTokens.applicationsBg,
      appBar: const JobsAppBar(
        title: 'Booking Application',
        showSupportIcon:
            true, // Shows headset/lock if icon changed, logic internally
        // Note: Figma showed Lock icon. JobsAppBar might need 'rightIcon' param or we stick to standard.
        // Assuming JobsAppBar logic for now or refactoring if strict match needed.
        // Let's assume right icon is acceptable as is or we'd need to modify JobsAppBar further.
        // For pixel perfect match to screenshot showing 'Headset' (wait, screenshot showed HEADSET in top right? no, screenshot shows Headset!)
        // Screenshot header: Back Arrow, "Booking Application", Headset Icon.
        // So showSupportIcon: true is correct.
      ),
      body: MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaler: TextScaler.noScaling),
        child: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppTokens.applicationsHorizontalPadding,
              ),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  const SizedBox(height: AppTokens.sectionTopGap),

                  // A) Sitter Summary Card
                  SitterHeaderCard(ui: ui),

                  const SizedBox(height: AppTokens.sectionGap),

                  // B) Cover Letter
                  const SectionTitle(title: 'Cover Letter'),
                  const SizedBox(height: 12),
                  const DashedDivider(),
                  const SizedBox(height: 16),
                  Text(
                    ui.coverLetter,
                    style: AppTokens.bodyParagraphStyle,
                  ),
                  const SizedBox(height: 16),
                  const DashedDivider(),

                  const SizedBox(height: AppTokens.sectionGap),

                  // C) Service Details
                  const SectionTitle(title: 'Service Details'),
                  const SizedBox(height: 12),
                  const DashedDivider(),
                  const SizedBox(height: 16),
                  KeyValueRow(label: 'Family Name', value: ui.familyName),
                  KeyValueRow(
                      label: 'No. Of Children', value: ui.numberOfChildrenText),
                  KeyValueRow(label: 'Date', value: ui.dateRangeText),
                  KeyValueRow(label: 'Time', value: ui.timeRangeText),
                  KeyValueRow(label: 'Hourly Rate', value: ui.hourlyRateText),
                  KeyValueRow(label: 'No of Days', value: ui.numberOfDaysText),
                  KeyValueRow(
                      label: 'Additional Notes',
                      value: ui.additionalNotes,
                      isMultiline: true),
                  KeyValueRow(
                      label: 'Address', value: ui.address, isMultiline: true),
                  const SizedBox(height: 16),
                  const DashedDivider(),

                  const SizedBox(height: AppTokens.sectionGap),

                  // D) Transportation Preferences
                  Text('Transportation Preferences (Optional)',
                      style: AppTokens.sectionTitleStyle),
                  const SizedBox(height: 16),
                  TransportPreferencesTable(
                    modes: ui.transportationModes,
                    equipment: ui.equipmentAndSafety,
                    pickupDetails: ui.pickupDropoffDetails,
                  ),
                  const SizedBox(height: 16),
                  const DashedDivider(),

                  const SizedBox(height: AppTokens.pageBottomSpacer),
                ]),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomDecisionBar(
        primaryLabel: 'Accept',
        secondaryLabel: 'Reject',
        onPrimary: () {},
        onSecondary: () {},
      ),
    );
  }
}
