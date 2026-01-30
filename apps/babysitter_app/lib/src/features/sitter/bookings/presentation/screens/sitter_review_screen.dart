import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../bookings/domain/review/review_args.dart';
import '../../../../bookings/presentation/providers/review_providers.dart';
import 'package:babysitter_app/src/common_widgets/app_toast.dart';
import 'package:core/core.dart';

/// Sitter review screen for reviewing a family after completing a job.
/// Matches the Figma design for sitter_reviews_parents.
class SitterReviewScreen extends ConsumerStatefulWidget {
  final ReviewArgs args;

  const SitterReviewScreen({super.key, required this.args});

  @override
  ConsumerState<SitterReviewScreen> createState() => _SitterReviewScreenState();
}

class _SitterReviewScreenState extends ConsumerState<SitterReviewScreen> {
  int _rating = 0;
  late final TextEditingController _notesController;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _notesController = TextEditingController();
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _submitReview() async {
    if (_rating == 0) {
      AppToast.show(
        context,
        const SnackBar(
            content: Text('Please select a rating before submitting')),
      );
      return;
    }

    final jobId = widget.args.jobId;
    final revieweeId =
        widget.args.sitterId; // This is the family/parent user ID
    if (jobId.isEmpty || revieweeId.isEmpty) {
      AppToast.show(
        context,
        const SnackBar(content: Text('Missing booking or family info')),
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    final remote = ref.read(reviewRemoteDataSourceProvider);
    try {
      await remote.postReview(
        revieweeId: revieweeId,
        jobId: jobId,
        rating: _rating,
        reviewText: _notesController.text.trim(),
      );
      if (!mounted) return;
      AppToast.show(
        context,
        const SnackBar(content: Text('Thanks for sharing your review!')),
      );
      context.pop();
    } catch (e) {
      if (!mounted) return;
      final message = e.toString().replaceFirst('Exception: ', '');
      AppToast.show(
        context,
        SnackBar(content: Text(message)),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewPadding.bottom;

    return MediaQuery(
      data: MediaQuery.of(context)
          .copyWith(textScaler: const TextScaler.linear(1)),
      child: Scaffold(
        backgroundColor: const Color(0xFFF9FAFB),
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back,
                color: const Color(0xFF667085), size: 24.w),
            onPressed: () => context.pop(),
          ),
          title: Text(
            'Review',
            style: TextStyle(
              fontSize: 17.sp,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF1D2939),
              fontFamily: 'Inter',
            ),
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.headset_mic_outlined,
                  color: const Color(0xFF667085), size: 24.w),
              onPressed: () {},
            ),
          ],
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
          child: Column(
            children: [
              // Job/Family Details Card
              _JobFamilyCard(args: widget.args),
              SizedBox(height: 24.h),

              // Rating prompt
              Text(
                'Rate Your Experience With This Family\n(Private).',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF1D2939),
                  fontFamily: 'Inter',
                  height: 1.4,
                ),
              ),
              SizedBox(height: 16.h),

              // Star rating
              _StarRating(
                rating: _rating,
                onRatingChanged: (val) => setState(() => _rating = val),
              ),
              SizedBox(height: 24.h),

              // Notes field
              _NotesField(controller: _notesController),
            ],
          ),
        ),
        bottomNavigationBar: Container(
          padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 16.h + bottomInset),
          decoration: const BoxDecoration(
            color: Colors.white,
          ),
          child: SizedBox(
            width: double.infinity,
            height: 52.h,
            child: ElevatedButton(
              onPressed: _isSubmitting ? null : _submitReview,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF87C4F2),
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
                disabledBackgroundColor:
                    const Color(0xFF87C4F2).withOpacity(0.6),
              ),
              child: _isSubmitting
                  ? SizedBox(
                      width: 24.w,
                      height: 24.w,
                      child: const CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : Text(
                      'Submit Review',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Inter',
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Card showing job and family details for the review.
class _JobFamilyCard extends StatelessWidget {
  final ReviewArgs args;

  const _JobFamilyCard({required this.args});

  @override
  Widget build(BuildContext context) {
    final jobTitle = args.jobTitle ?? args.sitterData.familyName;
    final location = args.location ?? args.sitterData.distance;
    final familyName = args.familyName ?? args.sitterData.familyName;
    final childrenCount =
        args.childrenCount ?? args.sitterData.numberOfChildren;
    final payment = args.paymentLabel ?? args.sitterData.hourlyRate;
    final avatarUrl = args.avatarUrl ?? args.sitterData.avatarUrl;

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: const Color(0xFFE5E7EB)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row with avatar, title, location, and bookmark
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Avatar
              _FamilyAvatar(url: avatarUrl, radius: 24.r),
              SizedBox(width: 12.w),
              // Title and location
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      jobTitle.isNotEmpty ? jobTitle : 'Job',
                      style: TextStyle(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF1D2939),
                        fontFamily: 'Inter',
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          size: 14.w,
                          color: const Color(0xFF98A2B3),
                        ),
                        SizedBox(width: 4.w),
                        Expanded(
                          child: Text(
                            location.isNotEmpty ? location : 'Location',
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: const Color(0xFF667085),
                              fontFamily: 'Inter',
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Bookmark icon
              Icon(
                Icons.bookmark_border,
                size: 22.w,
                color: const Color(0xFF98A2B3),
              ),
            ],
          ),
          SizedBox(height: 16.h),

          // Details rows
          _DetailRow(
            icon: Icons.family_restroom_outlined,
            label: 'Family Name',
            value: familyName.isNotEmpty ? familyName : '-',
          ),
          SizedBox(height: 12.h),
          _DetailRow(
            icon: Icons.child_care_outlined,
            label: 'Children',
            value: childrenCount.isNotEmpty ? childrenCount : '-',
          ),
          SizedBox(height: 12.h),
          _DetailRow(
            icon: Icons.payments_outlined,
            label: 'Payment',
            value: payment.isNotEmpty ? payment : '-',
          ),
        ],
      ),
    );
  }
}

/// Avatar widget for family photo.
class _FamilyAvatar extends StatelessWidget {
  final String? url;
  final double radius;

  const _FamilyAvatar({this.url, required this.radius});

  @override
  Widget build(BuildContext context) {
    final avatarUrl = url?.trim();
    print('DEBUG: _FamilyAvatar input url = "$url"');
    print('DEBUG: _FamilyAvatar processed avatarUrl = "$avatarUrl"');

    if (avatarUrl != null && avatarUrl.isNotEmpty) {
      final fullUrl = avatarUrl.startsWith('http')
          ? avatarUrl
          : '${Constants.baseUrl}${avatarUrl.startsWith('/') ? '' : '/'}$avatarUrl';

      return CircleAvatar(
        radius: radius,
        backgroundImage: NetworkImage(fullUrl),
        backgroundColor: const Color(0xFFEFF4FF),
      );
    }
    return CircleAvatar(
      radius: radius,
      backgroundColor: const Color(0xFFEFF4FF),
      child: Icon(Icons.person, color: const Color(0xFF98A2B3), size: radius),
    );
  }
}

/// Row showing a detail with icon, label, and value.
class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18.w, color: const Color(0xFF98A2B3)),
        SizedBox(width: 8.w),
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 13.sp,
              color: const Color(0xFF667085),
              fontFamily: 'Inter',
            ),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 13.sp,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF1D2939),
            fontFamily: 'Inter',
          ),
        ),
      ],
    );
  }
}

/// Star rating widget.
class _StarRating extends StatelessWidget {
  final int rating;
  final ValueChanged<int> onRatingChanged;

  const _StarRating({
    required this.rating,
    required this.onRatingChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (index) {
        final starIndex = index + 1;
        final isFilled = starIndex <= rating;
        return GestureDetector(
          onTap: () => onRatingChanged(starIndex),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            child: Icon(
              isFilled ? Icons.star : Icons.star_border,
              size: 32.w,
              color:
                  isFilled ? const Color(0xFFF5B301) : const Color(0xFFD0D5DD),
            ),
          ),
        );
      }),
    );
  }
}

class _NotesField extends StatelessWidget {
  final TextEditingController controller;

  const _NotesField({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: TextField(
        controller: controller,
        minLines: 4,
        maxLines: 6,
        style: TextStyle(
          fontSize: 14.sp,
          color: const Color(0xFF1D2939),
          fontFamily: 'Inter',
        ),
        decoration: InputDecoration(
          hintText: 'Additional Notes...',
          hintStyle: TextStyle(
            fontSize: 14.sp,
            color: const Color(0xFF98A2B3),
            fontFamily: 'Inter',
          ),
          filled: true,
          fillColor: Colors.white,
          border: InputBorder.none,
          contentPadding:
              EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        ),
      ),
    );
  }
}
