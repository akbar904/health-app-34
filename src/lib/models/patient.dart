import 'package:equatable/equatable.dart';

class Patient extends Equatable {
  final String id;
  final String firstName;
  final String lastName;
  final DateTime dateOfBirth;
  final String gender;
  final String phoneNumber;
  final String email;
  final String address;
  final String bloodGroup;
  final double height;
  final double weight;
  final List<String> allergies;
  final List<String> chronicConditions;
  final String emergencyContact;
  final String emergencyContactPhone;
  final DateTime registrationDate;
  final Map<String, dynamic>? medicalHistory;

  const Patient({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.dateOfBirth,
    required this.gender,
    required this.phoneNumber,
    required this.email,
    required this.address,
    required this.bloodGroup,
    required this.height,
    required this.weight,
    required this.allergies,
    required this.chronicConditions,
    required this.emergencyContact,
    required this.emergencyContactPhone,
    required this.registrationDate,
    this.medicalHistory,
  });

  String get fullName => '$firstName $lastName';

  int get age {
    final today = DateTime.now();
    int age = today.year - dateOfBirth.year;
    if (today.month < dateOfBirth.month ||
        (today.month == dateOfBirth.month && today.day < dateOfBirth.day)) {
      age--;
    }
    return age;
  }

  factory Patient.fromJson(Map<String, dynamic> json) {
    return Patient(
      id: json['id'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      dateOfBirth: DateTime.parse(json['dateOfBirth'] as String),
      gender: json['gender'] as String,
      phoneNumber: json['phoneNumber'] as String,
      email: json['email'] as String,
      address: json['address'] as String,
      bloodGroup: json['bloodGroup'] as String,
      height: (json['height'] as num).toDouble(),
      weight: (json['weight'] as num).toDouble(),
      allergies: List<String>.from(json['allergies'] as List),
      chronicConditions: List<String>.from(json['chronicConditions'] as List),
      emergencyContact: json['emergencyContact'] as String,
      emergencyContactPhone: json['emergencyContactPhone'] as String,
      registrationDate: DateTime.parse(json['registrationDate'] as String),
      medicalHistory: json['medicalHistory'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'dateOfBirth': dateOfBirth.toIso8601String(),
      'gender': gender,
      'phoneNumber': phoneNumber,
      'email': email,
      'address': address,
      'bloodGroup': bloodGroup,
      'height': height,
      'weight': weight,
      'allergies': allergies,
      'chronicConditions': chronicConditions,
      'emergencyContact': emergencyContact,
      'emergencyContactPhone': emergencyContactPhone,
      'registrationDate': registrationDate.toIso8601String(),
      'medicalHistory': medicalHistory,
    };
  }

  Patient copyWith({
    String? id,
    String? firstName,
    String? lastName,
    DateTime? dateOfBirth,
    String? gender,
    String? phoneNumber,
    String? email,
    String? address,
    String? bloodGroup,
    double? height,
    double? weight,
    List<String>? allergies,
    List<String>? chronicConditions,
    String? emergencyContact,
    String? emergencyContactPhone,
    DateTime? registrationDate,
    Map<String, dynamic>? medicalHistory,
  }) {
    return Patient(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      gender: gender ?? this.gender,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      email: email ?? this.email,
      address: address ?? this.address,
      bloodGroup: bloodGroup ?? this.bloodGroup,
      height: height ?? this.height,
      weight: weight ?? this.weight,
      allergies: allergies ?? this.allergies,
      chronicConditions: chronicConditions ?? this.chronicConditions,
      emergencyContact: emergencyContact ?? this.emergencyContact,
      emergencyContactPhone:
          emergencyContactPhone ?? this.emergencyContactPhone,
      registrationDate: registrationDate ?? this.registrationDate,
      medicalHistory: medicalHistory ?? this.medicalHistory,
    );
  }

  @override
  List<Object?> get props => [
        id,
        firstName,
        lastName,
        dateOfBirth,
        gender,
        phoneNumber,
        email,
        address,
        bloodGroup,
        height,
        weight,
        allergies,
        chronicConditions,
        emergencyContact,
        emergencyContactPhone,
        registrationDate,
        medicalHistory,
      ];
}
