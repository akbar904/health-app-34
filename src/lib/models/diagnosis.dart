import 'package:equatable/equatable.dart';

class Diagnosis extends Equatable {
  final String id;
  final String patientId;
  final String doctorId;
  final String condition;
  final String notes;
  final List<String> symptoms;
  final List<String> prescriptions;
  final DateTime diagnosisDate;
  final String severity;
  final String status;
  final DateTime? followUpDate;
  final Map<String, dynamic>? additionalNotes;

  const Diagnosis({
    required this.id,
    required this.patientId,
    required this.doctorId,
    required this.condition,
    required this.notes,
    required this.symptoms,
    required this.prescriptions,
    required this.diagnosisDate,
    required this.severity,
    required this.status,
    this.followUpDate,
    this.additionalNotes,
  });

  factory Diagnosis.fromJson(Map<String, dynamic> json) {
    return Diagnosis(
      id: json['id'] as String,
      patientId: json['patientId'] as String,
      doctorId: json['doctorId'] as String,
      condition: json['condition'] as String,
      notes: json['notes'] as String,
      symptoms: List<String>.from(json['symptoms'] as List),
      prescriptions: List<String>.from(json['prescriptions'] as List),
      diagnosisDate: DateTime.parse(json['diagnosisDate'] as String),
      severity: json['severity'] as String,
      status: json['status'] as String,
      followUpDate: json['followUpDate'] != null
          ? DateTime.parse(json['followUpDate'] as String)
          : null,
      additionalNotes: json['additionalNotes'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'patientId': patientId,
      'doctorId': doctorId,
      'condition': condition,
      'notes': notes,
      'symptoms': symptoms,
      'prescriptions': prescriptions,
      'diagnosisDate': diagnosisDate.toIso8601String(),
      'severity': severity,
      'status': status,
      'followUpDate': followUpDate?.toIso8601String(),
      'additionalNotes': additionalNotes,
    };
  }

  Diagnosis copyWith({
    String? id,
    String? patientId,
    String? doctorId,
    String? condition,
    String? notes,
    List<String>? symptoms,
    List<String>? prescriptions,
    DateTime? diagnosisDate,
    String? severity,
    String? status,
    DateTime? followUpDate,
    Map<String, dynamic>? additionalNotes,
  }) {
    return Diagnosis(
      id: id ?? this.id,
      patientId: patientId ?? this.patientId,
      doctorId: doctorId ?? this.doctorId,
      condition: condition ?? this.condition,
      notes: notes ?? this.notes,
      symptoms: symptoms ?? this.symptoms,
      prescriptions: prescriptions ?? this.prescriptions,
      diagnosisDate: diagnosisDate ?? this.diagnosisDate,
      severity: severity ?? this.severity,
      status: status ?? this.status,
      followUpDate: followUpDate ?? this.followUpDate,
      additionalNotes: additionalNotes ?? this.additionalNotes,
    );
  }

  @override
  List<Object?> get props => [
        id,
        patientId,
        doctorId,
        condition,
        notes,
        symptoms,
        prescriptions,
        diagnosisDate,
        severity,
        status,
        followUpDate,
        additionalNotes,
      ];
}
