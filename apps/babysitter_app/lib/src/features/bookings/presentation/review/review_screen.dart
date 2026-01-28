import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../theme/app_tokens.dart';
import '../../domain/review/review_args.dart';
import 'widgets/star_rating_row.dart';

class ReviewScreen extends StatefulWidget {
  final ReviewArgs args;

  const ReviewScreen({super.key, required this.args});

  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  int _rating = 0;
  late final TextEditingController _notesController;

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

  @override
  Widget build(BuildContext context) {
    final sitterName = _firstNonEmpty(
      widget.args.sitterName,
      widget.args.sitterData.sitterName,
    );
    final bottomInset = MediaQuery.of(context).viewPadding.bottom;
    return MediaQuery(
      data: MediaQuery.of(context)
          .copyWith(textScaler: const TextScaler.linear(1)),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back,
                color: Color(0xFF98A2B3), size: 22),
            onPressed: () => context.pop(),
          ),
          title: Text(
            'Review $sitterName',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF344054),
              fontFamily: 'Inter',
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.headset_mic_outlined,
                  color: Color(0xFF98A2B3), size: 22),
              onPressed: () {},
            ),
          ],
        ),
        bottomNavigationBar: Padding(
          padding: EdgeInsets.fromLTRB(
            AppTokens.screenHorizontalPadding,
            10,
            AppTokens.screenHorizontalPadding,
            16 + bottomInset,
          ),
          child: Row(
            children: [
              SizedBox(
                width: 84,
                height: 46,
                child: OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFFD0D5DD)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    foregroundColor: const Color(0xFF667085),
                  ),
                  child: const Text(
                    'Report',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Inter',
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              SizedBox(
                width: 70,
                height: 46,
                child: OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFFD0D5DD)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    foregroundColor: const Color(0xFF667085),
                  ),
                  child: const Text(
                    'Skip',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Inter',
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: SizedBox(
                  height: 46,
                  child: ElevatedButton(
                    onPressed: () {
                      context.pop();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF8CC8F5),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      'Submit',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Inter',
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: AppTokens.screenHorizontalPadding,
            vertical: 16,
          ),
          child: Column(
            children: [
              _SitterReviewHeaderCard(args: widget.args),
              const SizedBox(height: 26),
              Text(
                widget.args.reviewPrompt ?? 'How Was Your Experience?',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1D2939),
                  fontFamily: 'Inter',
                ),
              ),
              const SizedBox(height: 10),
              StarRatingRow(
                rating: _rating,
                iconSize: 20,
                onRatingChanged: (val) {
                  setState(() {
                    _rating = val;
                  });
                },
              ),
              const SizedBox(height: 18),
              _NotesField(controller: _notesController),
              const SizedBox(height: 16),
              const _UploadTile(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class _SitterReviewHeaderCard extends StatelessWidget {
  final ReviewArgs args;

  const _SitterReviewHeaderCard({required this.args});

  @override
  Widget build(BuildContext context) {
    final sitterName =
        _firstNonEmpty(args.sitterName, args.sitterData.sitterName);
    final avatarUrl =
        _firstNonEmpty(args.avatarUrl, args.sitterData.avatarUrl);
    final distance =
        _firstNonEmpty(args.sitterData.distance, args.location, 'Unknown');
    final rating = _firstNonEmpty(args.sitterData.rating, '0.0');
    final responseRate =
        _firstNonEmpty(args.sitterData.responseRate, '0%');
    final reliabilityRate =
        _firstNonEmpty(args.sitterData.reliabilityRate, '0%');
    final experience = _firstNonEmpty(args.sitterData.experience, '0 Years');
    final skills = args.sitterData.skills.isNotEmpty
        ? args.sitterData.skills
        : const ['CPR', 'First-aid', 'Special Needs Training'];

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE7F0FA)),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.06),
            blurRadius: 14,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _ReviewAvatar(url: avatarUrl, radius: 22),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            sitterName,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF1D2939),
                              fontFamily: 'Inter',
                            ),
                          ),
                        ),
                        if (args.sitterData.isVerified) ...[
                          const SizedBox(width: 6),
                          Container(
                            width: 16,
                            height: 16,
                            decoration: const BoxDecoration(
                              color: Color(0xFFE6F2FF),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.check,
                              size: 12,
                              color: Color(0xFF3B82F6),
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 4),
                    if (distance.isNotEmpty)
                      Row(
                        children: [
                          const Icon(
                            Icons.location_on_outlined,
                            size: 14,
                            color: Color(0xFF98A2B3),
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              distance,
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w400,
                                color: Color(0xFF667085),
                                fontFamily: 'Inter',
                              ),
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.star,
                          color: Color(0xFFF5B301), size: 14),
                      const SizedBox(width: 4),
                      Text(
                        rating,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1D2939),
                          fontFamily: 'Inter',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const Icon(Icons.bookmark_border,
                      color: Color(0xFF98A2B3), size: 18),
                ],
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _StatItem(
                icon: Icons.bolt_outlined,
                label: 'Response Rate',
                value: responseRate,
              ),
              _StatItem(
                icon: Icons.thumb_up_outlined,
                label: 'Reliability Rate',
                value: reliabilityRate,
              ),
              _StatItem(
                icon: Icons.schedule_outlined,
                label: 'Experience',
                value: experience,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            alignment: WrapAlignment.start,
            spacing: 8,
            runSpacing: 8,
            children: skills
                .map((skill) => _SkillChip(label: skill))
                .toList(),
          ),
        ],
      ),
    );
  }
}

class _ReviewAvatar extends StatelessWidget {
  final String? url;
  final double radius;

  const _ReviewAvatar({this.url, this.radius = 20});

  @override
  Widget build(BuildContext context) {
    final avatarUrl = url?.trim();
    if (avatarUrl != null && avatarUrl.isNotEmpty) {
      final provider = avatarUrl.startsWith('http')
          ? NetworkImage(avatarUrl) as ImageProvider
          : AssetImage(avatarUrl);
      return CircleAvatar(
        radius: radius,
        backgroundImage: provider,
        backgroundColor: const Color(0xFFEFF4FF),
      );
    }
    return CircleAvatar(
      radius: radius,
      backgroundColor: const Color(0xFFEFF4FF),
      child: const Icon(Icons.person, color: Color(0xFF98A2B3)),
    );
  }
}

class _StatItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _StatItem({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 14, color: const Color(0xFF98A2B3)),
              const SizedBox(width: 4),
              Flexible(
                child: Text(
                  label,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF98A2B3),
                    fontFamily: 'Inter',
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1D2939),
              fontFamily: 'Inter',
            ),
          ),
        ],
      ),
    );
  }
}

class _SkillChip extends StatelessWidget {
  final String label;

  const _SkillChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFF2F4F7),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: Color(0xFF667085),
          fontFamily: 'Inter',
        ),
      ),
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
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFD6E8FF)),
      ),
      child: TextField(
        controller: controller,
        minLines: 4,
        maxLines: 6,
        style: const TextStyle(
          fontSize: 14,
          color: Color(0xFF1D2939),
          fontFamily: 'Inter',
        ),
        decoration: const InputDecoration(
          hintText: 'Additional Notes...',
          hintStyle: TextStyle(
            fontSize: 14,
            color: Color(0xFF98A2B3),
            fontFamily: 'Inter',
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        ),
      ),
    );
  }
}

class _UploadTile extends StatelessWidget {
  const _UploadTile();

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        width: 76,
        height: 76,
        decoration: BoxDecoration(
          color: const Color(0xFFF2F4F7),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.cloud_upload_outlined,
                size: 20, color: Color(0xFF98A2B3)),
            SizedBox(height: 6),
            Text(
              'Upload Photo\n/ screenshot',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 9,
                fontWeight: FontWeight.w600,
                color: Color(0xFF98A2B3),
                fontFamily: 'Inter',
                height: 1.1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

String _firstNonEmpty(String? primary, String? fallback, [String? next]) {
  final value = primary?.trim();
  if (value != null && value.isNotEmpty) {
    return value;
  }
  final fallbackValue = fallback?.trim();
  if (fallbackValue != null && fallbackValue.isNotEmpty) {
    return fallbackValue;
  }
  final nextValue = next?.trim();
  if (nextValue != null && nextValue.isNotEmpty) {
    return nextValue;
  }
  return '';
}
