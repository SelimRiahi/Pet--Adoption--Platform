import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String email;
  final String name;
  final String role;
  final String? housingType;
  final double? availableTime;
  final String? experience;
  final bool hasChildren;
  final bool hasOtherPets;
  final String? phoneNumber;
  final String? address;

  const User({
    required this.id,
    required this.email,
    required this.name,
    required this.role,
    this.housingType,
    this.availableTime,
    this.experience,
    this.hasChildren = false,
    this.hasOtherPets = false,
    this.phoneNumber,
    this.address,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: (json['_id'] ?? json['id'] ?? '').toString(),
      email: json['email'] ?? '',
      name: json['name'] ?? 'Unknown',
      role: json['role'] ?? 'user',
      housingType: json['housingType'],
      availableTime: json['availableTime']?.toDouble(),
      experience: json['experience'],
      hasChildren: json['hasChildren'] ?? false,
      hasOtherPets: json['hasOtherPets'] ?? false,
      phoneNumber: json['phoneNumber'],
      address: json['address'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'role': role,
      'housingType': housingType,
      'availableTime': availableTime,
      'experience': experience,
      'hasChildren': hasChildren,
      'hasOtherPets': hasOtherPets,
      'phoneNumber': phoneNumber,
      'address': address,
    };
  }

  User copyWith({
    String? id,
    String? email,
    String? name,
    String? role,
    String? housingType,
    double? availableTime,
    String? experience,
    bool? hasChildren,
    bool? hasOtherPets,
    String? phoneNumber,
    String? address,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      role: role ?? this.role,
      housingType: housingType ?? this.housingType,
      availableTime: availableTime ?? this.availableTime,
      experience: experience ?? this.experience,
      hasChildren: hasChildren ?? this.hasChildren,
      hasOtherPets: hasOtherPets ?? this.hasOtherPets,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      address: address ?? this.address,
    );
  }

  @override
  List<Object?> get props => [
        id,
        email,
        name,
        role,
        housingType,
        availableTime,
        experience,
        hasChildren,
        hasOtherPets,
        phoneNumber,
        address,
      ];
}
