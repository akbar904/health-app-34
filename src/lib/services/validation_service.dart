import 'package:flutter/material.dart';

class ValidationService {
  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+',
    );
    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters long';
    }
    return null;
  }

  String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Name is required';
    }
    if (value.length < 2) {
      return 'Name must be at least 2 characters long';
    }
    return null;
  }

  String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone number is required';
    }
    final phoneRegex = RegExp(r'^\+?[\d\s-]+$');
    if (!phoneRegex.hasMatch(value)) {
      return 'Please enter a valid phone number';
    }
    return null;
  }

  String? validateRequired(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  String? validateAge(String? value) {
    if (value == null || value.isEmpty) {
      return 'Age is required';
    }
    final age = int.tryParse(value);
    if (age == null) {
      return 'Please enter a valid age';
    }
    if (age < 0 || age > 150) {
      return 'Please enter a valid age between 0 and 150';
    }
    return null;
  }

  String? validateDate(DateTime? value) {
    if (value == null) {
      return 'Date is required';
    }
    if (value.isAfter(DateTime.now())) {
      return 'Date cannot be in the future';
    }
    return null;
  }

  String? validateLicenseNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'License number is required';
    }
    if (value.length < 5) {
      return 'Please enter a valid license number';
    }
    return null;
  }

  String? validateSpecialization(String? value) {
    if (value == null || value.isEmpty) {
      return 'Specialization is required';
    }
    return null;
  }

  String? validateDiagnosis(String? value) {
    if (value == null || value.isEmpty) {
      return 'Diagnosis is required';
    }
    if (value.length < 10) {
      return 'Please provide a more detailed diagnosis';
    }
    return null;
  }

  String? validatePrescription(String? value) {
    if (value == null || value.isEmpty) {
      return 'Prescription details are required';
    }
    if (value.length < 5) {
      return 'Please provide more detailed prescription information';
    }
    return null;
  }

  String? validateNotes(String? value) {
    if (value != null && value.isNotEmpty && value.length < 5) {
      return 'Notes should be at least 5 characters long';
    }
    return null;
  }
}
