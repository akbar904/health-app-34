import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:my_app/app/app.locator.dart';
import 'package:my_app/services/storage_service.dart';
import 'package:stacked/stacked.dart';

class ApiService implements InitializableDependency {
  final _storageService = locator<StorageService>();

  static const String _baseUrl = 'https://api.example.com/v1';
  String? _authToken;

  @override
  Future<void> init() async {
    _authToken = await _storageService.getAuthToken();
  }

  Future<dynamic> get(String endpoint) async {
    try {
      // Simulated API call
      await Future.delayed(const Duration(milliseconds: 500));

      if (endpoint.contains('error')) {
        throw 'API Error: Request failed';
      }

      // Mock response
      return {'success': true, 'data': []};
    } catch (e) {
      debugPrint('GET Error: $e');
      throw _handleError(e);
    }
  }

  Future<dynamic> post(String endpoint, {Map<String, dynamic>? body}) async {
    try {
      // Simulated API call
      await Future.delayed(const Duration(milliseconds: 500));

      if (endpoint.contains('error')) {
        throw 'API Error: Request failed';
      }

      // Mock response
      return {
        'success': true,
        'data': body ?? {},
      };
    } catch (e) {
      debugPrint('POST Error: $e');
      throw _handleError(e);
    }
  }

  Future<dynamic> put(String endpoint, {Map<String, dynamic>? body}) async {
    try {
      // Simulated API call
      await Future.delayed(const Duration(milliseconds: 500));

      if (endpoint.contains('error')) {
        throw 'API Error: Request failed';
      }

      // Mock response
      return {
        'success': true,
        'data': body ?? {},
      };
    } catch (e) {
      debugPrint('PUT Error: $e');
      throw _handleError(e);
    }
  }

  Future<dynamic> delete(String endpoint) async {
    try {
      // Simulated API call
      await Future.delayed(const Duration(milliseconds: 500));

      if (endpoint.contains('error')) {
        throw 'API Error: Request failed';
      }

      // Mock response
      return {'success': true};
    } catch (e) {
      debugPrint('DELETE Error: $e');
      throw _handleError(e);
    }
  }

  Map<String, String> get _headers {
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    if (_authToken != null) {
      headers['Authorization'] = 'Bearer $_authToken';
    }

    return headers;
  }

  String _handleError(dynamic error) {
    if (error is String) {
      return error;
    }

    // Handle different error types and return user-friendly messages
    return 'An unexpected error occurred. Please try again later.';
  }

  void setAuthToken(String? token) {
    _authToken = token;
  }

  String _buildUrl(String endpoint) {
    return '$_baseUrl${endpoint.startsWith('/') ? endpoint : '/$endpoint'}';
  }

  void dispose() {
    _authToken = null;
  }
}
