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
  final List<int> _radiusOptions = const [5, 10, 15, 25, 50];
  final List<String> _expertiseOptions = const [
    'Autism',
    'ADHD',
    'Down Syndrome',
    'Cerebral Palsy',
    'Behavioral',
  ];
  static const _pickerBackground = Color(0xFFEAF6FF);
  static const _pickerTitle = Color(0xFF0B1736);
  static const _pickerMuted = Color(0xFF667085);
  static const _pickerAccent = Color(0xFF88CBE6);

  Future<void> _applyFilters() async {
    setState(() {
      _isApplying = true;
    });

    try {
      // Get device location (uses cache if available)
      final (latitude, longitude) =
          await LocationHelper.getLocation(requestPermission: true);

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

  Future<void> _pickRadius(SearchFilterController controller) async {
    final selected = await showModalBottomSheet<int>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return SafeArea(
          child: ListView.separated(
            shrinkWrap: true,
            itemCount: _radiusOptions.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final radius = _radiusOptions[index];
              return ListTile(
                title: Text(
                  '$radius Miles',
                  style: const TextStyle(color: Colors.black87),
                ),
                onTap: () => Navigator.pop(context, radius),
              );
            },
          ),
        );
      },
    );

    if (selected != null) {
      controller.setRadius(selected.toDouble());
    }
  }

  Future<void> _pickExpertise(SearchFilterController controller) async {
    final selected = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return SafeArea(
          child: ListView.separated(
            shrinkWrap: true,
            itemCount: _expertiseOptions.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final option = _expertiseOptions[index];
              return ListTile(
                title: Text(
                  option,
                  style: const TextStyle(color: Colors.black87),
                ),
                onTap: () => Navigator.pop(context, option),
              );
            },
          ),
        );
      },
    );

    if (selected != null) {
      controller.setSpecialNeedsExpertise(selected);
    }
  }

  Future<void> _pickDate(SearchFilterController controller) async {
    final now = DateTime.now();
    final selected = await showDatePicker(
      context: context,
      initialDate: controller.value.date ?? now,
      firstDate: now.subtract(const Duration(days: 1)),
      lastDate: now.add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: _pickerAccent,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: _pickerTitle,
            ),
            datePickerTheme: DatePickerThemeData(
              backgroundColor: Colors.white,
              headerBackgroundColor: Colors.white,
              headerForegroundColor: _pickerTitle,
              todayBorder: const BorderSide(color: _pickerAccent, width: 2),
              todayForegroundColor:
                  const MaterialStatePropertyAll(_pickerAccent),
              todayBackgroundColor:
                  MaterialStatePropertyAll(_pickerAccent.withOpacity(0.15)),
              dayForegroundColor: MaterialStateProperty.resolveWith((states) {
                if (states.contains(MaterialState.selected)) {
                  return Colors.white;
                }
                return _pickerTitle;
              }),
              dayOverlayColor:
                  MaterialStatePropertyAll(_pickerAccent.withOpacity(0.1)),
              yearForegroundColor: const MaterialStatePropertyAll(_pickerTitle),
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: _pickerTitle,
                textStyle: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (selected != null) {
      controller.setDate(selected);
    }
  }

  Future<void> _pickTime(
    SearchFilterController controller, {
    required bool isStart,
  }) async {
    final initial = isStart
        ? controller.value.startTime ?? TimeOfDay.now()
        : controller.value.endTime ?? TimeOfDay.now();
    final selected = await showTimePicker(
      context: context,
      initialTime: initial,
      initialEntryMode: TimePickerEntryMode.input,
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
          child: Theme(
            data: Theme.of(context).copyWith(
              textTheme: Theme.of(context).textTheme.copyWith(
                    bodySmall: const TextStyle(color: _pickerTitle),
                    bodyMedium: const TextStyle(color: _pickerTitle),
                    displayLarge: const TextStyle(color: _pickerTitle),
                    displayMedium: const TextStyle(color: _pickerTitle),
                    displaySmall: const TextStyle(color: _pickerTitle),
                    titleMedium: const TextStyle(color: _pickerTitle),
                    labelSmall: const TextStyle(color: _pickerTitle),
                  ),
              colorScheme: const ColorScheme.light(
                primary: _pickerAccent,
                onPrimary: Colors.white,
                surface: _pickerBackground,
                onSurface: _pickerTitle,
                secondary: _pickerAccent,
                onSurfaceVariant: _pickerTitle,
                outline: _pickerAccent,
              ),
              timePickerTheme: TimePickerThemeData(
                backgroundColor: _pickerBackground,
                helpTextStyle: const TextStyle(
                  color: _pickerTitle,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
                entryModeIconColor: _pickerTitle,
                hourMinuteShape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: const BorderSide(color: _pickerAccent, width: 2),
                ),
                dayPeriodBorderSide: const BorderSide(color: _pickerMuted),
                dayPeriodColor: WidgetStateColor.resolveWith((states) =>
                    states.contains(WidgetState.selected)
                        ? _pickerAccent.withOpacity(0.3)
                        : Colors.transparent),
                dayPeriodTextColor: WidgetStateColor.resolveWith((states) =>
                    states.contains(WidgetState.selected)
                        ? _pickerTitle
                        : _pickerMuted),
                hourMinuteColor: WidgetStateColor.resolveWith((states) =>
                    states.contains(WidgetState.selected)
                        ? Colors.white
                        : _pickerAccent.withOpacity(0.1)),
                hourMinuteTextColor: WidgetStateColor.resolveWith((states) =>
                    states.contains(WidgetState.selected)
                        ? _pickerTitle
                        : _pickerMuted),
                inputDecorationTheme: const InputDecorationTheme(
                  labelStyle: TextStyle(color: _pickerTitle),
                  helperStyle: TextStyle(color: _pickerTitle),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.zero,
                ),
              ),
              textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(
                  foregroundColor: _pickerTitle,
                  textStyle: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
            child: child!,
          ),
        );
      },
    );

    if (selected != null) {
      if (isStart) {
        controller.setStartTime(selected);
      } else {
        controller.setEndTime(selected);
      }
    }
  }

  Future<void> _addOtherLanguage(SearchFilterController controller) async {
    var draft = controller.value.otherLanguage ?? '';
    final result = await showDialog<String>(
      context: context,
      builder: (context) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: _pickerAccent,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: _pickerTitle,
            ),
            dialogBackgroundColor: Colors.white,
          ),
          child: AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: const Text(
              'Add Other Language',
              style: TextStyle(
                color: _pickerTitle,
                fontWeight: FontWeight.w700,
              ),
            ),
            content: TextFormField(
              initialValue: draft,
              onChanged: (value) => draft = value,
              style: const TextStyle(color: _pickerTitle),
              decoration: InputDecoration(
                hintText: 'Enter language',
                hintStyle: const TextStyle(color: _pickerMuted),
                filled: true,
                fillColor: _pickerBackground,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: _pickerAccent),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: _pickerAccent, width: 2),
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, draft),
                child: const Text('Save'),
              ),
            ],
          ),
        );
      },
    );

    if (result != null) {
      controller.setOtherLanguage(
        result.trim().isEmpty ? null : result.trim(),
      );
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
                        onTap: () => _pickRadius(filterController),
                      ),
                      const SizedBox(height: AppTokens.sheetSectionSpacing),

                      // 2. Special Needs Expertise (Dropdown)
                      const FilterSectionTitle('Special Needs Expertise'),
                      FilterDropdownField(
                        hint: 'Select Special Needs Expertise',
                        value: filterState.specialNeedsExpertise,
                        onTap: () => _pickExpertise(filterController),
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
                        onTap: () => _pickDate(filterController),
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
                              onTap: () =>
                                  _pickTime(filterController, isStart: true),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: FilterTextField(
                              hint: 'End Time*',
                              value: filterState.endTime?.format(context),
                              icon: Icons.access_time,
                              onTap: () =>
                                  _pickTime(filterController, isStart: false),
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
                      FilterAddOtherField(
                        onTap: () => _addOtherLanguage(filterController),
                        value: filterState.otherLanguage,
                      ),

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
            onTap: _isApplying
                ? null
                : () {
                    _applyFilters();
                  },
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
