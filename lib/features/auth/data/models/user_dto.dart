import '../../domain/entities/user_entity.dart';

class UserDTO {
  final String id;
  final String name;
  final String email;
  final DateTime createdAt;

  UserDTO({
    required this.id,
    required this.name,
    required this.email,
    required this.createdAt,
  });

  factory UserDTO.fromJson(Map<String, dynamic> json) {
    return UserDTO(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  UserEntity toEntity() {
    return UserEntity(
      id: id,
      name: name,
      email: email,
      createdAt: createdAt,
    );
  }

  factory UserDTO.fromEntity(UserEntity entity) {
    return UserDTO(
      id: entity.id,
      name: entity.name,
      email: entity.email,
      createdAt: entity.createdAt,
    );
  }
}
