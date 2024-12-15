import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:my_app/app/app.locator.dart';
import 'package:my_app/app/app.router.dart';
import 'package:my_app/models/patient.dart';
import 'package:my_app/repositories/patient_repository.dart';
import 'package:my_app/services/validation_service.dart';

class PatientDetailsViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();
  final _patientRepository = locator<PatientRepository>();
  final _dialogService = locator<DialogService>();
  final _validationService = locator<ValidationService>();

  String? _patientId;
  Patient? _patient;
  Patient? get patient => _patient;

  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final dobController = TextEditingController();
  final addressController = TextEditingController();
  final bloodGroupController = TextEditingController();
  final heightController = TextEditingController();
  final weightController = TextEditingController();
  final allergiesController = TextEditingController();
  final conditionsController = TextEditingController();

  String? _firstNameError;
  String? _lastNameError;
  String? _emailError;
  String? _phoneError;
  String? _dobError;
  DateTime? _selectedDate;

  String? get firstNameError => _firstNameError;
  String? get lastNameError => _lastNameError;
  String? get emailError => _emailError;
  String? get phoneError => _phoneError;
  String? get dobError => _dobError;
  DateTime? get selectedDate => _selectedDate;

  bool get isEditing => _patientId != null;

  void setPatientId(String? id) {
    _patientId = id;
    if (id != null) {
      loadPatient();
    }
  }

  Future<void> loadPatient() async {
    if (_patientId == null) return;

    try {
      setBusy(true);
      _patient = await _patientRepository.getPatientById(_patientId!);
      _populateFields();
    } catch (e) {
      setError('Failed to load patient details. Please try again.');
    } finally {
      setBusy(false);
    }
  }

  void _populateFields() {
    if (_patient == null) return;

    firstNameController.text = _patient!.firstName;
    lastNameController.text = _patient!.lastName;
    emailController.text = _patient!.email;
    phoneController.text = _patient!.phoneNumber;
    dobController.text = _formatDate(_patient!.dateOfBirth);
    _selectedDate = _patient!.dateOfBirth;
    addressController.text = _patient!.address;
    bloodGroupController.text = _patient!.bloodGroup;
    heightController.text = _patient!.height.toString();
    weightController.text = _patient!.weight.toString();
    allergiesController.text = _patient!.allergies.join(', ');
    conditionsController.text = _patient!.chronicConditions.join(', ');
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  Future<void> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      _selectedDate = picked;
      dobController.text = _formatDate(picked);
      notifyListeners();
    }
  }

  bool _validateInputs() {
    bool isValid = true;

    _firstNameError = _validationService.validateName(firstNameController.text);
    if (_firstNameError != null) isValid = false;

    _lastNameError = _validationService.validateName(lastNameController.text);
    if (_lastNameError != null) isValid = false;

    _emailError = _validationService.validateEmail(emailController.text);
    if (_emailError != null) isValid = false;

    _phoneError = _validationService.validatePhone(phoneController.text);
    if (_phoneError != null) isValid = false;

    if (_selectedDate == null) {
      _dobError = 'Date of birth is required';
      isValid = false;
    }

    notifyListeners();
    return isValid;
  }

  Future<void> savePatient() async {
    if (!_validateInputs()) return;

    try {
      setBusy(true);

      final patientData = {
        'firstName': firstNameController.text,
        'lastName': lastNameController.text,
        'email': emailController.text,
        'phoneNumber': phoneController.text,
        'dateOfBirth': _selectedDate!.toIso8601String(),
        'address': addressController.text,
        'bloodGroup': bloodGroupController.text,
        'height': double.tryParse(heightController.text) ?? 0.0,
        'weight': double.tryParse(weightController.text) ?? 0.0,
        'allergies':
            allergiesController.text.split(',').map((e) => e.trim()).toList(),
        'chronicConditions':
            conditionsController.text.split(',').map((e) => e.trim()).toList(),
      };

      if (isEditing) {
        await _patientRepository.updatePatient(_patientId!, patientData);
      } else {
        await _patientRepository.createPatient(patientData);
      }

      _navigationService.back();
    } catch (e) {
      setError(isEditing
          ? 'Failed to update patient details. Please try again.'
          : 'Failed to create new patient. Please try again.');
    } finally {
      setBusy(false);
    }
  }

  Future<void> deletePatient() async {
    if (_patientId == null) return;

    final response = await _dialogService.showDialog(
      title: 'Delete Patient',
      description:
          'Are you sure you want to delete this patient? This action cannot be undone.',
      buttonTitle: 'Delete',
      cancelTitle: 'Cancel',
    );

    if (response?.confirmed ?? false) {
      try {
        setBusy(true);
        await _patientRepository.deletePatient(_patientId!);
        _navigationService.back();
      } catch (e) {
        setError('Failed to delete patient. Please try again.');
      } finally {
        setBusy(false);
      }
    }
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    dobController.dispose();
    addressController.dispose();
    bloodGroupController.dispose();
    heightController.dispose();
    weightController.dispose();
    allergiesController.dispose();
    conditionsController.dispose();
    super.dispose();
  }
}
