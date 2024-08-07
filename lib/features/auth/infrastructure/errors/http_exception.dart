class HttpException extends Error {
  final String message;
  final int? statusCode;
  final HttpExceptionType type;
  final dynamic response;

  HttpException({
    required this.message,
    this.statusCode,
    required this.type,
    this.response,
  });
}

enum HttpExceptionType {
  connectionTimeout,
  badRequest,
  unauthorized,
  notFound,
  serverError,
  unknown,
}
