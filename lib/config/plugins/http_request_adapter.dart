import 'package:dio/dio.dart';

import '../../features/auth/infrastructure/errors/http_exception.dart';

class HttpRequestAdapter {
  final String baseUrl;
  HttpRequestAdapter({required this.baseUrl});

  Dio get httpRequest => Dio(BaseOptions(baseUrl: baseUrl));

  get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) =>
      _handleRequest(() => httpRequest.get(
            path,
            queryParameters: queryParameters,
            options: Options(
              headers: headers,
            ),
          ));

  post(
    String path, {
    Map<String, dynamic>? data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) =>
      _handleRequest(() => httpRequest.post(
            path,
            queryParameters: queryParameters,
            data: data,
            options: Options(
              headers: headers,
            ),
          ));

  put(
    String path, {
    Map<String, dynamic>? data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) =>
      _handleRequest(() => httpRequest.put(path,
          queryParameters: queryParameters,
          data: data,
          options: Options(
            headers: headers,
          )));

  delete(
    String path, {
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) =>
      _handleRequest(() => httpRequest.delete(
            path,
            queryParameters: queryParameters,
            options: Options(
              headers: headers,
            ),
          ));

  Future<Response> _handleRequest(
      Future<Response<dynamic>> Function() request) async {
    try {
      return await request();
    } on DioException catch (e) {
      throw _mapDioExceptionToHttpException(e);
    } catch (e) {
      throw HttpException(
        message: 'An unexpected error occurred',
        type: HttpExceptionType.unknown,
      );
    }
  }

  HttpException _mapDioExceptionToHttpException(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
        return HttpException(
          message: 'Connection timeout',
          type: HttpExceptionType.connectionTimeout,
        );
      case DioExceptionType.badResponse:
        return HttpException(
            message: e.response?.statusMessage ?? 'Bad response',
            statusCode: e.response?.statusCode,
            type: _getHttpExceptionTypeFromStatusCode(e.response?.statusCode),
            response: e.response as Response);
      default:
        return HttpException(
          message: 'An unexpected error occurred',
          type: HttpExceptionType.unknown,
        );
    }
  }

  HttpExceptionType _getHttpExceptionTypeFromStatusCode(int? statusCode) {
    switch (statusCode) {
      case 400:
        return HttpExceptionType.badRequest;
      case 401:
        return HttpExceptionType.unauthorized;
      case 404:
        return HttpExceptionType.notFound;
      case 500:
        return HttpExceptionType.serverError;
      default:
        return HttpExceptionType.unknown;
    }
  }
}
