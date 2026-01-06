import 'package:equatable/equatable.dart';

class Animal extends Equatable {
  final String id;
  final String name;
  final String species;
  final String breed;
  final double age;
  final String size;
  final double energyLevel;
  final bool goodWithChildren;
  final bool goodWithPets;
  final String description;
  final String? imageUrl;
  final String status;
  final String shelterId;
  final Map<String, dynamic>? shelter;
  final double? compatibilityScore;
  final String? recommendation;

  const Animal({
    required this.id,
    required this.name,
    required this.species,
    required this.breed,
    required this.age,
    required this.size,
    required this.energyLevel,
    required this.goodWithChildren,
    required this.goodWithPets,
    required this.description,
    this.imageUrl,
    required this.status,
    required this.shelterId,
    this.shelter,
    this.compatibilityScore,
    this.recommendation,
  });

  factory Animal.fromJson(Map<String, dynamic> json) {
    return Animal(
      id: json['_id'] ?? json['id'] ?? '',
      name: json['name'] ?? '',
      species: json['species'] ?? '',
      breed: json['breed'] ?? '',
      age: (json['age'] ?? 0).toDouble(),
      size: json['size'] ?? '',
      energyLevel: (json['energyLevel'] ?? 0).toDouble(),
      goodWithChildren: json['goodWithChildren'] ?? false,
      goodWithPets: json['goodWithPets'] ?? false,
      description: json['description'] ?? '',
      imageUrl: json['imageUrl'],
      status: json['status'] ?? 'available',
      shelterId: json['shelterId'] is Map
          ? json['shelterId']['_id']
          : (json['shelterId'] ?? ''),
      shelter: json['shelterId'] is Map ? json['shelterId'] : null,
      compatibilityScore: json['compatibility_score']?.toDouble(),
      recommendation: json['recommendation'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'species': species,
      'breed': breed,
      'age': age,
      'size': size,
      'energyLevel': energyLevel,
      'goodWithChildren': goodWithChildren,
      'goodWithPets': goodWithPets,
      'description': description,
      'imageUrl': imageUrl,
      'status': status,
      'shelterId': shelterId,
      'shelter': shelter,
    };
  }

  Animal copyWith({
    String? id,
    String? name,
    String? species,
    String? breed,
    double? age,
    String? size,
    double? energyLevel,
    bool? goodWithChildren,
    bool? goodWithPets,
    String? description,
    String? imageUrl,
    String? status,
    String? shelterId,
    Map<String, dynamic>? shelter,
    double? compatibilityScore,
    String? recommendation,
  }) {
    return Animal(
      id: id ?? this.id,
      name: name ?? this.name,
      species: species ?? this.species,
      breed: breed ?? this.breed,
      age: age ?? this.age,
      size: size ?? this.size,
      energyLevel: energyLevel ?? this.energyLevel,
      goodWithChildren: goodWithChildren ?? this.goodWithChildren,
      goodWithPets: goodWithPets ?? this.goodWithPets,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      status: status ?? this.status,
      shelterId: shelterId ?? this.shelterId,
      shelter: shelter ?? this.shelter,
      compatibilityScore: compatibilityScore ?? this.compatibilityScore,
      recommendation: recommendation ?? this.recommendation,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        species,
        breed,
        age,
        size,
        energyLevel,
        goodWithChildren,
        goodWithPets,
        description,
        imageUrl,
        status,
        shelterId,
        shelter,
        compatibilityScore,
        recommendation,
      ];
}
