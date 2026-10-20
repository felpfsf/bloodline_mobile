import 'package:bloodline_mobile/app/features/identity/data/datasources/login_remote_datasource.dart';
import 'package:bloodline_mobile/app/features/identity/domain/repository/login_repository.dart';
import 'package:bloodline_mobile/app/features/identity/domain/repository/login_repository_impl.dart';
import 'package:bloodline_mobile/core/networking/api_failure.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('LoginRepositoryImpl', () {
    test('should return LoginSucceeded when login is successful', () async {
      // Arrange
      final Dio dio = Dio(
        BaseOptions(
          baseUrl: 'https://api.example.com',
        ),
      );

      addTearDown(dio.close);

      dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            handler.resolve(
              Response<Map<String, dynamic>>(
                requestOptions: options,
                statusCode: 200,
                data: {
                  'accessToken': 'fake_jwt_token',
                  'expiresAtUtc': '2026-10-19T22:30:00Z',
                },
              ),
            );
          },
        ),
      );

      final ILoginRepository repository = LoginRepositoryImpl(
        LoginRemoteDatasource(dio: dio),
      );
      // Act

      final result = await repository.login(
        email: 'test@example.com',
        password: 'password123',
      );

      // Assert

      expect(result, isA<LoginSucceeded>());

      final session = (result as LoginSucceeded).session;

      expect(session.accessToken, 'fake_jwt_token');
      expect(session.expiresAtUtc, DateTime.parse('2026-10-19T22:30:00Z'));
    });

    test('should return LoginFailed when login fails', () async {
      // Arrange
      final Dio dio = Dio(
        BaseOptions(
          baseUrl: 'https://api.example.com',
        ),
      );

      addTearDown(dio.close);

      dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            handler.reject(
              DioException(
                requestOptions: options,
                type: DioExceptionType.badResponse,
                response: Response(
                  requestOptions: options,
                  statusCode: 401,
                ),
              ),
            );
          },
        ),
      );

      final repository = LoginRepositoryImpl(
        LoginRemoteDatasource(dio: dio),
      );
      // Act

      final result = await repository.login(
        email: 'test@example.com',
        password: 'password123',
      );

      // Assert

      expect(result, isA<LoginFailed>());

      final failure = (result as LoginFailed).failure;

      expect(failure.type, ApiFailureType.unauthorized);
      expect(failure.statusCode, 401);
    });
  });
}
