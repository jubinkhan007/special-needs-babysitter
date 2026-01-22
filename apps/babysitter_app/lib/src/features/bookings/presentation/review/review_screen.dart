import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../theme/app_tokens.dart';
import '../../domain/review/review_args.dart';
import 'widgets/form_text_area.dart';
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
                color: Color(0xFF667085), size: 24),
            onPressed: () => context.pop(),
          ),
          title: const Text(
            'Review',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1D2939),
              fontFamily: 'Inter',
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.headset_mic_outlined,
                  color: Color(0xFF667085), size: 24),
              onPressed: () {},
            ),
          ],
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(1),
            child: Container(
              height: 1,
              color: const Color(0xFFF2F4F7),
            ),
          ),
        ),
        bottomNavigationBar: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              AppTokens.screenHorizontalPadding,
              8,
              AppTokens.screenHorizontalPadding,
              16,
            ),
            child: SizedBox(
              height: AppTokens.buttonHeight,
              child: ElevatedButton(
                onPressed: () {
                  context.pop();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF87C4F2),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(AppTokens.buttonRadius),
                  ),
                ),
                child: const Text(
                  'Submit Review',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Inter',
                  ),
                ),
              ),
            ),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: AppTokens.screenHorizontalPadding,
            vertical: 16,
          ),
          child: Column(
            children: [
              _ReviewSummaryCard(args: widget.args),
              const SizedBox(height: 28),
              Text(
                widget.args.reviewPrompt ??
                    'Rate Your Experience With This Family\n(Private).',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1D2939),
                  fontFamily: 'Inter',
                ),
              ),
              const SizedBox(height: 12),
              StarRatingRow(
                rating: _rating,
                iconSize: 22,
                onRatingChanged: (val) {
                  setState(() {
                    _rating = val;
                  });
                },
              ),
              const SizedBox(height: 20),
              FormTextArea(
                controller: _notesController,
                hintText: 'Additional Notes...',
                maxLines: 6,
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

class _ReviewSummaryCard extends StatelessWidget {
  final ReviewArgs args;

  const _ReviewSummaryCard({required this.args});

  @override
  Widget build(BuildContext context) {
    final jobTitle = _firstNonEmpty(
      args.jobTitle,
      args.sitterData.familyName,
      args.sitterName,
    );
    final location = _firstNonEmpty(args.location, args.sitterData.address);
    final familyName = _firstNonEmpty(args.familyName, args.sitterData.familyName);
    final childrenCount =
        _firstNonEmpty(args.childrenCount, args.sitterData.numberOfChildren);
    final paymentLabel =
        _firstNonEmpty(args.paymentLabel, args.sitterData.hourlyRate);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE4F4FC)),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.06),
            blurRadius: 16,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _ReviewAvatar(url: args.avatarUrl),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      jobTitle,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1D2939),
                        fontFamily: 'Inter',
                      ),
                    ),
                    if (location.isNotEmpty) ...[
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          const Icon(Icons.location_on_outlined,
                              size: 16, color: Color(0xFF98A2B3)),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              location,
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                color: Color(0xFF667085),
                                fontFamily: 'Inter',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              const Icon(Icons.bookmark_border,
                  color: Color(0xFF98A2B3), size: 22),
            ],
          ),
          const SizedBox(height: 14),
          _buildSummaryRow(
            icon: Icons.family_restroom_outlined,
            label: 'Family Name',
            value: familyName,
          ),
          const SizedBox(height: 8),
          _buildSummaryRow(
            icon: Icons.child_care_outlined,
            label: 'Children',
            value: childrenCount,
          ),
          const SizedBox(height: 8),
          _buildSummaryRow(
            icon: Icons.attach_money,
            label: 'Payment',
            value: paymentLabel,
          ),
        ],
      ),
    );
  }

  static Widget _buildSummaryRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Icon(icon, size: 18, color: const Color(0xFF98A2B3)),
        const SizedBox(width: 8),
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: Color(0xFF667085),
            fontFamily: 'Inter',
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1D2939),
            fontFamily: 'Inter',
          ),
        ),
      ],
    );
  }

  static String _firstNonEmpty(String? primary, String? fallback,
      [String? next]) {
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
}

class _ReviewAvatar extends StatelessWidget {
  final String? url;

  const _ReviewAvatar({this.url});

  @override
  Widget build(BuildContext context) {
    final avatarUrl = url?.trim();
    if (avatarUrl != null && avatarUrl.isNotEmpty) {
      final provider = avatarUrl.startsWith('http')
          ? NetworkImage(avatarUrl) as ImageProvider
          : AssetImage(avatarUrl);
      return CircleAvatar(
        radius: 20,
        backgroundImage: provider,
        backgroundColor: const Color(0xFFEFF4FF),
      );
    }
    return const CircleAvatar(
      radius: 20,
      backgroundColor: Color(0xFFEFF4FF),
      child: Icon(Icons.person, color: Color(0xFF98A2B3)),
    );
  }
}
