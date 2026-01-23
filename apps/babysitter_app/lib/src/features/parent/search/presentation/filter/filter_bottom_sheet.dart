import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../theme/app_tokens.dart';
import '../providers/search_filter_provider.dart';
import '../../utils/location_helper.dart';
import 'controller/search_filter_controller.dart';
import 'models/search_filter_ui_model.dart';
import 'widgets/filter_bottom_primary_bar.dart';
import 'widgets/filter_checkbox_row.dart';
import 'widgets/filter_dropdown_field.dart';
import 'widgets/filter_add_other_field.dart';
import 'widgets/filter_section_title.dart';
import 'widgets/filter_text_field.dart';
import 'widgets/hourly_rate_slider.dart';

class FilterBottomSheet extends ConsumerStatefulWidget {
  const FilterBottomSheet({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const FilterBottomSheet(),
    );
  }

  @override
  ConsumerState<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends ConsumerState<FilterBottomSheet> {
  bool _isApplying = false;

  Future<void> _applyFilters() async {
    setState(() {
      _isApplying = true;
    });

    try {
      // Get device location (uses cache if available)
      final (latitude, longitude) = await LocationHelper.getLocation();

      if (mounted) {
        // Update filter provider with location
        final controller = ref.read(searchFilterProvider);
        controller.setLocation(latitude, longitude);

        // Close the modal
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error applying filters: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isApplying = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final filterController = ref.watch(searchFilterProvider);
    final filterState = filterController.value;

    // 8. Responsive/Lock Text Scaling
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(1.0)),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.92,
        decoration: const BoxDecoration(
          color: AppTokens.sheetBg,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(AppTokens.sheetRadiusTop),
            topRight: Radius.circular(AppTokens.sheetRadiusTop),
          ),
        ),
        child: Scaffold(
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
                        value: '${filterState.radius.toInt()} Miles',
                        onTap: () {
                          // TODO: Open radius picker
                        },
                      ),
                      const SizedBox(height: AppTokens.sheetSectionSpacing),

                      // 2. Special Needs Expertise (Dropdown)
                      const FilterSectionTitle('Special Needs Expertise'),
                      FilterDropdownField(
                        hint: 'Select Special Needs Expertise',
                        value: filterState.specialNeedsExpertise,
                        onTap: () {
                          // TODO: Open expertise picker
                        },
                      ),
                      const SizedBox(height: AppTokens.sheetSectionSpacing),

                      // 3. Hourly Rate
                      const FilterSectionTitle('Hourly Rate'),
                      HourlyRateSlider(
                        value: filterState.hourlyRate,
                        onChanged: filterController.setHourlyRate,
                      ),
                      const SizedBox(height: AppTokens.sheetSectionSpacing),

                      // 4. Availability
                      const FilterSectionTitle('Availability'),
                      FilterTextField(
                        hint: 'Date*',
                        value: filterState.date != null
                            ? "${filterState.date!.month}/${filterState.date!.day}"
                            : null,
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
                              value:
                                  filterState.startTime?.format(context),
                              icon: Icons.access_time,
                              onTap: () {
                                // TODO: Open time picker
                              },
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: FilterTextField(
                              hint: 'End Time*',
                              value: filterState.endTime?.format(context),
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
                                    filterState.selectedExpertise.contains(e),
                                onChanged: (_) =>
                                    filterController.toggleExpertise(e),
                              ))
                          .toList(),
                      const SizedBox(height: AppTokens.sheetSectionSpacing),

                      // 6. Languages Spoken
                      const FilterSectionTitle('Languages Spoken'),
                      ...['Spanish', 'English', 'Mandarin', 'French']
                          .map((e) => FilterCheckboxRow(
                                label: e,
                                isChecked:
                                    filterState.selectedLanguages.contains(e),
                                onChanged: (_) =>
                                    filterController.toggleLanguage(e),
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
            label: _isApplying ? 'Getting location...' : 'Show 6 Results',
            onTap: _isApplying ? null : _applyFilters,
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
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
              color: AppTokens.iconGrey,
            ),
          ),
        ],
      ),
    );
  }
}
