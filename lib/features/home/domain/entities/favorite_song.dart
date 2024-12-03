import 'package:equatable/equatable.dart';

class FavoriteSong extends Equatable {
  final String id;
  final String name;
  final String artist;
  final String url;
  final String userId;
  final String coverUrl;
  final DateTime createdAt;

  const FavoriteSong({
    required this.id,
    required this.name,
    required this.artist,
    required this.url,
    required this.userId,
    required this.coverUrl,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id, name, artist, url, userId, coverUrl, createdAt];

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'artist': artist,
      'url': url,
      'userId': userId,
      'coverUrl': coverUrl,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory FavoriteSong.fromJson(Map<String, dynamic> json) {
    return FavoriteSong(
      id: json['id'] as String,
      name: json['name'] as String,
      artist: json['artist'] as String,
      url: json['url'] as String,
      userId: json['userId'] as String,
      coverUrl: json['coverUrl'] as String? ?? '',
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }
}
