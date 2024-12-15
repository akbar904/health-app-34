import 'package:flutter/foundation.dart';
import 'package:my_app/app/app.locator.dart';
import 'package:my_app/models/user.dart';
import 'package:my_app/repositories/auth_repository.dart';
import 'package:my_app/services/storage_service.dart';
import 'package:stacked/stacked.dart';

class AuthService implements InitializableDependency {
  final _authRepository = locator<AuthRepository>();
  final _storageService = locator<StorageService>();

  User? _currentUser;
  User? get currentUser => _currentUser;

  bool get isAuthenticated => _currentUser != null;

  @override
  Future<void> init() async {
    try {
      final token = await _storageService.getAuthToken();
      if (token != null) {
        _currentUser = await _authRepository.getUserProfile();
      }
    } catch (e) {
      debugPrint('Error initializing auth service: $e');
      await _storageService.clearAuthToken();
      _currentUser = null;
    }
  }

  Future<void> login({
    required String email,
    required String password,
  }) async {
    try {
      final loginResult = await _authRepository.login(
        email: email,
        password: password,
      );
      await _storageService.saveAuthToken(loginResult.token);
      _currentUser = loginResult.user;
    } catch (e) {
      throw 'Invalid email or password. Please try again.';
    }
  }

  Future<void> register({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required String specialization,
    required String licenseNumber,
  }) async {
    try {
      final registerResult = await _authRepository.register(
        email: email,
        password: password,
        firstName: firstName,
        lastName: lastName,
        specialization: specialization,
        licenseNumber: licenseNumber,
      );
      await _storageService.saveAuthToken(registerResult.token);
      _currentUser = registerResult.user;
    } catch (e) {
      throw 'Registration failed. Please check your information and try again.';
    }
  }

  Future<void> logout() async {
    try {
      await _authRepository.logout();
    } finally {
      await _storageService.clearAuthToken();
      _currentUser = null;
    }
  }

  Future<void> updateProfile({
    String? firstName,
    String? lastName,
    String? specialization,
    String? phoneNumber,
  }) async {
    try {
      final updatedUser = await _authRepository.updateProfile(
        firstName: firstName,
        lastName: lastName,
        specialization: specialization,
        phoneNumber: phoneNumber,
      );
      _currentUser = updatedUser;
    } catch (e) {
      throw 'Failed to update profile. Please try again.';
    }
  }

  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      await _authRepository.changePassword(
        currentPassword: currentPassword,
        newPassword: newPassword,
      );
    } catch (e) {
      throw 'Failed to change password. Please check your current password and try again.';
    }
  }

  Future<void> resetPassword(String email) async {
    try {
      await _authRepository.resetPassword(email);
    } catch (e) {
      throw 'Failed to send password reset email. Please check your email address and try again.';
    }
  }
}
