import 'package:my_app/app/app.locator.dart';
import 'package:my_app/models/consultation.dart';
import 'package:my_app/services/api_service.dart';

class ConsultationRepository {
  final _apiService = locator<ApiService>();

  Future<List<Consultation>> getConsultations({
    String? patientId,
    DateTime? startDate,
    DateTime? endDate,
    String? status,
  }) async {
    try {
      final queryParams = {
        if (patientId != null) 'patientId': patientId,
        if (startDate != null) 'startDate': startDate.toIso8601String(),
        if (endDate != null) 'endDate': endDate.toIso8601String(),
        if (status != null) 'status': status,
      };

      final response = await _apiService.get(
        '/consultations',
        // Add query params implementation when needed
      );

      return (response as List)
          .map((item) => Consultation.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw 'Failed to load consultations. Please try again.';
    }
  }

  Future<Consultation> getConsultationById(String id) async {
    try {
      final response = await _apiService.get('/consultations/$id');
      return Consultation.fromJson(response as Map<String, dynamic>);
    } catch (e) {
      throw 'Failed to load consultation details. Please try again.';
    }
  }

  Future<Consultation> createConsultation(Consultation consultation) async {
    try {
      final response = await _apiService.post(
        '/consultations',
        body: consultation.toJson(),
      );
      return Consultation.fromJson(response as Map<String, dynamic>);
    } catch (e) {
      throw 'Failed to create consultation. Please verify your input and try again.';
    }
  }

  Future<Consultation> updateConsultation(
    String id,
    Map<String, dynamic> updates,
  ) async {
    try {
      final response = await _apiService.put(
        '/consultations/$id',
        body: updates,
      );
      return Consultation.fromJson(response as Map<String, dynamic>);
    } catch (e) {
      throw 'Failed to update consultation. Please try again.';
    }
  }

  Future<void> deleteConsultation(String id) async {
    try {
      await _apiService.delete('/consultations/$id');
    } catch (e) {
      throw 'Failed to delete consultation. Please try again.';
    }
  }

  Future<List<Consultation>> searchConsultations(String query) async {
    try {
      final response = await _apiService.get('/consultations/search?q=$query');
      return (response as List)
          .map((item) => Consultation.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw 'Failed to search consultations. Please try again.';
    }
  }
}
