import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../../routing/routes.dart';
import '../controllers/background_check_controller.dart';
import 'package:babysitter_app/src/common_widgets/app_toast.dart';
import '../providers/background_check_status_provider.dart';

/// Screen to submit the background check.
class BackgroundCheckScreen extends ConsumerWidget {
  const BackgroundCheckScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(backgroundCheckControllerProvider);
    final controller = ref.read(backgroundCheckControllerProvider.notifier);

    // Listen for errors
    ref.listen(backgroundCheckControllerProvider, (previous, next) {
      if (next.error != null && previous?.error != next.error) {
        AppToast.show(context, 
          SnackBar(
            content: Text(next.error!),
            backgroundColor: Colors.red,
          ),
        );
      }
    });

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            // Header with status bar color
            Container(
              color: AppColors.surfaceTint,
              child: SafeArea(
                bottom: false,
                child: _buildAppBar(context),
              ),
            ),
            // Rest of the content
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 24.h),
                    // Title
                    Text(
                      'Background Check',
                      style: TextStyle(
                        fontSize: 26.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.buttonDark,
                        fontFamily: 'Inter',
                      ),
                    ),
                    SizedBox(height: 16.h),
                    // Description
                    Text(
                      'Upload a photo of your government-issued ID to verify your identity. We\'ll run your background check through our secure partner.',
                      style: TextStyle(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF667085),
                        fontFamily: 'Inter',
                        height: 1.5,
                      ),
                    ),
                    SizedBox(height: 32.h),

                    // Document Type Selection
                    Text(
                      'Document Type',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.buttonDark,
                        fontFamily: 'Inter',
                      ),
                    ),
                    SizedBox(height: 12.h),
                    _buildDocumentTypeSelector(state, controller),
                    SizedBox(height: 24.h),

                    // File Upload Section
                    Text(
                      'Upload Document',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.buttonDark,
                        fontFamily: 'Inter',
                      ),
                    ),
                    SizedBox(height: 12.h),
                    _buildFileUploadSection(context, state, controller),
                    SizedBox(height: 24.h),
                  ],
                ),
              ),
            ),
            // Bottom Action Area
            Padding(
              padding: EdgeInsets.all(24.w),
              child: Column(
                children: [
                  // Button
                  SizedBox(
                    width: double.infinity,
                    height: 52.h,
                    child: ElevatedButton(
                      onPressed: state.isLoading
                          ? null
                          : () => _handleSubmit(context, ref),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: AppColors.textOnButton,
                        disabledBackgroundColor: AppColors.primary.withOpacity(0.5),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                      child: state.isLoading
                          ? SizedBox(
                              width: 24.w,
                              height: 24.w,
                              child: const CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(AppColors.textOnButton),
                              ),
                            )
                          : Text(
                              'Submit Background Check',
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Inter',
                              ),
                            ),
                    ),
                  ),
                  SizedBox(height: 16.h),
                  // Footer Text
                  Text(
                    'Your sensitive information is securely handled by our screening partner and is not stored in our app.',
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF667085),
                      fontFamily: 'Inter',
                      height: 1.4,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 8.h),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      child: Row(
        children: [
          IconButton(
            onPressed: () => context.pop(),
            icon: Icon(
              Icons.arrow_back_rounded,
              size: 24.w,
              color: const Color(0xFF667085),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDocumentTypeSelector(
    BackgroundCheckState state,
    BackgroundCheckController controller,
  ) {
    return Wrap(
      spacing: 12.w,
      runSpacing: 12.h,
      children: DocumentTypes.all.map((type) {
        final isSelected = state.documentType == type;
        return GestureDetector(
          onTap: () => controller.selectDocumentType(type),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.primary : Colors.white,
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(
                color: isSelected ? AppColors.primary : const Color(0xFFD0D5DD),
                width: 1,
              ),
            ),
            child: Text(
              DocumentTypes.displayName(type),
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: isSelected ? Colors.white : const Color(0xFF344054),
                fontFamily: 'Inter',
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildFileUploadSection(
    BuildContext context,
    BackgroundCheckState state,
    BackgroundCheckController controller,
  ) {
    if (state.selectedFile != null) {
      // Show selected file preview
      return Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: const Color(0xFFF9FAFB),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: const Color(0xFFE5E7EB)),
        ),
        child: Column(
          children: [
            // Image preview
            ClipRRect(
              borderRadius: BorderRadius.circular(8.r),
              child: Image.file(
                state.selectedFile!,
                height: 200.h,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 12.h),
            // File name and remove button
            Row(
              children: [
                Expanded(
                  child: Text(
                    state.selectedFile!.path.split('/').last,
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: const Color(0xFF344054),
                      fontFamily: 'Inter',
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                IconButton(
                  onPressed: controller.clearFile,
                  icon: Icon(
                    Icons.close,
                    size: 20.w,
                    color: const Color(0xFF667085),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    }

    // Show upload options
    return Container(
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: const Color(0xFFE5E7EB),
          style: BorderStyle.solid,
        ),
      ),
      child: Column(
        children: [
          Icon(
            Icons.cloud_upload_outlined,
            size: 48.w,
            color: AppColors.primary,
          ),
          SizedBox(height: 16.h),
          Text(
            'Upload your ID document',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF344054),
              fontFamily: 'Inter',
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'JPG, PNG or PDF (max 10MB)',
            style: TextStyle(
              fontSize: 14.sp,
              color: const Color(0xFF667085),
              fontFamily: 'Inter',
            ),
          ),
          SizedBox(height: 20.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Take Photo Button
              _buildUploadButton(
                icon: Icons.camera_alt_outlined,
                label: 'Take Photo',
                onTap: controller.takePhoto,
              ),
              SizedBox(width: 16.w),
              // Choose from Gallery Button
              _buildUploadButton(
                icon: Icons.photo_library_outlined,
                label: 'Gallery',
                onTap: controller.pickImageFromGallery,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildUploadButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(color: AppColors.primary),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 20.w,
              color: AppColors.primary,
            ),
            SizedBox(width: 8.w),
            Text(
              label,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: AppColors.primary,
                fontFamily: 'Inter',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleSubmit(BuildContext context, WidgetRef ref) async {
    final controller = ref.read(backgroundCheckControllerProvider.notifier);
    final success = await controller.submitBackgroundCheck();

    if (success && context.mounted) {
      ref.invalidate(backgroundCheckStatusProvider);
      context.push(Routes.sitterBackgroundCheckComplete);
    }
  }
}
