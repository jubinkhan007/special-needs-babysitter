import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:go_router/go_router.dart';

import '../../../../../theme/app_tokens.dart';
import '../../../../../routing/routes.dart';

import '../providers/application_providers.dart';
import '../widgets/job_details_preview_card.dart';
import '../widgets/cover_letter_preview_card.dart';
import '../widgets/application_bottom_bar.dart';
import '../widgets/application_submitted_dialog.dart';

/// Sitter Application Preview Screen.
class SitterApplicationPreviewScreen extends ConsumerWidget {
  final String jobId;
  final String coverLetter;

  const SitterApplicationPreviewScreen({
    super.key,
    required this.jobId,
    required this.coverLetter,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Override the preview provider with the one that includes the real cover letter
    final previewAsync = ref.watch(applicationPreviewProviderWithData((
      jobId: jobId,
      coverLetter: coverLetter,
    )));
    final submitState = ref.watch(submitApplicationControllerProvider);

    // Listen for success state to show snackbar and navigate back
    ref.listen<SubmitApplicationState>(
      submitApplicationControllerProvider,
      (previous, next) {
        if (next.isSuccess && previous?.isSuccess != true) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => ApplicationSubmittedDialog(
              onViewApplications: () {
                context.pop(); // Pop dialog
                context.go(Routes.sitterJobs);
              },
            ),
          ).then((_) {
            // If they just closed the dialog without clicking the button,
            // we should still go somewhere other than the preview screen.
            if (context.mounted &&
                GoRouterState.of(context)
                    .uri
                    .toString()
                    .contains('application-preview')) {
              context.go(Routes.sitterHome);
            }
          });
        }
        if (next.error != null && previous?.error != next.error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: ${next.error}'),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
              margin: EdgeInsets.all(16.w),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
          );
        }
      },
    );

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      body: Column(
        children: [
          // App bar
          _buildAppBar(context),
          // Content
          Expanded(
            child: previewAsync.when(
              data: (preview) => SingleChildScrollView(
                padding: EdgeInsets.all(16.w),
                child: Column(
                  children: [
                    // Card 1 - Job Details Preview
                    JobDetailsPreviewCard(jobDetails: preview.jobDetails),
                    SizedBox(height: 12.h),
                    // Card 2 - Cover Letter Preview
                    CoverLetterPreviewCard(coverLetter: preview.coverLetter),
                    // Extra padding at bottom to avoid bottom bar overlap
                    SizedBox(height: 20.h),
                  ],
                ),
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(
                child: Padding(
                  padding: EdgeInsets.all(16.w),
                  child: Text(
                    'Error loading preview: $error',
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 14.sp,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ),
          // Bottom bar
          previewAsync.maybeWhen(
            data: (preview) => ApplicationBottomBar(
              isLoading: submitState.isLoading,
              onCancel: () => context.pop(),
              onSubmit: () {
                ref.read(submitApplicationControllerProvider.notifier).submit(
                      jobId: preview.jobId,
                      coverLetter: preview.coverLetter,
                    );
              },
            ),
            orElse: () => const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Container(
      height: 56.h + MediaQuery.of(context).padding.top,
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      decoration: const BoxDecoration(
        color: AppTokens.bg,
      ),
      child: Row(
        children: [
          // Back button
          IconButton(
            onPressed: () => context.pop(),
            icon: Icon(
              Icons.arrow_back_ios_new_rounded,
              size: 20.w,
              color: AppTokens.iconGrey,
            ),
          ),
          // Title
          Expanded(
            child: Center(
              child: Text(
                'Application Preview',
                style: TextStyle(
                  fontSize: 17.sp,
                  fontWeight: FontWeight.w500,
                  color: AppTokens.appBarTitleGrey,
                  fontFamily: 'Inter',
                ),
              ),
            ),
          ),
          // Support icon
          IconButton(
            onPressed: () {
              // TODO: Open support
            },
            icon: Icon(
              Icons.headset_mic_outlined,
              size: 22.w,
              color: AppTokens.iconGrey,
            ),
          ),
        ],
      ),
    );
  }
}
