import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:my_app/app/app.locator.dart';
import 'package:my_app/app/app.router.dart';
import 'package:my_app/services/auth_service.dart';
import 'package:my_app/services/validation_service.dart';

class RegisterViewModel extends BaseViewModel {
  final _authService = locator<AuthService>();
  final _navigationService = locator<NavigationService>();
  final _validationService = locator<ValidationService>();

  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final licenseController = TextEditingController();
  final specializationController = TextEditingController();

  String? _firstNameError;
  String? _lastNameError;
  String? _emailError;
  String? _passwordError;
  String? _licenseError;
  String? _specializationError;

  bool _showPassword = false;

  String? get firstNameError => _firstNameError;
  String? get lastNameError => _lastNameError;
  String? get emailError => _emailError;
  String? get passwordError => _passwordError;
  String? get licenseError => _licenseError;
  String? get specializationError => _specializationError;
  bool get showPassword => _showPassword;

  void togglePasswordVisibility() {
    _showPassword = !_showPassword;
    notifyListeners();
  }

  bool _validateInputs() {
    bool isValid = true;

    _firstNameError = _validationService.validateName(firstNameController.text);
    if (_firstNameError != null) isValid = false;

    _lastNameError = _validationService.validateName(lastNameController.text);
    if (_lastNameError != null) isValid = false;

    _emailError = _validationService.validateEmail(emailController.text);
    if (_emailError != null) isValid = false;

    _passwordError =
        _validationService.validatePassword(passwordController.text);
    if (_passwordError != null) isValid = false;

    _licenseError =
        _validationService.validateLicenseNumber(licenseController.text);
    if (_licenseError != null) isValid = false;

    _specializationError = _validationService.validateSpecialization(
      specializationController.text,
    );
    if (_specializationError != null) isValid = false;

    notifyListeners();
    return isValid;
  }

  Future<void> register() async {
    if (!_validateInputs()) return;

    try {
      setBusy(true);
      await _authService.register(
        email: emailController.text,
        password: passwordController.text,
        firstName: firstNameController.text,
        lastName: lastNameController.text,
        specialization: specializationController.text,
        licenseNumber: licenseController.text,
      );
      await _navigationService.clearStackAndShow(Routes.dashboardView);
    } catch (e) {
      setError(
          'Registration failed. Please verify your information and try again.');
    } finally {
      setBusy(false);
    }
  }

  void navigateToLogin() {
    _navigationService.back();
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    licenseController.dispose();
    specializationController.dispose();
    super.dispose();
  }
}
