import 'package:flutter/material.dart';
import 'package:core/core.dart';
import 'package:go_router/go_router.dart';
import 'package:babysitter_app/src/routing/routes.dart';
import '../models/home_mock_models.dart';
import '../theme/home_design_tokens.dart';
import 'package:babysitter_app/src/features/parent/sitter_profile/presentation/screens/sitter_profile_view.dart';

class SitterNearYouCard extends StatelessWidget {
  final SitterModel sitter;

  const SitterNearYouCard({super.key, required this.sitter});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: HomeDesignTokens.sitterNearYouWidth, // keep 300 (or set to Figma)
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18), // slightly rounder like Figma
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ===== Top Row =====
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Avatar
              ClipOval(
                child: Image.asset(
                  sitter.avatarUrl,
                  width: 44,
                  height: 44,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 12),

              // Name + verified + location
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            sitter.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        if (sitter.isVerified)
                          const Icon(
                            Icons.verified,
                            size: 16,
                            color: AppColors.verifiedBlue,
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on_outlined,
                          size: 14,
                          color: AppColors.primary, // Figma-like blue pin
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            sitter.location,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // ⭐ Rating + Bookmark (SAME ROW like Figma)
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.star, size: 16, color: AppColors.starYellow),
                  const SizedBox(width: 4),
                  Text(
                    sitter.rating.toStringAsFixed(1),
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Icon(Icons.bookmark_border,
                      size: 22, color: AppColors.textSecondary),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // ===== Stats =====
          Row(
            children: [
              Expanded(
                child: _stat(
                  'Response Rate',
                  '${sitter.responseRate}%',
                  Icons.access_time,
                ),
              ),
              const SizedBox(width: 18), // <-- more spacing like Figma
              Expanded(
                child: _stat(
                  'Reliability Rate',
                  '${sitter.reliabilityRate}%',
                  Icons.thumb_up_alt_outlined,
                ),
              ),
              const SizedBox(width: 18),
              Expanded(
                child: _stat(
                  'Experience',
                  '${sitter.experienceYears} Years',
                  Icons.verified_outlined,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // ===== Badges (NO truncation) =====
          SizedBox(
            height:
                44, // tweak if needed (depends on your chip vertical padding)
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemCount: sitter.badges.length,
              separatorBuilder: (_, __) => const SizedBox(width: 10),
              itemBuilder: (context, index) => _badge(sitter.badges[index]),
            ),
          ),

          const SizedBox(height: 14),

          // ===== Footer =====
          Row(
            children: [
              // Price baseline align
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: '\$${sitter.hourlyRate.toInt()}',
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w900,
                        color: AppColors.textPrice,
                      ),
                    ),
                    const TextSpan(
                      text: '/hr',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),

              SizedBox(
                height: 40,
                width: 140,
                child: ElevatedButton(
                  onPressed: () {
                    context.push(Routes.sitterProfilePath(sitter.id));
                  },
                  style: ButtonStyle(
                    backgroundColor: const WidgetStatePropertyAll(
                        Color(0xFF86C9E8)), // Figma
                    elevation: const WidgetStatePropertyAll(0),
                    shape: WidgetStatePropertyAll(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    padding: const WidgetStatePropertyAll(
                        EdgeInsets.zero), // ✅ important
                    minimumSize: const WidgetStatePropertyAll(Size(140, 40)),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    visualDensity: VisualDensity.compact,
                    alignment: Alignment.center, // ✅ keeps text centered
                  ),
                  child: const Center(
                    child: Text(
                      'View Profile',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        height: 1.0, // ✅ prevents bottom clipping
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _stat(String label, String value, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: AppColors.textSecondary),
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textSecondary,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _badge(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFEAF3F9),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Text(
        text,
        maxLines: 1,
        overflow: TextOverflow.ellipsis, // safety (usually not needed)
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: AppColors.textSecondary,
        ),
      ),
    );
  }
}
