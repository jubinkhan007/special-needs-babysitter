import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../theme/app_tokens.dart';
import 'controller/search_filter_controller.dart';
import 'models/search_filter_ui_model.dart';
import 'widgets/filter_bottom_primary_bar.dart';
import 'widgets/filter_checkbox_row.dart';
import 'widgets/filter_dropdown_field.dart';
import 'widgets/filter_add_other_field.dart';
import 'widgets/filter_section_title.dart';
import 'widgets/filter_text_field.dart';
import 'widgets/hourly_rate_slider.dart';

class FilterBottomSheet extends StatefulWidget {
  final SearchFilterController controller;

  const FilterBottomSheet({super.key, required this.controller});

  static Future<void> show(
      BuildContext context, SearchFilterController controller) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => FilterBottomSheet(controller: controller),
    );
  }

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  // Local state or listen to controller?
  // Since controller is ValueNotifier, we can wrap body in ValueListenableBuilder or AnimatedBuilder.

  @override
  Widget build(BuildContext context) {
    // 8. Responsive/Lock Text Scaling
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(1.0)),
      child: Container(
        height: MediaQuery.of(context).size.height *
            0.92, // High sheet like screenshot
        decoration: const BoxDecoration(
          color: AppTokens.sheetBg,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(AppTokens.sheetRadiusTop),
            topRight: Radius.circular(AppTokens.sheetRadiusTop),
          ),
        ),
        child: AnimatedBuilder(
          animation: widget.controller,
          builder: (context, child) {
            final model = widget.controller.value;
            return Scaffold(
              backgroundColor: Colors.transparent,
              body: Column(
                children: [
                  // Header
                  _buildHeader(context),

                  // Scrollable Content
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppTokens.sheetHorizontalPadding,
                        vertical: AppTokens.sheetTopPadding,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // 1. Travel Radius
                          const FilterSectionTitle('Travel Radius'),
                          FilterDropdownField(
                            hint: 'Select a radius',
                            value:
                                '${model.radius.toInt()} Miles', // Example formatting
                            onTap: () {
                              // TODO: Open radius picker
                            },
                          ),
                          const SizedBox(height: AppTokens.sheetSectionSpacing),

                          // 2. Special Needs Expertise (Dropdown)
                          const FilterSectionTitle('Special Needs Expertise'),
                          FilterDropdownField(
                            hint: 'Select Special Needs Expertise',
                            value: model.specialNeedsExpertise,
                            onTap: () {
                              // TODO: Open expertise picker
                            },
                          ),
                          const SizedBox(height: AppTokens.sheetSectionSpacing),

                          // 3. Hourly Rate
                          const FilterSectionTitle('Hourly Rate'),
                          HourlyRateSlider(
                            value: model.hourlyRate,
                            onChanged: widget.controller.setHourlyRate,
                          ),
                          const SizedBox(height: AppTokens.sheetSectionSpacing),

                          // 4. Availability
                          const FilterSectionTitle('Availability'),
                          FilterTextField(
                            hint: 'Date*',
                            value: model.date != null
                                ? "${model.date!.month}/${model.date!.day}"
                                : null, // Simple formatting
                            icon: Icons.calendar_today_outlined,
                            onTap: () {
                              // TODO: Open date picker
                            },
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                child: FilterTextField(
                                  hint: 'Start Time*',
                                  value: model.startTime?.format(context),
                                  icon: Icons.access_time, // Clock icon
                                  onTap: () {
                                    // TODO: Open time picker
                                  },
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: FilterTextField(
                                  hint: 'End Time*',
                                  value: model.endTime?.format(context),
                                  icon: Icons.access_time,
                                  onTap: () {
                                    // TODO: Open time picker
                                  },
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: AppTokens.sheetSectionSpacing),

                          // 5. Special Needs Expertise (Checkboxes)
                          const FilterSectionTitle('Special Needs Expertise'),
                          ...['Infants', 'Toddlers', 'Children', 'Teens']
                              .map((e) => FilterCheckboxRow(
                                    label: e,
                                    isChecked:
                                        model.selectedExpertise.contains(e),
                                    onChanged: (_) =>
                                        widget.controller.toggleExpertise(e),
                                  ))
                              .toList(),
                          const SizedBox(height: AppTokens.sheetSectionSpacing),

                          // 6. Languages Spoken
                          const FilterSectionTitle('Languages Spoken'),
                          ...['Spanish', 'English', 'Mandarin', 'French']
                              .map((e) => FilterCheckboxRow(
                                    label: e,
                                    isChecked:
                                        model.selectedLanguages.contains(e),
                                    onChanged: (_) =>
                                        widget.controller.toggleLanguage(e),
                                  ))
                              .toList(),
                          // Add Other
                          FilterAddOtherField(onTap: () {}),

                          // Extra space at bottom
                          const SizedBox(height: 100),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              bottomNavigationBar: FilterBottomPrimaryBar(
                label: 'Show 6 Results',
                onTap: () => Navigator.pop(context),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 0), // Top space
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Filter By',
            style: AppTokens.sheetTitleStyle,
          ),
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Icon(
              Icons.close,
              size: 24,
              color: AppTokens.iconGrey, // Close icon color
            ),
          ),
        ],
      ),
    );
  }
}
