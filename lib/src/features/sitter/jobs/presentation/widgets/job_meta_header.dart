import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class JobMetaHeader extends StatelessWidget {
  final String familyName;
  final String childCount;
  final String? avatarUrl;
  final String location;
  final String? distance;

  const JobMetaHeader({
    super.key,
    required this.familyName,
    required this.childCount,
    this.avatarUrl,
    required this.location,
    this.distance,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Row 1: Family Name & Children Count
          Row(
            children: [
              CircleAvatar(
                radius: 12.w,
                backgroundImage:
                    avatarUrl != null ? NetworkImage(avatarUrl!) : null,
                backgroundColor: const Color(0xFFEAECF0),
                child: avatarUrl == null
                    ? Icon(Icons.person,
                        size: 16.w, color: const Color(0xFF667085))
                    : null,
              ),
              SizedBox(width: 8.w),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: familyName,
                      style: TextStyle(
                        color: const Color(0xFF667085),
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Inter',
                      ),
                    ),
                    TextSpan(
                      text: ' ($childCount)',
                      style: TextStyle(
                        color: const Color(0xFF2E90FA),
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Inter',
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),

          // Row 2: Location & Distance
          Row(
            children: [
              Icon(Icons.location_on_outlined,
                  size: 16.w, color: const Color(0xFF98A2B3)),
              SizedBox(width: 8.w),
              Expanded(
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: location,
                        style: TextStyle(
                          color: const Color(0xFF667085),
                          fontSize: 13.sp,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      if (distance != null)
                        TextSpan(
                          text: ' ($distance)',
                          style: TextStyle(
                            color: const Color(0xFF2E90FA),
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'Inter',
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
