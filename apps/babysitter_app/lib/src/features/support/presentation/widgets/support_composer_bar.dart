import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:babysitter_app/src/theme/app_tokens.dart';

class SupportComposerBar extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSend;
  final VoidCallback onCameraTap;
  final VoidCallback onAttachTap;

  const SupportComposerBar({
    super.key,
    required this.controller,
    required this.onSend,
    required this.onCameraTap,
    required this.onAttachTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: AppTokens.chatHPadding,
        right: AppTokens.chatHPadding,
        top: 12.h,
        bottom: MediaQuery.of(context).padding.bottom + 12.h,
      ),
      alignment: Alignment
          .topCenter, // Ensures content is top aligned within the container
      color: AppTokens.supportComposerBg,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment
            .center, // Align items vertically center in the row
        children: [
          // Text Field Container
          Expanded(
            child: Container(
              height:
                  48.h, // Fixed height for the composer field as per screenshot
              decoration: BoxDecoration(
                color: AppTokens.supportComposerFieldBg,
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(
                  color: Colors.transparent, // No visible border in screenshot
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  SizedBox(width: 16.w),
                  Expanded(
                    child: TextField(
                      controller: controller,
                      decoration: InputDecoration(
                        hintText:
                            'Type your message....', // 4 dots in screenshot
                        hintStyle: AppTokens.composerHintStyle,
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                      ),
                      style: AppTokens.chatBubbleStyle
                          .copyWith(color: Colors.black),
                    ),
                  ),

                  // Trailing Icons inside field
                  IconButton(
                    onPressed: onCameraTap,
                    icon: Icon(
                      Icons.camera_alt_outlined,
                      color: AppTokens.supportComposerIconColor,
                      size: 24.w,
                    ),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                  SizedBox(width: 12.w),
                  IconButton(
                    onPressed: onAttachTap,
                    icon: Icon(
                      Icons.attach_file_rounded, // Paperclip
                      color: AppTokens.supportComposerIconColor,
                      size: 24.w,
                    ),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                  SizedBox(width: 12.w),
                ],
              ),
            ),
          ),

          SizedBox(width: 12.w),

          // Send Button
          GestureDetector(
            onTap: onSend,
            child: Container(
              width: 48.w, // Match field height
              height: 48.w,
              decoration: const BoxDecoration(
                color: AppTokens.supportSendBtnBg,
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Icon(
                Icons.send_rounded, // Paper plane
                color: AppTokens.supportSendBtnIcon,
                size: 24.w,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
