/// Custom exceptions used across the TMDB Signals app.
abstract class AppException implements Exception {
  /// Creates a new application exception.
  const AppException(this.message);

  /// A human-readable error message.
  final String message;

  @override
  String toString() => message;
}

/// Indicates a failure while making or parsing an HTTP request.
class HttpException extends AppException {
  /// Creates a new HTTP exception.
  const HttpException(
    super.message, {
    this.statusCode,
    this.body,
  });

  /// The HTTP status code returned by the server, if available.
  final int? statusCode;

  /// The raw response body returned by the server, if available.
  final String? body;

  @override
  String toString() {
    final status = statusCode != null ? ' ($statusCode)' : '';
    return 'HttpException$status: $message';
  }
}

/// Indicates that the HTTP response was empty when data was expected.
class EmptyResponseException extends AppException {
  /// Creates a new empty response exception.
  const EmptyResponseException([super.message = 'No response body was returned.']);
}

/// Indicates the repository failed to fulfill a data request.
class RepositoryException extends AppException {
  /// Creates a new repository exception.
  const RepositoryException(
    super.message, {
    this.cause,
    this.stackTrace,
  });

  /// The original error that caused this repository failure.
  final Object? cause;

  /// The stack trace from the original error.
  final StackTrace? stackTrace;

  @override
  String toString() {
    final causeMessage = cause != null ? ' Caused by: $cause' : '';
    return 'RepositoryException: $message$causeMessage';
  }
}

/// Indicates a JSON parsing or decoding failure.
class JsonParsingException extends AppException {
  /// Creates a new JSON parsing exception.
  const JsonParsingException([super.message = 'Failed to decode JSON response.']);
}
