import '../../domain/entities/church.dart';

class ChurchModel {
  final String? id;
  final String name;
  final String city;
  final String neighborhood;
  final String street;
  final String state;
  final String number;
  final String ownerId;
  final int membersCount;
  final int likesCount;
  final String createdAt;

  ChurchModel({
    this.id,
    required this.name,
    required this.city,
    required this.neighborhood,
    required this.street,
    required this.state,
    required this.number,
    required this.ownerId,
    this.membersCount = 1,
    this.likesCount = 0,
    String? createdAt,
  }) : createdAt = createdAt ?? DateTime.now().toIso8601String();

  factory ChurchModel.fromJson(Map<String, dynamic> json) {
    return ChurchModel(
      id: json['id'] as String?,
      name: json['name'] as String,
      city: json['city'] as String,
      neighborhood: json['neighborhood'] as String,
      street: json['street'] as String,
      state: json['state'] as String,
      number: json['number'] as String,
      ownerId: json['ownerId'] as String,
      membersCount: json['membersCount'] as int? ?? 1,
      likesCount: json['likesCount'] as int? ?? 0,
      createdAt: json['createdAt'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'name': name,
      'city': city,
      'neighborhood': neighborhood,
      'street': street,
      'state': state,
      'number': number,
      'ownerId': ownerId,
      'membersCount': membersCount,
      'likesCount': likesCount,
      'createdAt': createdAt,
    };
  }

  factory ChurchModel.fromEntity(Church entity) {
    return ChurchModel(
      id: entity.id,
      name: entity.name,
      city: entity.city,
      neighborhood: entity.neighborhood,
      street: entity.street,
      state: entity.state,
      number: entity.number,
      ownerId: entity.ownerId,
      membersCount: entity.membersCount,
      likesCount: entity.likesCount,
      createdAt: entity.createdAt,
    );
  }

  Church toEntity() {
    return Church(
      id: id,
      name: name,
      city: city,
      neighborhood: neighborhood,
      street: street,
      state: state,
      number: number,
      ownerId: ownerId,
      membersCount: membersCount,
      likesCount: likesCount,
      createdAt: createdAt,
    );
  }

  ChurchModel copyWith({
    String? id,
    String? name,
    String? city,
    String? neighborhood,
    String? street,
    String? state,
    String? number,
    String? ownerId,
    int? membersCount,
    int? likesCount,
    String? createdAt,
  }) {
    return ChurchModel(
      id: id ?? this.id,
      name: name ?? this.name,
      city: city ?? this.city,
      neighborhood: neighborhood ?? this.neighborhood,
      street: street ?? this.street,
      state: state ?? this.state,
      number: number ?? this.number,
      ownerId: ownerId ?? this.ownerId,
      membersCount: membersCount ?? this.membersCount,
      likesCount: likesCount ?? this.likesCount,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
