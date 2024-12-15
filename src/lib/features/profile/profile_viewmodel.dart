import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:my_app/app/app.locator.dart';
import 'package:my_app/app/app.router.dart';
import 'package:my_app/models/user.dart';
import 'package:my_app/services/auth_service.dart';
import 'package:my_app/services/validation_service.dart';

class ProfileViewModel extends BaseViewModel {
  final _authService = locator<AuthService>();
  final _navigationService = locator<NavigationService>();
  final _dialogService = locator<DialogService>();
  final _validationService = locator<ValidationService>();

  User? get currentUser => _authService.currentUser;

  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final specializationController = TextEditingController();
  final phoneNumberController = TextEditingController();

  String? _firstNameError;
  String? _lastNameError;
  String? _specializationError;
  String? _phoneError;

  String? get firstNameError => _firstNameError;
  String? get lastNameError => _lastNameError;
  String? get specializationError => _specializationError;
  String? get phoneError => _phoneError;

  bool _isEditing = false;
  bool get isEditing => _isEditing;

  void init() {
    _loadUserData();
  }

  void _loadUserData() {
    if (currentUser != null) {
      firstNameController.text = currentUser!.firstName;
      lastNameController.text = currentUser!.lastName;
      specializationController.text = currentUser!.specialization;
      phoneNumberController.text = currentUser!.phoneNumber;
    }
  }

  void toggleEdit() {
    _isEditing = !_isEditing;
    notifyListeners();
  }

  bool _validateInputs() {
    bool isValid = true;

    _firstNameError = _validationService.validateName(firstNameController.text);
    if (_firstNameError != null) isValid = false;

    _lastNameError = _validationService.validateName(lastNameController.text);
    if (_lastNameError != null) isValid = false;

    _specializationError = _validationService.validateSpecialization(
      specializationController.text,
    );
    if (_specializationError != null) isValid = false;

    _phoneError = _validationService.validatePhone(phoneNumberController.text);
    if (_phoneError != null) isValid = false;

    notifyListeners();
    return isValid;
  }

  Future<void> saveProfile() async {
    if (!_validateInputs()) return;

    try {
      setBusy(true);
      await _authService.updateProfile(
        firstName: firstNameController.text,
        lastName: lastNameController.text,
        specialization: specializationController.text,
        phoneNumber: phoneNumberController.text,
      );
      _isEditing = false;
      notifyListeners();
    } catch (e) {
      await _dialogService.showDialog(
        title: 'Update Failed',
        description: 'Failed to update profile. Please try again.',
        buttonTitle: 'OK',
      );
    } finally {
      setBusy(false);
    }
  }

  Future<void> logout() async {
    final response = await _dialogService.showDialog(
      title: 'Logout',
      description: 'Are you sure you want to logout?',
      buttonTitle: 'Yes',
      cancelTitle: 'No',
    );

    if (response?.confirmed ?? false) {
      try {
        await _authService.logout();
        await _navigationService.clearStackAndShow(Routes.loginView);
      } catch (e) {
        await _dialogService.showDialog(
          title: 'Logout Failed',
          description: 'Failed to logout. Please try again.',
          buttonTitle: 'OK',
        );
      }
    }
  }

  Future<void> changePassword() async {
    // Implement change password functionality
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    specializationController.dispose();
    phoneNumberController.dispose();
    super.dispose();
  }
}
