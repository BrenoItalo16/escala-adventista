import 'package:dio/dio.dart';
import '../config/api_config.dart';

class VagalumeService {
  final Dio _dio;
  static final VagalumeService _instance = VagalumeService._internal();

  factory VagalumeService() {
    return _instance;
  }

  VagalumeService._internal()
      : _dio = Dio(BaseOptions(
          baseUrl: 'https://api.vagalume.com.br',
          headers: {
            'Accept': 'application/json',
          },
        ));

  /// Busca músicas por artista e nome da música
  Future<Map<String, dynamic>> searchSong(String artist, String song) async {
    try {
      print('Buscando música: $song por $artist'); // Log para debug
      
      // Limpa e formata os termos de busca
      final searchTerm = Uri.encodeComponent('$artist $song'.trim());
      
      final response = await _dio.get(
        '/search.art',
        queryParameters: {
          'apikey': ApiConfig.vagalumeApiKey,
          'q': searchTerm,
        },
      );
      
      print('URL da requisição: ${response.requestOptions.uri}'); // Log para debug
      print('Resposta da API: ${response.data}'); // Log para debug
      
      if (response.data == null) {
        throw Exception('Resposta vazia da API');
      }

      // Processa a resposta para o formato esperado
      final responseData = response.data;
      if (responseData['type'] == 'notfound') {
        return {
          'type': 'song_notfound',
          'message': 'Nenhuma música encontrada'
        };
      }

      final List<dynamic> docs = [];
      if (responseData['response']?['docs'] != null) {
        for (var doc in responseData['response']['docs']) {
          docs.add({
            'id': doc['id'] ?? '',
            'title': doc['title'] ?? '',
            'band': doc['band'] ?? '',
            'url': doc['url'] ?? '',
            'band_id': doc['band_id'] ?? '',
            'band_url': doc['band_url'] ?? ''
          });
        }
      }

      return {
        'type': 'success',
        'response': {
          'docs': docs,
          'numFound': docs.length,
        }
      };

    } on DioException catch (e) {
      print('Erro na busca: $e'); // Log para debug
      if (e.response != null) {
        print('Dados do erro: ${e.response?.data}'); // Log para debug
      }
      throw _handleError(e);
    } catch (e) {
      print('Erro inesperado: $e'); // Log para debug
      throw Exception('Erro inesperado ao buscar música: $e');
    }
  }

  /// Busca artista por nome
  Future<Map<String, dynamic>> searchArtist(String artistName) async {
    try {
      final searchTerm = Uri.encodeComponent(artistName.trim());
      final response = await _dio.get(
        '/search.artmus',
        queryParameters: {
          'q': searchTerm,
          'limit': '10',
          'apikey': ApiConfig.vagalumeApiKey,
        },
      );
      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Busca as músicas mais populares do momento
  Future<Map<String, dynamic>> getHotSongs() async {
    try {
      final response = await _dio.get(
        '/rank.php',
        queryParameters: {
          'apikey': ApiConfig.vagalumeApiKey,
          'type': 'mus',
          'period': 'day',
          'scope': 'all',
          'limit': '10',
        },
      );
      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Exception _handleError(DioException e) {
    if (e.response != null) {
      return Exception(
          'Erro na requisição: ${e.response?.statusCode} - ${e.response?.statusMessage}');
    }
    return Exception('Erro na conexão com a API: ${e.message}');
  }
}
