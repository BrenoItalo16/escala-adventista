import 'package:equatable/equatable.dart';

class Church extends Equatable {
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

  Church({
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
  }) : createdAt = createdAt ?? _getCurrentTimestamp();

  static String _getCurrentTimestamp() {
    return DateTime.now().toIso8601String();
  }

  Church copyWith({
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
    return Church(
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

  @override
  List<Object?> get props => [
    id,
    name,
    city,
    neighborhood,
    street,
    state,
    number,
    ownerId,
    membersCount,
    likesCount,
    createdAt,
  ];
}
