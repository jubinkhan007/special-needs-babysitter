import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../../common/widgets/primary_action_button.dart';
import '../../providers/sitter_profile_setup_providers.dart';
import '../../widgets/bio_text_area_card.dart';
import '../../widgets/dob_dropdown_row.dart';
import '../../widgets/labeled_dropdown_field.dart';
import '../../widgets/onboarding_header.dart';
import '../../widgets/selectable_chip_group.dart';
import '../../widgets/step_progress_dots.dart';
import '../../sitter_profile_constants.dart';
import '../../widgets/transportation_section.dart';
import '../../widgets/willing_to_travel_section.dart';
import 'package:babysitter_app/src/common_widgets/app_toast.dart';

class Step2Bio extends ConsumerWidget {
  final VoidCallback onNext;
  final VoidCallback onBack;

  const Step2Bio({
    super.key,
    required this.onNext,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(sitterProfileSetupControllerProvider);
    final controller = ref.read(sitterProfileSetupControllerProvider.notifier);

    return Scaffold(
      backgroundColor: AppColors.surfaceTint,
      appBar: OnboardingHeader(
        currentStep: 2,
        totalSteps: kSitterProfileTotalSteps,
        onBack: onBack,
      ),
      body: Column(
        children: [
          const StepProgressDots(
              currentStep: 2, totalSteps: kSitterProfileTotalSteps),
          Expanded(
            child: SingleChildScrollView(
              padding:
                  const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BioTextAreaCard(
                    text: state.bio,
                    onChanged: controller.updateBio,
                  ),
                  const SizedBox(height: 24),

                  DobDropdownRow(
                    dob: state.dob,
                    onDateSelected: controller.updateDob,
                  ),
                  const SizedBox(height: 24),

                  SelectableChipGroup(
                    title:
                        'What Age Range(s) Do You Provide Special Needs Care For?',
                    options: const ['Infants', 'Toddlers', 'Children', 'Teens'],
                    selectedValues: state.ageGroups,
                    onSelected: controller.toggleAgeGroup,
                  ),
                  const SizedBox(height: 24),

                  LabeledDropdownField(
                    label: 'Languages Spoken',
                    hint: 'Select Language',
                    value:
                        null, // Temporary: Controller supports list, this is single select dropdown UI
                    items: const ['English', 'Spanish', 'French', 'ASL'],
                    onChanged: (val) {
                      if (val != null) controller.addLanguage(val);
                    },
                  ),
                  // Display selected languages as chips if any
                  if (state.languages.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 12.0),
                      child: Wrap(
                        spacing: 8,
                        children: state.languages
                            .map((lang) => Chip(
                                  label: Text(lang),
                                  onDeleted: () =>
                                      controller.removeLanguage(lang),
                                  backgroundColor: Colors.white,
                                ))
                            .toList(),
                      ),
                    ),
                  const SizedBox(height: 24),

                  LabeledDropdownField(
                    label: 'Years of Experience',
                    hint: 'Select Year',
                    value: state.yearsExperience,
                    items: const [
                      '< 1 year',
                      '1-3 years',
                      '3-5 years',
                      '5+ years'
                    ],
                    onChanged: controller.updateYearsExperience,
                  ),
                  const SizedBox(height: 24),

                  TransportationSection(
                    hasReliableTransportation: state.hasReliableTransportation,
                    details: state.transportationDetails,
                    onToggle: (val) =>
                        controller.updateTransportation(reliable: val),
                    onDetailsChanged: (val) =>
                        controller.updateTransportation(details: val),
                  ),
                  const SizedBox(height: 24),

                  WillingToTravelSection(
                    willingToTravel: state.willingToTravel,
                    overnightStay: state.overnightStay,
                    onWillingChanged: (val) =>
                        controller.updateTravel(willing: val),
                    onOvernightChanged: (val) =>
                        controller.updateTravel(overnight: val),
                  ),

                  // Bottom padding to avoid stickiness overlap if using Stack,
                  // but we are using bottomNavigationBar so standard safe area handling works.
                  const SizedBox(height: 48),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: PrimaryActionButton(
            label: 'Continue',
            onPressed: () {
              if (state.bio.isEmpty) {
                AppToast.show(context, 
                    const SnackBar(content: Text('Please enter a bio')));
                return;
              }
              onNext();
            },
          ),
        ),
      ),
    );
  }
}
