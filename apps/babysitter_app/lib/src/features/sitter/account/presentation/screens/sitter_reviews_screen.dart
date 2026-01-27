import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SitterReviewsScreen extends StatelessWidget {
  const SitterReviewsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back,
              color: const Color(0xFF667085), size: 24.w),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        centerTitle: true,
        title: Text(
          'My reviews',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF1D2939),
            fontFamily: 'Inter',
          ),
        ),
      ),
      body: ListView.separated(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
        itemCount: _mockReviews.length,
        separatorBuilder: (context, index) => Divider(
          height: 24.h,
          thickness: 1,
          color: const Color(0xFFF2F4F7),
        ),
        itemBuilder: (context, index) {
          final review = _mockReviews[index];
          return _ReviewCard(review: review);
        },
      ),
    );
  }
}

class _ReviewCard extends StatelessWidget {
  final _Review review;

  const _ReviewCard({required this.review});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: 20.r,
          backgroundImage:
              const AssetImage('assets/images/avatars/avatar_krystina.png'),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    review.name,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF101828),
                      fontFamily: 'Inter',
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Icon(Icons.star,
                      size: 14.sp, color: const Color(0xFFFBBF24)),
                  SizedBox(width: 4.w),
                  Text(
                    review.rating.toStringAsFixed(1),
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF667085),
                      fontFamily: 'Inter',
                    ),
                  ),
                  const Spacer(),
                  Text(
                    review.timeAgo,
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: const Color(0xFF98A2B3),
                      fontFamily: 'Inter',
                    ),
                  ),
                ],
              ),
              SizedBox(height: 6.h),
              Text(
                review.text,
                style: TextStyle(
                  fontSize: 12.sp,
                  height: 1.4,
                  color: const Color(0xFF667085),
                  fontFamily: 'Inter',
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _Review {
  final String name;
  final double rating;
  final String timeAgo;
  final String text;

  const _Review({
    required this.name,
    required this.rating,
    required this.timeAgo,
    required this.text,
  });
}

const List<_Review> _mockReviews = [
  _Review(
    name: 'Ayesha K',
    rating: 5.0,
    timeAgo: '2 Days Ago',
    text:
        'Krystina connected so well with my daughter that has sensory needs. '
        'Her calm presence made all the difference.',
  ),
  _Review(
    name: 'James W',
    rating: 5.0,
    timeAgo: '10 Days Ago',
    text:
        'Krystina is reliable, friendly, and communicates clearly. '
        'My son always looks forward to seeing her!',
  ),
  _Review(
    name: 'Lina S',
    rating: 5.0,
    timeAgo: '15 Days Ago',
    text:
        'We hired Krystina for evening care and she instantly bonded with our child. '
        'She was very warm, professional, and always on time.',
  ),
  _Review(
    name: 'David M',
    rating: 5.0,
    timeAgo: '18 Days Ago',
    text:
        'I appreciate how Krystina handles my twins with autism. '
        'She uses visual aids and routines that actually work. Highly recommend!',
  ),
  _Review(
    name: 'Reema T',
    rating: 5.0,
    timeAgo: '20 Days Ago',
    text:
        'Krystina stepped in last minute when our regular sitter canceled. '
        'She kept us updated throughout the evening and left the house spotless.',
  ),
  _Review(
    name: 'Ayesha K',
    rating: 5.0,
    timeAgo: '22 Days Ago',
    text:
        'Krystina connected so well with my daughter who has sensory needs. '
        'Her calm presence made all the difference.',
  ),
  _Review(
    name: 'James W',
    rating: 5.0,
    timeAgo: '25 Days Ago',
    text:
        'Krystina is reliable, friendly, and communicates clearly. '
        'My son always looks forward to seeing her!',
  ),
  _Review(
    name: 'Lina S',
    rating: 5.0,
    timeAgo: '27 Days Ago',
    text:
        'We hired Krystina for evening care and she instantly bonded with our child. '
        'She was very warm, professional, and always on time.',
  ),
  _Review(
    name: 'David M',
    rating: 5.0,
    timeAgo: '29 Days Ago',
    text:
        'I appreciate how Krystina handles my twins with autism. '
        'She uses visual aids and routines that actually work. Highly recommend!',
  ),
  _Review(
    name: 'Reema T',
    rating: 5.0,
    timeAgo: '30 Days Ago',
    text:
        'Krystina stepped in last minute when our regular sitter canceled. '
        'She kept us updated throughout the evening and left the house spotless.',
  ),
];
