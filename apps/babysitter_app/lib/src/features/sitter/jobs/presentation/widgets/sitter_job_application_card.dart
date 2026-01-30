import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../../routing/routes.dart';
import 'job_status_badge.dart';

class SitterJobApplicationCard extends StatelessWidget {
  final String id;
  final String jobId;
  final String jobTitle;
  final String familyName;
  final String childCount;
  final String avatarUrl;
  final String location;
  final String distance;
  final double hourlyRate;
  final String scheduledDate;
  final JobApplicationStatus status;
  final VoidCallback? onViewDetails;

  const SitterJobApplicationCard({
    super.key,
    required this.id,
    required this.jobId,
    required this.jobTitle,
    required this.familyName,
    required this.childCount,
    required this.avatarUrl,
    required this.location,
    required this.distance,
    required this.hourlyRate,
    required this.scheduledDate,
    required this.status,
    this.onViewDetails,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: const Color(0xFFEAECF0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Title + 3-dot menu
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  jobTitle,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF1D2939),
                    fontFamily: 'Inter',
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              InkWell(
                onTap: () {},
                borderRadius: BorderRadius.circular(12),
                child: Padding(
                  padding: EdgeInsets.all(4.w),
                  child: Icon(
                    Icons.more_vert,
                    size: 20.w,
                    color: const Color(0xFF98A2B3),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),

          // Family Info Row
          Row(
            children: [
              CircleAvatar(
                radius: 12.w,
                backgroundImage: NetworkImage(avatarUrl),
                backgroundColor: const Color(0xFFEAECF0),
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
                        color:
                            const Color(0xFF2E90FA), // Blue color from design
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

          // Location Row
          Row(
            children: [
              Icon(
                Icons.location_on_outlined,
                size: 16.w,
                color: const Color(0xFF98A2B3),
              ),
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
                        ),
                      ),
                      TextSpan(
                        text: ' ($distance)',
                        style: TextStyle(
                          color:
                              const Color(0xFF2E90FA), // Blue color from design
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Inter',
                        ),
                      ),
                    ],
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),

          // Footer: Rate, Date, Status
          Row(
            children: [
              Text(
                '\$${hourlyRate.toStringAsFixed(0)}',
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF344054),
                  fontFamily: 'Inter',
                ),
              ),
              Text(
                '/hr',
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF667085),
                  fontFamily: 'Inter',
                ),
              ),
              Expanded(
                child: Center(
                  child: Text(
                    'Scheduled: $scheduledDate',
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF667085),
                      fontFamily: 'Inter',
                    ),
                  ),
                ),
              ),
              JobStatusBadge(status: status),
            ],
          ),
          SizedBox(height: 16.h),

          // View Details Button
          SizedBox(
            width: double.infinity,
            height: 52.h,
            child: ElevatedButton(
              onPressed: onViewDetails ?? () {
                context.push('${Routes.sitterJobDetails}/$jobId');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF89CFF0), // Lighter blue
                foregroundColor: Colors.white,
                elevation: 0,
                padding: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
              child: Text(
                'View Details',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Inter',
                  height: 1.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
