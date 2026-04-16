import 'dart:convert';

import 'package:tmdb_signals/exceptions/api_exceptions.dart';
import 'package:tmdb_signals/models/movie.dart';
import 'package:tmdb_signals/services/http_service.dart';

/// The TMDB repository.
class TmdbRepository {
  /// Creates the TMDB repository.
  TmdbRepository({HttpService? httpService}) : _httpService = httpService ?? HttpService();

  final HttpService _httpService;

  Future<List<Movie>> _getMovies(String path) async {
    try {
      final response = await _httpService.getAsync(path);
      final dynamic jsonResponse = jsonDecode(response);

      if (jsonResponse['results'] != null) {
        final results = jsonResponse['results'] as List<dynamic>;
        return results.map((json) => Movie.fromJson(json as Map<String, dynamic>)).toList();
      }

      return [];
    } on EmptyResponseException catch (_, _) {
      // If it returned nothing we will just return no movies
      // and the caller can decide how to handle it
      return [];
    } on AppException catch (error, stackTrace) {
      throw RepositoryException(
        'Failed to load movies from TMDB.',
        cause: error,
        stackTrace: stackTrace,
      );
    } on FormatException catch (error, stackTrace) {
      throw RepositoryException(
        'Failed to decode TMDB response.',
        cause: error,
        stackTrace: stackTrace,
      );
    } catch (error, stackTrace) {
      throw RepositoryException(
        'Unexpected error while fetching movies.',
        cause: error,
        stackTrace: stackTrace,
      );
    }
  }

  /// Gets the trending movies.
  Future<List<Movie>> getTrendingMovies() => _getMovies('/trending/movie/day?language=en-US');

  /// Gets the now playing movies.
  Future<List<Movie>> getNowPlayingMovies() => _getMovies('/movie/now_playing?language=en-US&page=1');

  /// Gets the popular movies.
  Future<List<Movie>> getPopularMovies() => _getMovies('/movie/popular?language=en-US&page=1');

  /// Gets the top rated movies.
  Future<List<Movie>> getTopRatedMovies() => _getMovies('/movie/top_rated?language=en-US&page=1');

  /// Gets the upcoming movies.
  Future<List<Movie>> getUpcomingMovies() => _getMovies('/movie/upcoming?language=en-US&page=1');
}
