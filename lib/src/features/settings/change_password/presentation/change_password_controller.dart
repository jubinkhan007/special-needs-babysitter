import 'package:flutter/material.dart';

/// Controller for Change Password / Reset Password screen
class ChangePasswordController extends ChangeNotifier {
  final TextEditingController emailController = TextEditingController();

  String? _emailError;
  bool _isLoading = false;

  String? get emailError => _emailError;
  bool get isLoading => _isLoading;

  /// Validates the email format
  bool get isEmailValid {
    final email = emailController.text.trim();
    if (email.isEmpty) return false;
    // Basic email regex
    final regex = RegExp(r'^[\w\-\.]+@([\w\-]+\.)+[\w\-]{2,}$');
    return regex.hasMatch(email);
  }

  /// Validates email and returns error if invalid
  String? validateEmail() {
    final email = emailController.text.trim();
    if (email.isEmpty) {
      return 'Email is required';
    }
    final regex = RegExp(r'^[\w\-\.]+@([\w\-]+\.)+[\w\-]{2,}$');
    if (!regex.hasMatch(email)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  /// Sends reset link (stubbed for now)
  Future<void> sendResetLink() async {
    _emailError = validateEmail();
    if (_emailError != null) {
      notifyListeners();
      return;
    }

    _isLoading = true;
    _emailError = null;
    notifyListeners();

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    _isLoading = false;
    notifyListeners();

    // TODO: Integrate with actual password reset API
  }

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }
}
