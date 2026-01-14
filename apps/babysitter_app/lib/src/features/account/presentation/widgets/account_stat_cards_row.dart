import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../theme/app_tokens.dart';
import 'surface_card.dart';

/// Row of two stat cards (Booking History, Saved Sitters).
class AccountStatCardsRow extends StatelessWidget {
  final int bookingHistoryCount;
  final int savedSittersCount;
  final VoidCallback? onBookingHistoryTap;
  final VoidCallback? onSavedSittersTap;

  const AccountStatCardsRow({
    super.key,
    required this.bookingHistoryCount,
    required this.savedSittersCount,
    this.onBookingHistoryTap,
    this.onSavedSittersTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _StatCard(
            count: bookingHistoryCount,
            label: 'Booking History',
            onTap: onBookingHistoryTap,
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: _StatCard(
            count: savedSittersCount,
            label: 'Saved Sitters',
            onTap: onSavedSittersTap,
          ),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final int count;
  final String label;
  final VoidCallback? onTap;

  const _StatCard({
    required this.count,
    required this.label,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SurfaceCard(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    count.toString(),
                    style: AppTokens.accountStatNumberStyle,
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    label,
                    style: AppTokens.accountStatLabelStyle,
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward,
              size: 18.sp,
              color: AppTokens.accountIconGrey,
            ),
          ],
        ),
      ),
    );
  }
}
