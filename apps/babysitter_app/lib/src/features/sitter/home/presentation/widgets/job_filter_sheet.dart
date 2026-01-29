import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import '../../domain/entities/job_search_filters.dart';
import '../providers/sitter_home_providers.dart';

/// Bottom sheet for filtering job listings
class JobFilterSheet extends ConsumerStatefulWidget {
  const JobFilterSheet({super.key});

  @override
  ConsumerState<JobFilterSheet> createState() => _JobFilterSheetState();

  /// Show the filter sheet as a modal bottom sheet
  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const JobFilterSheet(),
    );
  }
}

class _JobFilterSheetState extends ConsumerState<JobFilterSheet> {
  // Local state for filters before applying
  int? _maxDistance;
  double? _minPayRate;
  double? _maxPayRate;
  List<String> _specialNeeds = [];
  List<String> _ageGroups = [];
  DateTime? _availabilityDate;

  final _minPayController = TextEditingController();
  final _maxPayController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Initialize with current filter values
    final currentFilters = ref.read(jobSearchFiltersProvider);
    _maxDistance = currentFilters.maxDistance;
    _minPayRate = currentFilters.minPayRate;
    _maxPayRate = currentFilters.maxPayRate;
    _specialNeeds = List.from(currentFilters.specialNeeds);
    _ageGroups = List.from(currentFilters.ageGroups);
    _availabilityDate = currentFilters.availabilityDate;

    _minPayController.text = _minPayRate?.toStringAsFixed(0) ?? '';
    _maxPayController.text = _maxPayRate?.toStringAsFixed(0) ?? '';
  }

  @override
  void dispose() {
    _minPayController.dispose();
    _maxPayController.dispose();
    super.dispose();
  }

  void _applyFilters() {
    ref.read(jobSearchFiltersProvider.notifier).applyFilters(
          maxDistance: _maxDistance,
          minPayRate: _minPayRate,
          maxPayRate: _maxPayRate,
          specialNeeds: _specialNeeds,
          ageGroups: _ageGroups,
          availabilityDate: _availabilityDate,
        );
    ref.read(jobSearchNotifierProvider.notifier).fetchJobs();
    Navigator.of(context).pop();
  }

  void _resetFilters() {
    setState(() {
      _maxDistance = null;
      _minPayRate = null;
      _maxPayRate = null;
      _specialNeeds = [];
      _ageGroups = [];
      _availabilityDate = null;
      _minPayController.clear();
      _maxPayController.clear();
    });
  }

  Future<void> _selectDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _availabilityDate ?? now,
      firstDate: now,
      lastDate: now.add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF87C4F2),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _availabilityDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      child: DraggableScrollableSheet(
        initialChildSize: 0.85,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) {
          return Column(
            children: [
              // Handle bar
              Container(
                margin: EdgeInsets.only(top: 12.h),
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: const Color(0xFFE0E0E0),
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
              // Header
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Filter Jobs',
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF1D2939),
                        fontFamily: 'Inter',
                      ),
                    ),
                    TextButton(
                      onPressed: _resetFilters,
                      child: Text(
                        'Reset',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF667085),
                          fontFamily: 'Inter',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Divider(height: 1, color: Colors.grey.shade200),
              // Filter options
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding:
                      EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
                  children: [
                    // Distance slider
                    _buildSectionTitle('Maximum Distance'),
                    SizedBox(height: 8.h),
                    _buildDistanceSlider(),
                    SizedBox(height: 24.h),

                    // Pay rate range
                    _buildSectionTitle('Hourly Pay Rate'),
                    SizedBox(height: 8.h),
                    _buildPayRateInputs(),
                    SizedBox(height: 24.h),

                    // Availability date
                    _buildSectionTitle('Availability Date'),
                    SizedBox(height: 8.h),
                    _buildDatePicker(),
                    SizedBox(height: 24.h),

                    // Special needs
                    _buildSectionTitle('Special Needs'),
                    SizedBox(height: 8.h),
                    _buildChipSelector(
                      options: SpecialNeedsOptions.all,
                      selected: _specialNeeds,
                      onChanged: (values) =>
                          setState(() => _specialNeeds = values),
                    ),
                    SizedBox(height: 24.h),

                    // Age groups
                    _buildSectionTitle('Age Groups'),
                    SizedBox(height: 8.h),
                    _buildChipSelector(
                      options: AgeGroupOptions.all,
                      selected: _ageGroups,
                      onChanged: (values) =>
                          setState(() => _ageGroups = values),
                    ),
                    SizedBox(height: 32.h),
                  ],
                ),
              ),
              // Apply button
              Container(
                padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w,
                    20.h + MediaQuery.of(context).padding.bottom),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, -4),
                    ),
                  ],
                ),
                child: SizedBox(
                  width: double.infinity,
                  height: 52.h,
                  child: ElevatedButton(
                    onPressed: _applyFilters,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF87C4F2),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                    child: Text(
                      'Apply Filters',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Inter',
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 14.sp,
        fontWeight: FontWeight.w600,
        color: const Color(0xFF344054),
        fontFamily: 'Inter',
      ),
    );
  }

  Widget _buildDistanceSlider() {
    final displayValue = _maxDistance ?? 25;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${_maxDistance ?? 'Any'} ${_maxDistance != null ? 'miles' : ''}',
              style: TextStyle(
                fontSize: 13.sp,
                color: const Color(0xFF667085),
                fontFamily: 'Inter',
              ),
            ),
            if (_maxDistance != null)
              GestureDetector(
                onTap: () => setState(() => _maxDistance = null),
                child: Text(
                  'Clear',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: const Color(0xFF87C4F2),
                    fontFamily: 'Inter',
                  ),
                ),
              ),
          ],
        ),
        Slider(
          value: displayValue.toDouble(),
          min: 5,
          max: 50,
          divisions: 9,
          activeColor: const Color(0xFF87C4F2),
          inactiveColor: const Color(0xFFE0E0E0),
          onChanged: (value) {
            setState(() {
              _maxDistance = value.round();
            });
          },
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('5 mi', style: TextStyle(fontSize: 11.sp, color: Colors.grey)),
            Text('50 mi',
                style: TextStyle(fontSize: 11.sp, color: Colors.grey)),
          ],
        ),
      ],
    );
  }

  Widget _buildPayRateInputs() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _minPayController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              hintText: 'Min',
              prefixText: '\$ ',
              prefixStyle:
                  TextStyle(fontSize: 14.sp, color: const Color(0xFF667085)),
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 12.w, vertical: 14.h),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.r),
                borderSide: const BorderSide(color: Color(0xFFD0D5DD)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.r),
                borderSide: const BorderSide(color: Color(0xFFD0D5DD)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.r),
                borderSide: const BorderSide(color: Color(0xFF87C4F2)),
              ),
            ),
            onChanged: (value) {
              _minPayRate = double.tryParse(value);
            },
          ),
        ),
        SizedBox(width: 12.w),
        Text('to',
            style: TextStyle(fontSize: 14.sp, color: const Color(0xFF667085))),
        SizedBox(width: 12.w),
        Expanded(
          child: TextField(
            controller: _maxPayController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              hintText: 'Max',
              prefixText: '\$ ',
              prefixStyle:
                  TextStyle(fontSize: 14.sp, color: const Color(0xFF667085)),
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 12.w, vertical: 14.h),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.r),
                borderSide: const BorderSide(color: Color(0xFFD0D5DD)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.r),
                borderSide: const BorderSide(color: Color(0xFFD0D5DD)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.r),
                borderSide: const BorderSide(color: Color(0xFF87C4F2)),
              ),
            ),
            onChanged: (value) {
              _maxPayRate = double.tryParse(value);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildDatePicker() {
    return GestureDetector(
      onTap: _selectDate,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 14.h),
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFFD0D5DD)),
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              _availabilityDate != null
                  ? DateFormat('MMM d, yyyy').format(_availabilityDate!)
                  : 'Select a date',
              style: TextStyle(
                fontSize: 14.sp,
                color: _availabilityDate != null
                    ? const Color(0xFF344054)
                    : const Color(0xFF98A2B3),
                fontFamily: 'Inter',
              ),
            ),
            Row(
              children: [
                if (_availabilityDate != null)
                  GestureDetector(
                    onTap: () => setState(() => _availabilityDate = null),
                    child: Icon(Icons.close, size: 18.w, color: Colors.grey),
                  ),
                SizedBox(width: 8.w),
                Icon(Icons.calendar_today_outlined,
                    size: 18.w, color: const Color(0xFF667085)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChipSelector({
    required List<String> options,
    required List<String> selected,
    required ValueChanged<List<String>> onChanged,
  }) {
    return Wrap(
      spacing: 8.w,
      runSpacing: 8.h,
      children: options.map((option) {
        final isSelected = selected.contains(option);
        return GestureDetector(
          onTap: () {
            final newList = List<String>.from(selected);
            if (isSelected) {
              newList.remove(option);
            } else {
              newList.add(option);
            }
            onChanged(newList);
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: isSelected ? const Color(0xFF87C4F2) : Colors.white,
              borderRadius: BorderRadius.circular(20.r),
              border: Border.all(
                color: isSelected
                    ? const Color(0xFF87C4F2)
                    : const Color(0xFFD0D5DD),
              ),
            ),
            child: Text(
              option,
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w500,
                color: isSelected ? Colors.white : const Color(0xFF344054),
                fontFamily: 'Inter',
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
