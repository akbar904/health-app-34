import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:my_app/app/app.locator.dart';
import 'package:my_app/models/consultation.dart';
import 'package:my_app/models/patient.dart';
import 'package:my_app/repositories/consultation_repository.dart';
import 'package:my_app/repositories/patient_repository.dart';
import 'package:my_app/services/validation_service.dart';

class ConsultationFormViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();
  final _dialogService = locator<DialogService>();
  final _consultationRepository = locator<ConsultationRepository>();
  final _patientRepository = locator<PatientRepository>();
  final _validationService = locator<ValidationService>();

  String? _consultationId;
  Patient? _selectedPatient;
  Consultation? _consultation;

  Patient? get selectedPatient => _selectedPatient;
  bool get isEditing => _consultationId != null;

  final chiefComplaintController = TextEditingController();
  final diagnosisController = TextEditingController();
  final symptomsController = TextEditingController();
  final prescriptionsController = TextEditingController();
  final notesController = TextEditingController();
  final List<String> attachments = [];

  DateTime? _consultationDate;
  DateTime? _followUpDate;
  String _status = 'pending';

  String? _chiefComplaintError;
  String? _diagnosisError;
  String? _symptomsError;
  String? _prescriptionsError;

  String? get chiefComplaintError => _chiefComplaintError;
  String? get diagnosisError => _diagnosisError;
  String? get symptomsError => _symptomsError;
  String? get prescriptionsError => _prescriptionsError;
  DateTime? get consultationDate => _consultationDate;
  DateTime? get followUpDate => _followUpDate;
  String get status => _status;

  void setConsultationId(String? id) {
    _consultationId = id;
    if (id != null) {
      loadConsultation();
    } else {
      _consultationDate = DateTime.now();
    }
  }

  Future<void> loadConsultation() async {
    try {
      setBusy(true);
      _consultation =
          await _consultationRepository.getConsultationById(_consultationId!);
      _populateFields();
    } catch (e) {
      setError('Failed to load consultation details. Please try again.');
    } finally {
      setBusy(false);
    }
  }

  void _populateFields() {
    if (_consultation == null) return;

    chiefComplaintController.text = _consultation!.chiefComplaint;
    diagnosisController.text = _consultation!.diagnosis;
    symptomsController.text = _consultation!.symptoms.join(', ');
    prescriptionsController.text = _consultation!.prescriptions.join(', ');
    notesController.text = _consultation!.notes;
    _consultationDate = _consultation!.consultationDate;
    _followUpDate = _consultation!.followUpDate;
    _status = _consultation!.status;
    attachments.addAll(_consultation!.attachments ?? []);
    loadPatient(_consultation!.patientId);
  }

  Future<void> loadPatient(String patientId) async {
    try {
      _selectedPatient = await _patientRepository.getPatientById(patientId);
      notifyListeners();
    } catch (e) {
      setError('Failed to load patient details. Please try again.');
    }
  }

  Future<void> selectPatient() async {
    // Implement patient selection logic
  }

  Future<void> selectConsultationDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _consultationDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      _consultationDate = picked;
      notifyListeners();
    }
  }

  Future<void> selectFollowUpDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _followUpDate ?? DateTime.now().add(const Duration(days: 7)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (picked != null) {
      _followUpDate = picked;
      notifyListeners();
    }
  }

  void updateStatus(String newStatus) {
    _status = newStatus;
    notifyListeners();
  }

  bool _validateInputs() {
    bool isValid = true;

    if (_selectedPatient == null) {
      setError('Please select a patient');
      return false;
    }

    _chiefComplaintError = _validationService.validateRequired(
      chiefComplaintController.text,
      'Chief complaint',
    );
    if (_chiefComplaintError != null) isValid = false;

    _diagnosisError = _validationService.validateDiagnosis(
      diagnosisController.text,
    );
    if (_diagnosisError != null) isValid = false;

    _symptomsError = _validationService.validateRequired(
      symptomsController.text,
      'Symptoms',
    );
    if (_symptomsError != null) isValid = false;

    _prescriptionsError = _validationService.validatePrescription(
      prescriptionsController.text,
    );
    if (_prescriptionsError != null) isValid = false;

    notifyListeners();
    return isValid;
  }

  Future<void> saveConsultation() async {
    if (!_validateInputs()) return;

    try {
      setBusy(true);

      final consultationData = {
        'patientId': _selectedPatient!.id,
        'chiefComplaint': chiefComplaintController.text,
        'diagnosis': diagnosisController.text,
        'symptoms':
            symptomsController.text.split(',').map((e) => e.trim()).toList(),
        'prescriptions': prescriptionsController.text
            .split(',')
            .map((e) => e.trim())
            .toList(),
        'notes': notesController.text,
        'consultationDate': _consultationDate!.toIso8601String(),
        'followUpDate': _followUpDate?.toIso8601String(),
        'status': _status,
        'attachments': attachments,
      };

      if (isEditing) {
        await _consultationRepository.updateConsultation(
            _consultationId!, consultationData);
      } else {
        await _consultationRepository.createConsultation(consultationData);
      }

      _navigationService.back();
    } catch (e) {
      setError(isEditing
          ? 'Failed to update consultation. Please try again.'
          : 'Failed to create consultation. Please try again.');
    } finally {
      setBusy(false);
    }
  }

  Future<void> addAttachment() async {
    // Implement attachment logic
  }

  void removeAttachment(int index) {
    if (index >= 0 && index < attachments.length) {
      attachments.removeAt(index);
      notifyListeners();
    }
  }

  @override
  void dispose() {
    chiefComplaintController.dispose();
    diagnosisController.dispose();
    symptomsController.dispose();
    prescriptionsController.dispose();
    notesController.dispose();
    super.dispose();
  }
}
