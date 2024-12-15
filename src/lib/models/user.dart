import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String role;
  final String specialization;
  final String licenseNumber;
  final String phoneNumber;
  final String profileImageUrl;
  final bool isEmailVerified;
  final DateTime registrationDate;
  final DateTime? lastLoginDate;
  final Map<String, dynamic>? preferences;

  const User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.role,
    required this.specialization,
    required this.licenseNumber,
    required this.phoneNumber,
    required this.profileImageUrl,
    required this.isEmailVerified,
    required this.registrationDate,
    this.lastLoginDate,
    this.preferences,
  });

  String get fullName => '$firstName $lastName';

  bool get isDoctor => role == 'doctor';
  bool get isAdmin => role == 'admin';
  bool get isStaff => role == 'staff';

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      email: json['email'] as String,
      role: json['role'] as String,
      specialization: json['specialization'] as String,
      licenseNumber: json['licenseNumber'] as String,
      phoneNumber: json['phoneNumber'] as String,
      profileImageUrl: json['profileImageUrl'] as String,
      isEmailVerified: json['isEmailVerified'] as bool,
      registrationDate: DateTime.parse(json['registrationDate'] as String),
      lastLoginDate: json['lastLoginDate'] != null
          ? DateTime.parse(json['lastLoginDate'] as String)
          : null,
      preferences: json['preferences'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'role': role,
      'specialization': specialization,
      'licenseNumber': licenseNumber,
      'phoneNumber': phoneNumber,
      'profileImageUrl': profileImageUrl,
      'isEmailVerified': isEmailVerified,
      'registrationDate': registrationDate.toIso8601String(),
      'lastLoginDate': lastLoginDate?.toIso8601String(),
      'preferences': preferences,
    };
  }

  User copyWith({
    String? id,
    String? firstName,
    String? lastName,
    String? email,
    String? role,
    String? specialization,
    String? licenseNumber,
    String? phoneNumber,
    String? profileImageUrl,
    bool? isEmailVerified,
    DateTime? registrationDate,
    DateTime? lastLoginDate,
    Map<String, dynamic>? preferences,
  }) {
    return User(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      role: role ?? this.role,
      specialization: specialization ?? this.specialization,
      licenseNumber: licenseNumber ?? this.licenseNumber,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      isEmailVerified: isEmailVerified ?? this.isEmailVerified,
      registrationDate: registrationDate ?? this.registrationDate,
      lastLoginDate: lastLoginDate ?? this.lastLoginDate,
      preferences: preferences ?? this.preferences,
    );
  }

  @override
  List<Object?> get props => [
        id,
        firstName,
        lastName,
        email,
        role,
        specialization,
        licenseNumber,
        phoneNumber,
        profileImageUrl,
        isEmailVerified,
        registrationDate,
        lastLoginDate,
        preferences,
      ];
}
