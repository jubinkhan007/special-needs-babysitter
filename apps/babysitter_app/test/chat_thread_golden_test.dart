import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:babysitter_app/src/features/messages/presentation/chat_thread_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:babysitter_app/src/features/messages/domain/chat_thread_args.dart';
import 'package:babysitter_app/src/features/messages/presentation/providers/chat_providers.dart';
import 'package:auth/auth.dart';
import 'package:domain/domain.dart';

void main() {
  Widget createScreen() {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      builder: (context, child) {
        return ProviderScope(
          overrides: [
            currentUserProvider.overrideWith((ref) async => const User(
                  id: 'current-user-id',
                  email: 'test@example.com',
                  role: UserRole.parent,
                  firstName: 'Current',
                  lastName: 'User',
                )),
            chatMessagesProvider.overrideWith(TestChatMessagesNotifier.new),
          ],
          child: const MaterialApp(
            debugShowCheckedModeBanner: false,
            home: ChatThreadScreen(
              args: ChatThreadArgs(
                otherUserId: 'test-user',
                otherUserName: 'Test User',
                otherUserAvatarUrl: null,
                isVerified: false,
              ),
            ),
          ),
        );
      },
    );
  }

  testWidgets('Chat Thread Screen - Golden Test', (tester) async {
    // 1. Pump widget
    await tester.pumpWidget(createScreen());

    // 2. Wait for rendering (and any images/animations)
    await tester.pumpAndSettle();

    // 3. Match golden file
    await expectLater(
      find.byType(ChatThreadScreen),
      matchesGoldenFile('goldens/chat_thread_screen.png'),
    );
  });
}

class TestChatMessagesNotifier
    extends ChatMessagesNotifier {
  @override
  Future<List<ChatMessageEntity>> build(String arg) async {
    return [];
  }
}
