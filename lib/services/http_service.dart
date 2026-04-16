import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:rhttp/rhttp.dart';
import 'package:tmdb_signals/exceptions/api_exceptions.dart';

/// The HTTP service.
class HttpService {
  /// Creates the HTTP service.
  HttpService() : _token = dotenv.env['READ_ACCESS_TOKEN'] ?? '';

  static const String _baseUrl = 'https://api.themoviedb.org/3';
  final String _token;

  /// Gets the data from the specified endpoint.
  Future<String> getAsync(String endpoint) async {
    try {
      final response = await Rhttp.get(
        '$_baseUrl$endpoint',
        headers: HttpHeaders.map({
          HttpHeaderName.authorization: 'Bearer $_token',
          HttpHeaderName.accept: 'application/json',
        }),
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        if (response.body.isNotEmpty) {
          return response.body;
        }

        throw const EmptyResponseException();
      }

      throw HttpException(
        'Failed to load data from $endpoint.',
        statusCode: response.statusCode,
        body: response.body,
      );
    } on AppException {
      rethrow;
    } catch (error) {
      throw HttpException(
        'Network request failed for $endpoint: $error',
      );
    }
  }
}
