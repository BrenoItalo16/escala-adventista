import 'dart:convert';
import 'package:dio/dio.dart';
import '../config/spotify_config.dart';

class SpotifyService {
  final Dio _dio;
  String? _accessToken;
  DateTime? _tokenExpiration;
  
  static final SpotifyService _instance = SpotifyService._internal();

  factory SpotifyService() {
    return _instance;
  }

  SpotifyService._internal()
      : _dio = Dio(BaseOptions(
          baseUrl: 'https://api.spotify.com/v1',
          headers: {
            'Accept': 'application/json',
          },
        ));

  Future<void> _getAccessToken() async {
    if (_accessToken != null && _tokenExpiration != null && DateTime.now().isBefore(_tokenExpiration!)) {
      return;
    }

    final authString = base64.encode(
      utf8.encode('${SpotifyConfig.clientId}:${SpotifyConfig.clientSecret}'),
    );

    final response = await Dio().post(
      'https://accounts.spotify.com/api/token',
      data: {'grant_type': 'client_credentials'},
      options: Options(
        headers: {
          'Authorization': 'Basic $authString',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
      ),
    );

    _accessToken = response.data['access_token'];
    _tokenExpiration = DateTime.now().add(
      Duration(seconds: response.data['expires_in']),
    );
    
    _dio.options.headers['Authorization'] = 'Bearer $_accessToken';
  }

  /// Busca músicas por artista e nome da música
  Future<Map<String, dynamic>> searchSong(String artist, String song) async {
    try {
      await _getAccessToken();
      
      final searchQuery = Uri.encodeComponent('$song $artist');
      final response = await _dio.get(
        '/search',
        queryParameters: {
          'q': searchQuery,
          'type': 'track',
          'limit': 10,
        },
      );

      if (response.data == null || 
          response.data['tracks'] == null || 
          response.data['tracks']['items'].isEmpty) {
        return {
          'response': {
            'numFound': 0,
            'docs': [],
          }
        };
      }

      final tracks = response.data['tracks']['items'];
      final formattedResponse = {
        'response': {
          'numFound': tracks.length,
          'docs': tracks.map((track) => {
            'id': track['id'],
            'title': track['name'],
            'band': track['artists'][0]['name'],
            'band_id': track['artists'][0]['id'],
            'band_url': track['artists'][0]['external_urls']['spotify'],
            'url': track['external_urls']['spotify'],
            'cover_url': track['album']['images'][0]['url'],
            'lyrics': null,
          }).toList(),
        }
      };

      return formattedResponse;
    } catch (e) {
      print('Erro na busca do Spotify: $e');
      throw Exception('Erro ao buscar música: $e');
    }
  }

  Exception _handleError(DioException e) {
    if (e.response != null) {
      return Exception(
        'Erro na requisição: ${e.response?.statusCode} - ${e.response?.statusMessage}',
      );
    }
    return Exception('Erro na conexão com a API: ${e.message}');
  }
}
