import 'package:bloodline_mobile/app/features/identity/data/datasources/login_remote_datasource.dart';
import 'package:bloodline_mobile/app/features/identity/data/dto/login_request_dto.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('LoginRemoteDatasource Tests', () {
    test('should send credentials and parse response', () async {
      // Arrange
      final dio = Dio(
        BaseOptions(
          baseUrl: 'https://example.com',
        ),
      );

      addTearDown(dio.close);

      dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            expect(options.method, 'POST');

            expect(
              options.path,
              '/api/auth/login',
            );

            expect(options.data, {
              'email': 'test@example.com',
              'password': 'password123',
            });

            handler.resolve(
              Response<Map<String, dynamic>>(
                requestOptions: options,
                statusCode: 200,
                data: {
                  'accessToken': 'fake_token_jwt',
                  'expiresAtUtc': '2026-10-17T22:30:00Z',
                },
              ),
            );
          },
        ),
      );
      final dataSource = LoginRemoteDatasource(dio: dio);

      const request = LoginRequestDto(
        email: 'test@example.com',
        password: 'password123',
      );

      // Act
      final response = await dataSource.login(request);

      // Assert
      expect(response.accessToken, 'fake_token_jwt');
      expect(response.expiresAtUtc, DateTime.utc(2026, 10, 17, 22, 30, 0));
    });
  });
}
