import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:rhttp/rhttp.dart';
import 'package:tmdb_signals/config/api_exceptions.dart';
import 'package:tmdb_signals/config/app_config.dart';

/// Decodes JSON in a separate isolate.
Map<String, dynamic> _decodeJson(String body) => jsonDecode(body) as Map<String, dynamic>;

/// The HTTP service.
class HttpService {
  /// Creates the HTTP service.
  HttpService() : _token = dotenv.env['READ_ACCESS_TOKEN'] ?? '';

  final String _token;

  /// Gets the JSON data from the specified endpoint.
  Future<Map<String, dynamic>> getJsonAsync(String endpoint) async {
    try {
      final response = await Rhttp.get(
        '${AppConfig.baseUrl}$endpoint',
        headers: HttpHeaders.map({
          HttpHeaderName.authorization: 'Bearer $_token',
          HttpHeaderName.accept: AppConfig.jsonContentType,
        }),
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        if (response.body.isNotEmpty) {
          return await compute(_decodeJson, response.body);
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
