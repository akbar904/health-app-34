import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:my_app/app/app.locator.dart';
import 'package:my_app/app/app.router.dart';
import 'package:my_app/models/consultation.dart';
import 'package:my_app/services/auth_service.dart';
import 'package:my_app/repositories/consultation_repository.dart';
import 'package:my_app/repositories/patient_repository.dart';

class DashboardViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();
  final _authService = locator<AuthService>();
  final _consultationRepository = locator<ConsultationRepository>();
  final _patientRepository = locator<PatientRepository>();

  int _currentIndex = 0;
  int get currentIndex => _currentIndex;

  String get doctorName =>
      '${_authService.currentUser?.firstName} ${_authService.currentUser?.lastName}';

  int _totalPatients = 0;
  int get totalPatients => _totalPatients;

  int _todayAppointments = 0;
  int get todayAppointments => _todayAppointments;

  int _todayConsultations = 0;
  int get todayConsultations => _todayConsultations;

  List<Consultation> _recentConsultations = [];
  List<Consultation> get recentConsultations => _recentConsultations;

  Future<void> init() async {
    await runBusyFuture(_loadDashboardData());
  }

  Future<void> _loadDashboardData() async {
    try {
      // Load all required dashboard data
      await Future.wait([
        _loadTotalPatients(),
        _loadTodayAppointments(),
        _loadTodayConsultations(),
        _loadRecentConsultations(),
      ]);
    } catch (e) {
      setError('Failed to load dashboard data. Please try again.');
    }
  }

  Future<void> _loadTotalPatients() async {
    try {
      final count = await _patientRepository.getPatientCount();
      _totalPatients = count;
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading total patients: $e');
    }
  }

  Future<void> _loadTodayAppointments() async {
    try {
      final today = DateTime.now();
      final appointments = await _consultationRepository.getConsultations(
        startDate: DateTime(today.year, today.month, today.day),
        endDate: DateTime(today.year, today.month, today.day, 23, 59, 59),
      );
      _todayAppointments = appointments.length;
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading today\'s appointments: $e');
    }
  }

  Future<void> _loadTodayConsultations() async {
    try {
      final today = DateTime.now();
      final consultations = await _consultationRepository.getConsultations(
        startDate: DateTime(today.year, today.month, today.day),
        endDate: DateTime(today.year, today.month, today.day, 23, 59, 59),
        status: 'completed',
      );
      _todayConsultations = consultations.length;
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading today\'s consultations: $e');
    }
  }

  Future<void> _loadRecentConsultations() async {
    try {
      _recentConsultations = await _consultationRepository.getConsultations(
        limit: 5,
      );
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading recent consultations: $e');
    }
  }

  void setIndex(int index) {
    _currentIndex = index;
    notifyListeners();

    switch (index) {
      case 1:
        _navigationService.navigateTo(Routes.patientListView);
        break;
      case 2:
        _navigationService.navigateTo(Routes.consultationHistoryView);
        break;
      case 3:
        _navigationService.navigateTo(Routes.profileView);
        break;
    }
  }

  void navigateToAddPatient() {
    _navigationService.navigateTo(Routes.patientDetailsView);
  }

  void navigateToNewConsultation() {
    _navigationService.navigateTo(Routes.consultationFormView);
  }

  void navigateToPatientList() {
    _navigationService.navigateTo(Routes.patientListView);
  }

  void navigateToConsultationHistory() {
    _navigationService.navigateTo(Routes.consultationHistoryView);
  }

  void navigateToConsultationDetails(String consultationId) {
    _navigationService.navigateTo(
      Routes.consultationFormView,
      arguments: consultationId,
    );
  }

  void showNotifications() {
    // Implement notifications functionality
  }

  @override
  void dispose() {
    super.dispose();
  }
}
