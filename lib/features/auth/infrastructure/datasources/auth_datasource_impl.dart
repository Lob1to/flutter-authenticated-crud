import 'package:teslo_shop/config/config.dart';
import 'package:teslo_shop/config/plugins/http_request_adapter.dart';
import 'package:teslo_shop/features/auth/infrastructure/errors/http_exception.dart';
import '../../domain/domain.dart';
import '../infrastructure.dart';

class AuthDatasourceImpl implements AuthDatasource {
  final httpRequest = HttpRequestAdapter(
    baseUrl: Environment.apiUrl,
  );

  @override
  Future<User> login(String email, String password) async {
    try {
      final response = await httpRequest.post('/auth/login', data: {
        'email': email,
        'password': password,
      });

      final user = UserMapper.userJsonToEntity(response.data);
      return user;
    } on HttpException catch (e) {
      if (e.type == HttpExceptionType.badRequest) {
        throw CustomError(
            e.response?.data['message'] ?? 'Credenciales incorrectas');
      }

      if (e.type == HttpExceptionType.connectionTimeout) {
        throw CustomError('Revisar conexión a internet');
      }

      throw Exception();
    } catch (e) {
      throw Exception();
    }
  }

  @override
  Future<User> register(String email, String password, String fullName) async {
    try {
      final response = await httpRequest.post('/auth/register', data: {
        'email': email,
        'password': password,
        'fullName': fullName,
      });

      final user = UserMapper.userJsonToEntity(response.data);
      return user;
    } on HttpException catch (e) {
      if (e.response?.statusCode == 401) {
        throw CustomError(e.response?.data['message'] ??
            'Uno o más campos ingresados no son validos');
      }
      if (e.response?.statusCode == 400) {
        throw CustomError(e.response?.data['message'] ??
            'Ha ocurrido un error en el proceso de registro');
      }

      if (e.type == HttpExceptionType.connectionTimeout) {
        throw CustomError('Revisar conexión a internet');
      }

      throw Exception();
    } catch (e) {
      throw Exception();
    }
  }

  @override
  Future<User> checkAuthStatus(String token) async {
    try {
      final response = await httpRequest.get('/auth/check-status', headers: {
        'Authorization': 'Bearer $token',
      });

      final user = UserMapper.userJsonToEntity(response.data);
      return user;
    } on HttpException catch (e) {
      if (e.type == HttpExceptionType.unauthorized) {
        throw CustomError('Token incorrecto');
      }
      if (e.type == HttpExceptionType.connectionTimeout) {
        throw CustomError('Revisar conexión a internet');
      }
      throw Exception();
    } catch (e) {
      throw Exception();
    }
  }
}
