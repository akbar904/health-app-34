import 'package:equatable/equatable.dart';

class Consultation extends Equatable {
  final String id;
  final String patientId;
  final String doctorId;
  final DateTime consultationDate;
  final String chiefComplaint;
  final String diagnosis;
  final List<String> symptoms;
  final List<String> prescriptions;
  final String notes;
  final String status;
  final DateTime? followUpDate;
  final List<String>? attachments;
  final Map<String, dynamic>? vitals;
  final Map<String, dynamic>? labResults;

  const Consultation({
    required this.id,
    required this.patientId,
    required this.doctorId,
    required this.consultationDate,
    required this.chiefComplaint,
    required this.diagnosis,
    required this.symptoms,
    required this.prescriptions,
    required this.notes,
    required this.status,
    this.followUpDate,
    this.attachments,
    this.vitals,
    this.labResults,
  });

  factory Consultation.fromJson(Map<String, dynamic> json) {
    return Consultation(
      id: json['id'] as String,
      patientId: json['patientId'] as String,
      doctorId: json['doctorId'] as String,
      consultationDate: DateTime.parse(json['consultationDate'] as String),
      chiefComplaint: json['chiefComplaint'] as String,
      diagnosis: json['diagnosis'] as String,
      symptoms: List<String>.from(json['symptoms'] as List),
      prescriptions: List<String>.from(json['prescriptions'] as List),
      notes: json['notes'] as String,
      status: json['status'] as String,
      followUpDate: json['followUpDate'] != null
          ? DateTime.parse(json['followUpDate'] as String)
          : null,
      attachments: json['attachments'] != null
          ? List<String>.from(json['attachments'] as List)
          : null,
      vitals: json['vitals'] as Map<String, dynamic>?,
      labResults: json['labResults'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'patientId': patientId,
      'doctorId': doctorId,
      'consultationDate': consultationDate.toIso8601String(),
      'chiefComplaint': chiefComplaint,
      'diagnosis': diagnosis,
      'symptoms': symptoms,
      'prescriptions': prescriptions,
      'notes': notes,
      'status': status,
      'followUpDate': followUpDate?.toIso8601String(),
      'attachments': attachments,
      'vitals': vitals,
      'labResults': labResults,
    };
  }

  Consultation copyWith({
    String? id,
    String? patientId,
    String? doctorId,
    DateTime? consultationDate,
    String? chiefComplaint,
    String? diagnosis,
    List<String>? symptoms,
    List<String>? prescriptions,
    String? notes,
    String? status,
    DateTime? followUpDate,
    List<String>? attachments,
    Map<String, dynamic>? vitals,
    Map<String, dynamic>? labResults,
  }) {
    return Consultation(
      id: id ?? this.id,
      patientId: patientId ?? this.patientId,
      doctorId: doctorId ?? this.doctorId,
      consultationDate: consultationDate ?? this.consultationDate,
      chiefComplaint: chiefComplaint ?? this.chiefComplaint,
      diagnosis: diagnosis ?? this.diagnosis,
      symptoms: symptoms ?? this.symptoms,
      prescriptions: prescriptions ?? this.prescriptions,
      notes: notes ?? this.notes,
      status: status ?? this.status,
      followUpDate: followUpDate ?? this.followUpDate,
      attachments: attachments ?? this.attachments,
      vitals: vitals ?? this.vitals,
      labResults: labResults ?? this.labResults,
    );
  }

  @override
  List<Object?> get props => [
        id,
        patientId,
        doctorId,
        consultationDate,
        chiefComplaint,
        diagnosis,
        symptoms,
        prescriptions,
        notes,
        status,
        followUpDate,
        attachments,
        vitals,
        labResults,
      ];
}
