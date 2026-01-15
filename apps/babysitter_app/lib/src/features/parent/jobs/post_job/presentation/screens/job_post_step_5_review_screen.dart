import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../../../routing/routes.dart';
import '../providers/job_post_providers.dart';
import '../widgets/job_draft_saved_dialog.dart';
import 'job_post_step_header.dart';

/// Job Post Step 5: Review
/// Pixel-perfect implementation matching Figma design
class JobPostStep5ReviewScreen extends ConsumerWidget {
  final VoidCallback onSubmit;
  final VoidCallback onBack;
  final VoidCallback? onEditJobDetail;
  final VoidCallback? onEditChild;
  final VoidCallback? onEditAdditional;

  const JobPostStep5ReviewScreen({
    super.key,
    required this.onSubmit,
    required this.onBack,
    this.onEditJobDetail,
    this.onEditChild,
    this.onEditAdditional,
  });

  // Design Constants
  static const _bgColor = Color(0xFFEAF6FF); // Light sky background
  static const _titleColor = Color(0xFF0B1736); // Deep navy
  static const _secondaryText = Color(0xFF6F7C8A); // Secondary grey
  static const _lightGrey = Color(0xFF8793A1); // Lighter grey
  static const _primaryBtn = Color(0xFF8CCFF0); // Submit button
  static const _editIconColor = Color(0xFF7C8A9A); // Edit icon grey

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(jobPostControllerProvider);
    final profileDetailsAsync = ref.watch(profileDetailsProvider);

    return Scaffold(
      backgroundColor: _bgColor,
      body: SafeArea(
        child: Column(
          children: [
            // Top Header (Step 5 of 5)
            JobPostStepHeader(
              activeStep: 5,
              totalSteps: 5,
              onBack: onBack,
            ),

            // Main Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),

                    // Section A: Job Detail
                    _buildSectionHeader('Job Detail', onEditJobDetail),
                    const SizedBox(height: 12),
                    _buildTextLine(state.title),
                    const SizedBox(height: 10),
                    _buildTextLine('${state.startDate} - ${state.endDate}'),
                    const SizedBox(height: 10),
                    _buildTextLine('${state.startTime} to ${state.endTime}'),

                    const SizedBox(height: 32),

                    // Section B: Child
                    _buildSectionHeader('Child', onEditChild),
                    const SizedBox(height: 12),
                    profileDetailsAsync.when(
                      data: (details) {
                        final selectedChildren = details.children
                            .where((c) => state.childIds.contains(c.id))
                            .toList();
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: selectedChildren.map((child) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: _buildChildRow(
                                  '${child.firstName} ${child.lastName}',
                                  child.ageDisplay),
                            );
                          }).toList(),
                        );
                      },
                      loading: () => const CircularProgressIndicator(),
                      error: (err, stack) =>
                          Text('Error loading children: $err'),
                    ),

                    const SizedBox(height: 32),

                    // Section C: Additional Details & Pay Rate
                    _buildSectionHeader(
                        'Additional Details & Pay Rate', onEditAdditional),
                    const SizedBox(height: 12),
                    Text(
                      state.additionalDetails,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w400,
                        color: _secondaryText,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Pay Rate
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(
                          '\$ ${state.payRate.toStringAsFixed(0)}',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            color: _titleColor,
                          ),
                        ),
                        const Text(
                          '/hr',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: _lightGrey,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),

            // Bottom Bar
            _buildBottomBar(context, ref),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, VoidCallback? onEdit) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: _titleColor,
          ),
        ),
        GestureDetector(
          onTap: onEdit,
          child: const Icon(
            Icons.edit_outlined,
            size: 20,
            color: _editIconColor,
          ),
        ),
      ],
    );
  }

  Widget _buildTextLine(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w400,
        color: _secondaryText,
      ),
    );
  }

  Widget _buildChildRow(String name, String age) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: '$name ',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600, // Semi-bold for name
              color: _titleColor,
            ),
          ),
          TextSpan(
            text: '($age)',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w400, // Regular for age
              color: _lightGrey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar(BuildContext context, WidgetRef ref) {
    final state = ref.watch(jobPostControllerProvider);

    return Container(
      padding: const EdgeInsets.fromLTRB(24, 10, 24, 22),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Save For Later Button
          TextButton(
            onPressed: state.isLoading
                ? null
                : () async {
                    final success = await ref
                        .read(jobPostControllerProvider.notifier)
                        .saveJobDraft();
                    if (success && context.mounted) {
                      showDialog(
                        context: context,
                        builder: (context) => JobDraftSavedDialog(
                          onEditJob: () {
                            Navigator.of(context).pop(); // Close dialog
                          },
                          onGoToHome: () {
                            ref
                                .read(jobPostControllerProvider.notifier)
                                .resetState();
                            Navigator.of(context).pop(); // Close dialog
                            context.go(Routes.parentHome);
                          },
                          onClose: () {
                            Navigator.of(context).pop(); // Close dialog
                          },
                        ),
                      );
                    } else if (context.mounted) {
                      final latestError =
                          ref.read(jobPostControllerProvider).error;
                      if (latestError != null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(latestError)),
                        );
                      }
                    }
                  },
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: const Text(
              'Save For Later',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF667085), // Grey
              ),
            ),
          ),

          // Submit Button
          GestureDetector(
            onTap: state.isLoading
                ? null
                : () async {
                    final success = await ref
                        .read(jobPostControllerProvider.notifier)
                        .submitJob();
                    if (success && context.mounted) {
                      onSubmit();
                    } else if (context.mounted) {
                      final latestError =
                          ref.read(jobPostControllerProvider).error;
                      if (latestError != null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(latestError)),
                        );
                      }
                    }
                  },
            child: Container(
              width: 200, // ~190-220
              height: 60, // ~56-62
              decoration: BoxDecoration(
                color: state.isLoading
                    ? _primaryBtn.withOpacity(0.5)
                    : _primaryBtn,
                borderRadius: BorderRadius.circular(14), // ~12-14
              ),
              child: Center(
                child: state.isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        'Submit',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
