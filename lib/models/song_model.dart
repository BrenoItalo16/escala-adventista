class Song {
  final String id;
  final String name;
  final String url;
  final String? lyrics;
  final String coverUrl;
  final Artist artist;

  Song({
    required this.id,
    required this.name,
    required this.url,
    this.lyrics,
    required this.coverUrl,
    required this.artist,
  });

  factory Song.fromJson(Map<String, dynamic> json) {
    return Song(
      id: json['id']?.toString() ?? '',
      name: json['title']?.toString() ?? '',
      url: json['url']?.toString() ?? '',
      lyrics: json['lyrics']?.toString(),
      coverUrl: json['cover_url']?.toString() ?? '',
      artist: Artist(
        id: json['band_id']?.toString() ?? '',
        name: json['band']?.toString() ?? '',
        url: json['band_url']?.toString() ?? '',
      ),
    );
  }
}

class Artist {
  final String id;
  final String name;
  final String url;

  Artist({
    required this.id,
    required this.name,
    required this.url,
  });

  factory Artist.fromJson(Map<String, dynamic> json) {
    return Artist(
      id: json['band_id']?.toString() ?? '',
      name: json['band']?.toString() ?? '',
      url: json['band_url']?.toString() ?? '',
    );
  }
}
