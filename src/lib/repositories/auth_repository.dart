import 'package:my_app/models/user.dart';
import 'package:my_app/services/api_service.dart';
import 'package:my_app/app/app.locator.dart';

class AuthRepository {
  final _apiService = locator<ApiService>();

  Future<({String token, User user})> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _apiService.post(
        '/auth/login',
        body: {
          'email': email,
          'password': password,
        },
      );

      return (
        token: response['token'] as String,
        user: User.fromJson(response['user'] as Map<String, dynamic>),
      );
    } catch (e) {
      throw 'Login failed. Please check your credentials and try again.';
    }
  }

  Future<({String token, User user})> register({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required String specialization,
    required String licenseNumber,
  }) async {
    try {
      final response = await _apiService.post(
        '/auth/register',
        body: {
          'email': email,
          'password': password,
          'firstName': firstName,
          'lastName': lastName,
          'specialization': specialization,
          'licenseNumber': licenseNumber,
          'role': 'doctor',
        },
      );

      return (
        token: response['token'] as String,
        user: User.fromJson(response['user'] as Map<String, dynamic>),
      );
    } catch (e) {
      throw 'Registration failed. Please check your information and try again.';
    }
  }

  Future<void> logout() async {
    try {
      await _apiService.post('/auth/logout');
    } catch (e) {
      throw 'Logout failed. Please try again.';
    }
  }

  Future<User> getUserProfile() async {
    try {
      final response = await _apiService.get('/auth/profile');
      return User.fromJson(response as Map<String, dynamic>);
    } catch (e) {
      throw 'Failed to fetch user profile.';
    }
  }

  Future<User> updateProfile({
    String? firstName,
    String? lastName,
    String? specialization,
    String? phoneNumber,
  }) async {
    try {
      final response = await _apiService.put(
        '/auth/profile',
        body: {
          if (firstName != null) 'firstName': firstName,
          if (lastName != null) 'lastName': lastName,
          if (specialization != null) 'specialization': specialization,
          if (phoneNumber != null) 'phoneNumber': phoneNumber,
        },
      );
      return User.fromJson(response as Map<String, dynamic>);
    } catch (e) {
      throw 'Failed to update profile. Please try again.';
    }
  }

  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      await _apiService.put(
        '/auth/change-password',
        body: {
          'currentPassword': currentPassword,
          'newPassword': newPassword,
        },
      );
    } catch (e) {
      throw 'Password change failed. Please verify your current password and try again.';
    }
  }

  Future<void> resetPassword(String email) async {
    try {
      await _apiService.post(
        '/auth/reset-password',
        body: {'email': email},
      );
    } catch (e) {
      throw 'Failed to send password reset email. Please verify your email address.';
    }
  }
}
