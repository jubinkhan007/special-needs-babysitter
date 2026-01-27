import 'package:flutter/material.dart';
import 'package:core/core.dart';
import '../../../../theme/app_tokens.dart';

class ChatComposerBar extends StatelessWidget {
  final TextEditingController? controller;
  final VoidCallback? onSend;

  const ChatComposerBar({super.key, this.controller, this.onSend});

  @override
  Widget build(BuildContext context) {
    // Sticky bottom composer
    return Theme(
      data: AppTheme.lightTheme,
      child: Container(
        padding: EdgeInsets.only(
          left: AppTokens.chatHorizontalPadding,
          right: AppTokens.chatHorizontalPadding,
          top: 12,
          bottom: 0, // Removed manual padding, relying on SafeArea
        ),
        decoration: const BoxDecoration(
          color: AppTokens.composerBg,
          border: Border(
            top: BorderSide.none,
          ),
        ),
        child: SafeArea(
          top: false,
          child: Row(
            children: [
              // Text Field
              Expanded(
                child: Container(
                  height: AppTokens.composerFieldHeight,
                  decoration: BoxDecoration(
                    color: AppTokens.composerFieldBg,
                    borderRadius: BorderRadius.circular(12),
                    // border: Border.all(color: AppTokens.composerFieldBorder), // Removed border
                  ),
                  child: Row(
                    children: [
                      const SizedBox(width: 16),
                      Expanded(
                        child: TextField(
                          controller: controller,
                          style: AppTokens.composerHintStyle.copyWith(color: AppTokens.textPrimary),
                          decoration: InputDecoration(
                            hintText: 'Type your message....',
                            hintStyle: AppTokens.composerHintStyle,
                            border: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            errorBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,
                            isDense: true,
                            contentPadding: EdgeInsets.zero,
                            filled: false,
                          ),
                        ),
                      ),
                      // Inner Actions
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons
                            .camera_alt_outlined), // Matches screenshot square camera
                        color: AppTokens.composerIconColor,
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                      const SizedBox(width: 12),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.attach_file), // Paperclip
                        color: AppTokens
                            .composerIconColor, // Icon rotation might be needed if standard is vertical
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                      const SizedBox(width: 12),
                    ],
                  ),
                ),
              ),
  
              const SizedBox(width: 12),
  
              // Send Button
              GestureDetector(
                onTap: onSend,
                child: Container(
                  width: AppTokens.sendButtonSize,
                  height: AppTokens.sendButtonSize,
                  decoration: const BoxDecoration(
                    color: AppTokens.sendButtonBg,
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Icon(
                      Icons
                          .send_rounded, // Use rounded send icon similar to arrow
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
