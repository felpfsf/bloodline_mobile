import 'package:bloodline_mobile/core/networking/dio_factory.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group(
    'DioFactory',
    () {
      test(
        'should create Dio with configurated baseUrl',
        () {
          // Arrange
          const baseUrl = 'https://example.com';

          // Act
          final dio = DioFactory.create(baseUrl: baseUrl);
          addTearDown(dio.close);

          // Assert
          expect(dio.options.baseUrl, baseUrl);
          expect(
            dio.options.connectTimeout,
            const Duration(seconds: 5),
          );
          expect(
            dio.options.receiveTimeout,
            const Duration(seconds: 15),
          );
          expect(
            dio.options.headers['Accept'],
            'application/json',
          );
        },
      );

      test(
        'should reject invalid baseUrl',
        () {
          // Act & Assert
          expect(
            () => DioFactory.create(baseUrl: ''),
            throwsArgumentError,
          );
        },
      );
    },
  );
}
