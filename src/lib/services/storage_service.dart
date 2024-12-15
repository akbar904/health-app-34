import 'package:flutter/foundation.dart';
import 'package:stacked/stacked.dart';

class StorageService implements InitializableDependency {
  static const String _authTokenKey = 'auth_token';
  static const String _userSettingsKey = 'user_settings';

  Map<String, dynamic> _memoryStorage = {};

  @override
  Future<void> init() async {
    try {
      // Initialize any necessary storage setup
      await _loadPersistedData();
    } catch (e) {
      debugPrint('Error initializing storage service: $e');
      // Clear potentially corrupted data
      await clearAll();
    }
  }

  Future<void> _loadPersistedData() async {
    // Load any persisted data into memory
    // This would typically use shared_preferences or other storage mechanism
  }

  Future<void> saveAuthToken(String token) async {
    try {
      _memoryStorage[_authTokenKey] = token;
      // Persist token
    } catch (e) {
      throw 'Failed to save authentication token';
    }
  }

  Future<String?> getAuthToken() async {
    try {
      return _memoryStorage[_authTokenKey] as String?;
    } catch (e) {
      debugPrint('Error retrieving auth token: $e');
      return null;
    }
  }

  Future<void> clearAuthToken() async {
    try {
      _memoryStorage.remove(_authTokenKey);
      // Remove persisted token
    } catch (e) {
      debugPrint('Error clearing auth token: $e');
    }
  }

  Future<void> saveUserSettings(Map<String, dynamic> settings) async {
    try {
      _memoryStorage[_userSettingsKey] = settings;
      // Persist settings
    } catch (e) {
      throw 'Failed to save user settings';
    }
  }

  Future<Map<String, dynamic>?> getUserSettings() async {
    try {
      return _memoryStorage[_userSettingsKey] as Map<String, dynamic>?;
    } catch (e) {
      debugPrint('Error retrieving user settings: $e');
      return null;
    }
  }

  Future<void> clearUserSettings() async {
    try {
      _memoryStorage.remove(_userSettingsKey);
      // Remove persisted settings
    } catch (e) {
      debugPrint('Error clearing user settings: $e');
    }
  }

  Future<void> clearAll() async {
    try {
      _memoryStorage.clear();
      // Clear all persisted data
    } catch (e) {
      debugPrint('Error clearing all storage: $e');
    }
  }

  Future<void> saveData(String key, dynamic value) async {
    try {
      _memoryStorage[key] = value;
      // Persist data
    } catch (e) {
      throw 'Failed to save data for key: $key';
    }
  }

  Future<dynamic> getData(String key) async {
    try {
      return _memoryStorage[key];
    } catch (e) {
      debugPrint('Error retrieving data for key $key: $e');
      return null;
    }
  }

  Future<void> removeData(String key) async {
    try {
      _memoryStorage.remove(key);
      // Remove persisted data
    } catch (e) {
      debugPrint('Error removing data for key $key: $e');
    }
  }
}
