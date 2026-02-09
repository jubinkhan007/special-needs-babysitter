import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:domain/domain.dart';
import 'package:core/core.dart';

import 'sign_up_providers.dart';

/// State for sign-up controller
sealed class SignUpState {
  const SignUpState();
}

class SignUpIdle extends SignUpState {
  const SignUpIdle();
}

class SignUpLoadingQuestions extends SignUpState {
  const SignUpLoadingQuestions();
}

class SignUpQuestionsLoaded extends SignUpState {
  final List<String> questions;
  const SignUpQuestionsLoaded(this.questions);
}

class SignUpQuestionsError extends SignUpState {
  final String message;
  const SignUpQuestionsError(this.message);
}

class SignUpSubmitting extends SignUpState {
  const SignUpSubmitting();
}

class SignUpSuccess extends SignUpState {
  final RegisteredUser user;
  const SignUpSuccess(this.user);
}

class SignUpError extends SignUpState {
  final String message;
  const SignUpError(this.message);
}

/// Controller for sign-up flow
class SignUpController extends Notifier<SignUpState> {
  @override
  SignUpState build() => const SignUpIdle();

  /// Load security questions for Step2 dropdown
  Future<void> loadSecurityQuestions() async {
    state = const SignUpLoadingQuestions();

    try {
      final useCase = ref.read(getSecurityQuestionsUseCaseProvider);
      final questions = await useCase.call(const NoParams());
      state = SignUpQuestionsLoaded(questions);
    } on Failure catch (e) {
      state = SignUpQuestionsError(e.message);
    } catch (e) {
      state = const SignUpQuestionsError('Failed to load security questions');
    }
  }

  /// Submit registration and send OTP (sequential flow)
  /// Returns RegisteredUser on success, null on failure
  Future<RegisteredUser?> submitRegistration(
      Map<String, String> formData) async {
    state = const SignUpSubmitting();

    try {
      final useCase = ref.read(registerAndSendOtpUseCaseProvider);

      final payload = RegistrationPayload(
        email: formData['email'] ?? '',
        password: formData['password'] ?? '',
        firstName: formData['firstName'] ?? '',
        middleInitial: formData['middleInitial'],
        lastName: formData['lastName'] ?? '',
        phone: formData['phone'] ?? '',
        role: formData['role'] ?? 'parent',
        securityQuestion: formData['securityQuestion'] ?? '',
        securityAnswer: formData['securityAnswer'] ?? '',
        referralCode: formData['referralCode'],
      );

      // Debug: print the payload being sent
      debugPrint('📤 Registration payload: ${payload.toJson()}');

      final user = await useCase.call(payload);
      state = SignUpSuccess(user);
      return user;
    } on Failure catch (e) {
      state = SignUpError(e.message);
      return null;
    } catch (e) {
      state = const SignUpError('Something went wrong. Please try again');
      return null;
    }
  }

  /// Reset state to idle
  void reset() {
    state = const SignUpIdle();
  }
}

/// Provider for SignUpController
final signUpControllerProvider =
    NotifierProvider<SignUpController, SignUpState>(() {
  return SignUpController();
});
