import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:babysitter_app/src/theme/app_tokens.dart';
import 'bullet_list.dart';

/// Model for a legal document section
class LegalSectionModel {
  final String title;
  final List<String> paragraphs;
  final List<String> bullets;

  const LegalSectionModel({
    required this.title,
    this.paragraphs = const [],
    this.bullets = const [],
  });
}

/// Reusable legal document section widget.
class LegalDocumentSection extends StatelessWidget {
  final String title;
  final List<String> paragraphs;
  final List<String> bullets;

  const LegalDocumentSection({
    super.key,
    required this.title,
    this.paragraphs = const [],
    this.bullets = const [],
  });

  factory LegalDocumentSection.fromModel(LegalSectionModel model) {
    return LegalDocumentSection(
      title: model.title,
      paragraphs: model.paragraphs,
      bullets: model.bullets,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section title
          Text(
            title,
            style: TextStyle(
              fontFamily: AppTokens.fontFamily,
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: AppTokens.textPrimary,
              height: 1.5,
            ),
          ),

          if (paragraphs.isNotEmpty) ...[
            SizedBox(height: 4.h),
            ...paragraphs.map((p) => Padding(
                  padding: EdgeInsets.only(bottom: 4.h),
                  child: Text(
                    p,
                    style: TextStyle(
                      fontFamily: AppTokens.fontFamily,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                      color: AppTokens.textSecondary,
                      height: 1.5,
                    ),
                  ),
                )),
          ],

          if (bullets.isNotEmpty) ...[
            SizedBox(height: 4.h),
            BulletList(items: bullets),
          ],
        ],
      ),
    );
  }
}
