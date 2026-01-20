import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../theme/app_tokens.dart';

/// Transportation preferences section with multi-line values.
class TransportationSection extends StatelessWidget {
  final List<String> transportationModes;
  final List<String> equipmentSafety;
  final List<String> pickupDropoffDetails;

  const TransportationSection({
    super.key,
    required this.transportationModes,
    required this.equipmentSafety,
    required this.pickupDropoffDetails,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Transportation Preferences title
          Text(
            'Transportation Preferences (Optional)',
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: AppTokens.textPrimary,
              fontFamily: 'Inter',
            ),
          ),
          SizedBox(height: 12.h),
          // Transportation Mode
          _buildMultiLineRow('Transportation Mode', transportationModes),
          SizedBox(height: 16.h),
          // Equipment & Safety
          _buildMultiLineRow('Equipment & Safety', equipmentSafety),
          SizedBox(height: 16.h),
          // Pickup / Drop-off Details
          _buildMultiLineRow('Pickup / Drop-off Details', pickupDropoffDetails),
        ],
      ),
    );
  }

  Widget _buildMultiLineRow(String label, List<String> values) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label
        SizedBox(
          width: 110.w,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
              color: AppTokens.textSecondary,
              fontFamily: 'Inter',
              height: 1.5,
            ),
          ),
        ),
        // Values (stacked right-aligned)
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: values
                .map(
                  (value) => Padding(
                    padding: EdgeInsets.only(bottom: 4.h),
                    child: Text(
                      value,
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                        color: AppTokens.textSecondary,
                        fontFamily: 'Inter',
                        height: 1.5,
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        ),
      ],
    );
  }
}
