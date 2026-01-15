import 'package:flutter/material.dart';

/// Controller for Reset Password screen (Step 2)
class ResetPasswordController extends ChangeNotifier {
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  String? _passwordError;
  String? _confirmPasswordError;
  bool _isLoading = false;

  String? get passwordError => _passwordError;
  String? get confirmPasswordError => _confirmPasswordError;
  bool get isLoading => _isLoading;

  /// Validates password (minimum 8 characters)
  String? validatePassword() {
    final password = passwordController.text;
    if (password.isEmpty) {
      return 'Password is required';
    }
    if (password.length < 8) {
      return 'Password must be at least 8 characters';
    }
    return null;
  }

  /// Validates confirm password matches password
  String? validateConfirmPassword() {
    final confirmPassword = confirmPasswordController.text;
    if (confirmPassword.isEmpty) {
      return 'Please confirm your password';
    }
    if (confirmPassword != passwordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  /// Check if form is valid
  bool get isValid {
    return validatePassword() == null && validateConfirmPassword() == null;
  }

  /// Saves the new password (stubbed for now)
  Future<bool> savePassword() async {
    _passwordError = validatePassword();
    _confirmPasswordError = validateConfirmPassword();
    notifyListeners();

    if (!isValid) {
      return false;
    }

    _isLoading = true;
    notifyListeners();

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    _isLoading = false;
    notifyListeners();

    // TODO: Integrate with actual password reset API
    return true;
  }

  @override
  void dispose() {
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }
}
