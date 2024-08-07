class HttpException<T> extends Error {
  final String message;
  final int? statusCode;
  final HttpExceptionType type;
  final T? response;

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
