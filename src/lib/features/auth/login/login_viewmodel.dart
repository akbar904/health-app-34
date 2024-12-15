import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:my_app/app/app.locator.dart';
import 'package:my_app/app/app.router.dart';
import 'package:my_app/services/auth_service.dart';
import 'package:my_app/services/validation_service.dart';

class LoginViewModel extends BaseViewModel {
  final _authService = locator<AuthService>();
  final _validationService = locator<ValidationService>();
  final _navigationService = locator<NavigationService>();
  final _dialogService = locator<DialogService>();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  String? _emailError;
  String? _passwordError;
  bool _showPassword = false;

  String? get emailError => _emailError;
  String? get passwordError => _passwordError;
  bool get showPassword => _showPassword;

  void togglePasswordVisibility() {
    _showPassword = !_showPassword;
    notifyListeners();
  }

  bool _validateInputs() {
    bool isValid = true;

    _emailError = _validationService.validateEmail(emailController.text);
    if (_emailError != null) isValid = false;

    _passwordError =
        _validationService.validatePassword(passwordController.text);
    if (_passwordError != null) isValid = false;

    notifyListeners();
    return isValid;
  }

  Future<void> login() async {
    if (!_validateInputs()) return;

    try {
      setBusy(true);
      await _authService.login(
        email: emailController.text,
        password: passwordController.text,
      );
      await _navigationService.clearStackAndShow(Routes.dashboardView);
    } catch (e) {
      setError('Failed to login. Please check your credentials and try again.');
      await _dialogService.showDialog(
        title: 'Login Failed',
        description: modelError.toString(),
        buttonTitle: 'OK',
      );
    } finally {
      setBusy(false);
    }
  }

  Future<void> forgotPassword() async {
    // Implement forgot password logic
  }

  void navigateToRegister() {
    _navigationService.navigateTo(Routes.registerView);
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
