import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:core/core.dart';
import '../../../../theme/app_tokens.dart';
import '../../domain/review/review_args.dart';
import '../providers/review_providers.dart';
import 'widgets/star_rating_row.dart';
import 'package:babysitter_app/src/common_widgets/app_toast.dart';

class ReviewScreen extends ConsumerStatefulWidget {
  final ReviewArgs args;

  const ReviewScreen({super.key, required this.args});

  @override
  ConsumerState<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends ConsumerState<ReviewScreen> {
  int _rating = 0;
  late final TextEditingController _notesController;
  bool _isSubmitting = false;
  final ImagePicker _picker = ImagePicker();
  File? _selectedImageFile;

  @override
  void initState() {
    super.initState();
    _notesController = TextEditingController();
    // Debug: Log all ReviewArgs values
    debugPrint('DEBUG ReviewScreen: ======= ReviewArgs received =======');
    debugPrint('DEBUG ReviewScreen: bookingId = ${widget.args.bookingId}');
    debugPrint('DEBUG ReviewScreen: sitterId = ${widget.args.sitterId}');
    debugPrint('DEBUG ReviewScreen: sitterName = "${widget.args.sitterName}"');
    debugPrint('DEBUG ReviewScreen: sitterName length = ${widget.args.sitterName.length}');
    debugPrint('DEBUG ReviewScreen: sitterName contains DioException = ${widget.args.sitterName.contains('DioException')}');
    debugPrint('DEBUG ReviewScreen: avatarUrl = ${widget.args.avatarUrl}');
    debugPrint('DEBUG ReviewScreen: jobTitle = "${widget.args.jobTitle}"');
    debugPrint('DEBUG ReviewScreen: location = ${widget.args.location}');
    debugPrint('DEBUG ReviewScreen: familyName = "${widget.args.familyName}"');
    debugPrint('DEBUG ReviewScreen: status = ${widget.args.status}');
    debugPrint('DEBUG ReviewScreen: sitterData.sitterName = "${widget.args.sitterData.sitterName}"');
    debugPrint('DEBUG ReviewScreen: sitterData.sitterName length = ${widget.args.sitterData.sitterName.length}');
    debugPrint('DEBUG ReviewScreen: sitterData.avatarUrl = ${widget.args.sitterData.avatarUrl}');
    debugPrint('DEBUG ReviewScreen: sitterData.skills = ${widget.args.sitterData.skills}');
    debugPrint('DEBUG ReviewScreen: =====================================');
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
        const SnackBar(content: Text('Please select a rating before submitting')),
      );
      return;
    }

    final jobId = widget.args.jobId;
    final revieweeId = widget.args.sitterId;
    if (jobId.isEmpty || revieweeId.isEmpty) {
      AppToast.show(
        context,
        const SnackBar(content: Text('Missing booking or sitter info')),
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });
    final remote = ref.read(reviewRemoteDataSourceProvider);
    try {
      String imageUrl = '';
      if (_selectedImageFile != null) {
        final uploadRemote =
            ref.read(reviewImageUploadRemoteDataSourceProvider);
        imageUrl = await uploadRemote.uploadReviewImage(_selectedImageFile!);
      }
      await remote.postReview(
        revieweeId: revieweeId,
        jobId: jobId,
        rating: _rating,
        reviewText: _notesController.text.trim(),
        imageUrl: imageUrl.isEmpty ? null : imageUrl,
      );
      if (!mounted) return;
      AppToast.show(
        context,
        const SnackBar(content: Text('Thanks for sharing your review!')),
      );
      context.pop();
    } catch (e) {
      if (!mounted) return;
      final message = _resolveErrorMessage(e);
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

  String _resolveErrorMessage(Object error) {
    if (error is DioException) {
      final data = error.response?.data;
      if (data is Map) {
        final map = Map<String, dynamic>.from(data);
        final message = map['error'] ?? map['message'];
        if (message is String && message.trim().isNotEmpty) {
          return message.trim();
        }
      }
      if (data is String && data.trim().isNotEmpty) {
        return data.trim();
      }
    }

    final appError = AppErrorHandler.parse(error);
    return appError.message;
  }

  Widget _buildOutlinedButton(String label, {double? maxWidth}) {
    final effectiveMax = maxWidth ?? 140;
    return ConstrainedBox(
      constraints: BoxConstraints(
        minWidth: 90,
        maxWidth: effectiveMax,
      ),
      child: SizedBox(
        height: 50,
        child: OutlinedButton(
          onPressed: () {},
          style: OutlinedButton.styleFrom(
            side: const BorderSide(color: Color(0xFFD0D5DD)),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            foregroundColor: const Color(0xFF667085),
          ),
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              fontFamily: 'Inter',
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      height: 50,
      child: ElevatedButton(
        onPressed: _isSubmitting ? null : _submitReview,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.textOnButton,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: _isSubmitting
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.textOnButton),
                ),
              )
            : const Text(
                'Submit',
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Inter',
                ),
              ),
      ),
    );
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
          child: LayoutBuilder(
            builder: (context, constraints) {
              final isNarrow = constraints.maxWidth < 340;
              if (isNarrow) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildOutlinedButton('Report', maxWidth: double.infinity),
                    const SizedBox(height: 10),
                    _buildOutlinedButton('Skip', maxWidth: double.infinity),
                    const SizedBox(height: 10),
                    _buildSubmitButton(),
                  ],
                );
              }
              return Row(
                children: [
                  _buildOutlinedButton('Report'),
                  const SizedBox(width: 10),
                  _buildOutlinedButton('Skip'),
                  const SizedBox(width: 10),
                  Expanded(child: _buildSubmitButton()),
                ],
              );
            },
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
                  color: AppColors.buttonDark,
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
              _buildUploadTile(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUploadTile() {
    return _UploadTile(
      imageFile: _selectedImageFile,
      onTap: _showImageSourcePicker,
    );
  }

  Future<void> _showImageSourcePicker() async {
    if (!mounted) return;
    await showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt_outlined),
                title: const Text('Take photo'),
                onTap: () {
                  Navigator.of(context).pop();
                  _pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library_outlined),
                title: const Text('Choose from gallery'),
                onTap: () {
                  Navigator.of(context).pop();
                  _pickImage(ImageSource.gallery);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final file = await _picker.pickImage(
        source: source,
        maxWidth: 1200,
        maxHeight: 1200,
        imageQuality: 80,
      );
      if (file == null) return;
      setState(() {
        _selectedImageFile = File(file.path);
      });
    } catch (e) {
      if (!mounted) return;
      AppToast.show(
        context,
        SnackBar(content: Text('Failed to pick image: $e')),
      );
    }
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
                              color: AppColors.buttonDark,
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
                          color: AppColors.buttonDark,
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
              color: AppColors.buttonDark,
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
          color: AppColors.buttonDark,
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
  final File? imageFile;
  final VoidCallback onTap;

  const _UploadTile({this.imageFile, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: 76,
          height: 76,
          decoration: BoxDecoration(
            color: const Color(0xFFF2F4F7),
            borderRadius: BorderRadius.circular(12),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: imageFile == null
                ? const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
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
                  )
                : Image.file(
                    imageFile!,
                    fit: BoxFit.cover,
                  ),
          ),
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
