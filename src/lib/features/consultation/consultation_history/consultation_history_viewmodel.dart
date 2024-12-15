import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:my_app/app/app.locator.dart';
import 'package:my_app/app/app.router.dart';
import 'package:my_app/models/consultation.dart';
import 'package:my_app/repositories/consultation_repository.dart';

class ConsultationHistoryViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();
  final _bottomSheetService = locator<BottomSheetService>();
  final _consultationRepository = locator<ConsultationRepository>();

  List<Consultation> _consultations = [];
  List<Consultation> get consultations => _consultations;

  String _searchQuery = '';
  String _sortBy = 'date';
  String _filterStatus = 'all';
  DateTime? _startDate;
  DateTime? _endDate;

  Future<void> init() async {
    await loadConsultations();
  }

  Future<void> loadConsultations() async {
    try {
      setBusy(true);
      final consultations = await _consultationRepository.getConsultations(
        startDate: _startDate,
        endDate: _endDate,
        status: _filterStatus == 'all' ? null : _filterStatus,
      );
      _consultations = _filterAndSortConsultations(consultations);
      notifyListeners();
    } catch (e) {
      setError('Failed to load consultations. Please try again.');
    } finally {
      setBusy(false);
    }
  }

  List<Consultation> _filterAndSortConsultations(
      List<Consultation> consultations) {
    var filtered = consultations;

    // Apply search filter
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((consultation) {
        return consultation.diagnosis
                .toLowerCase()
                .contains(_searchQuery.toLowerCase()) ||
            consultation.chiefComplaint
                .toLowerCase()
                .contains(_searchQuery.toLowerCase());
      }).toList();
    }

    // Apply sorting
    filtered.sort((a, b) {
      switch (_sortBy) {
        case 'date':
          return b.consultationDate.compareTo(a.consultationDate);
        case 'status':
          return a.status.compareTo(b.status);
        default:
          return 0;
      }
    });

    return filtered;
  }

  void onSearchChanged(String query) {
    _searchQuery = query;
    _consultations = _filterAndSortConsultations(_consultations);
    notifyListeners();
  }

  Future<void> showSortOptions() async {
    final response = await _bottomSheetService.showCustomSheet(
      variant: BottomSheetType.sortSheet,
      title: 'Sort By',
      data: _sortBy,
    );

    if (response?.confirmed ?? false) {
      _sortBy = response?.data as String;
      _consultations = _filterAndSortConsultations(_consultations);
      notifyListeners();
    }
  }

  Future<void> showFilterOptions() async {
    final response = await _bottomSheetService.showCustomSheet(
      variant: BottomSheetType.filterSheet,
      title: 'Filter Consultations',
      data: {
        'status': _filterStatus,
        'startDate': _startDate,
        'endDate': _endDate,
      },
    );

    if (response?.confirmed ?? false) {
      final data = response?.data as Map<String, dynamic>;
      _filterStatus = data['status'] as String;
      _startDate = data['startDate'] as DateTime?;
      _endDate = data['endDate'] as DateTime?;
      await loadConsultations();
    }
  }

  void navigateToConsultationDetails(String consultationId) {
    _navigationService.navigateTo(
      Routes.consultationFormView,
      arguments: consultationId,
    );
  }

  void navigateToNewConsultation() {
    _navigationService.navigateTo(Routes.consultationFormView);
  }

  Future<void> refreshConsultations() async {
    await loadConsultations();
  }

  Future<void> deleteConsultation(String consultationId) async {
    try {
      setBusy(true);
      await _consultationRepository.deleteConsultation(consultationId);
      await loadConsultations();
    } catch (e) {
      setError('Failed to delete consultation. Please try again.');
    } finally {
      setBusy(false);
    }
  }

  void clearFilters() {
    _searchQuery = '';
    _sortBy = 'date';
    _filterStatus = 'all';
    _startDate = null;
    _endDate = null;
    loadConsultations();
  }
}
