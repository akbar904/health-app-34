import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:my_app/app/app.locator.dart';
import 'package:my_app/app/app.router.dart';
import 'package:my_app/models/patient.dart';
import 'package:my_app/repositories/patient_repository.dart';

class PatientListViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();
  final _bottomSheetService = locator<BottomSheetService>();
  final _patientRepository = locator<PatientRepository>();

  final searchController = TextEditingController();

  List<Patient> _patients = [];
  List<Patient> get patients => _filteredPatients;

  String _sortBy = 'name';
  String _filterBy = 'all';
  List<Patient> get _filteredPatients {
    List<Patient> filtered = List.from(_patients);

    // Apply search filter
    if (searchController.text.isNotEmpty) {
      filtered = filtered.where((patient) {
        final searchTerm = searchController.text.toLowerCase();
        return patient.fullName.toLowerCase().contains(searchTerm) ||
            patient.phoneNumber.contains(searchTerm);
      }).toList();
    }

    // Apply status filter
    if (_filterBy != 'all') {
      filtered = filtered.where((patient) {
        // Implement filter logic based on your requirements
        return true;
      }).toList();
    }

    // Apply sorting
    filtered.sort((a, b) {
      switch (_sortBy) {
        case 'name':
          return a.fullName.compareTo(b.fullName);
        case 'date':
          return b.registrationDate.compareTo(a.registrationDate);
        default:
          return 0;
      }
    });

    return filtered;
  }

  Future<void> init() async {
    await loadPatients();
  }

  Future<void> loadPatients() async {
    try {
      setBusy(true);
      _patients = await _patientRepository.getPatients();
      notifyListeners();
    } catch (e) {
      setError('Failed to load patients. Please try again.');
    } finally {
      setBusy(false);
    }
  }

  void onSearchChanged(String value) {
    notifyListeners();
  }

  Future<void> showSortOptions() async {
    final response = await _bottomSheetService.showCustomSheet(
      variant: BottomSheetType.sortSheet,
      title: 'Sort Patients',
      data: _sortBy,
    );

    if (response?.confirmed ?? false) {
      _sortBy = response?.data as String;
      notifyListeners();
    }
  }

  Future<void> showFilterOptions() async {
    final response = await _bottomSheetService.showCustomSheet(
      variant: BottomSheetType.filterSheet,
      title: 'Filter Patients',
      data: {'filterBy': _filterBy},
    );

    if (response?.confirmed ?? false) {
      final data = response?.data as Map<String, dynamic>;
      _filterBy = data['filterBy'] as String;
      notifyListeners();
    }
  }

  void navigateToPatientDetails([String? patientId]) {
    _navigationService.navigateTo(
      Routes.patientDetailsView,
      arguments: patientId,
    );
  }

  void navigateToAddPatient() {
    navigateToPatientDetails();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
}
