import 'package:bloodline_mobile/core/networking/api_failure.dart';
import 'package:bloodline_mobile/core/networking/api_failure_mapper.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group(
    'ApiFailureMapper',
    () {
      test(
        'should map connection timeout',
        () {
          // Arrange
          final exception = DioException(
            requestOptions: RequestOptions(path: '/characters/me'),
            type: DioExceptionType.connectionTimeout,
          );

          // Act
          final failure = ApiFailureMapper.fromDioException(exception);

          // Assert
          expect(failure.type, ApiFailureType.timeout);
          expect(failure.statusCode, isNull);
        },
      );
      test(
        'should map connection error',
        () {
          // Arrange
          final exception = DioException(
            requestOptions: RequestOptions(path: '/characters/me'),
            type: DioExceptionType.connectionError,
          );

          // Act
          final failure = ApiFailureMapper.fromDioException(exception);

          // Assert
          expect(failure.type, ApiFailureType.connection);
        },
      );
      test(
        'should map HTTP 401 to unauthorized',
        () {
          // Arrange
          final requestOptions = RequestOptions(
            path: '/characters/me',
          );

          final exception = DioException(
            requestOptions: requestOptions,
            type: DioExceptionType.badResponse,
            response: Response(
              requestOptions: requestOptions,
              statusCode: 401,
            ),
          );

          // Act
          final failure = ApiFailureMapper.fromDioException(exception);

          // Assert
          expect(failure.type, ApiFailureType.unauthorized);
          expect(failure.statusCode, 401);
        },
      );
    },
  );
}
