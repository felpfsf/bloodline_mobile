import 'package:bloodline_mobile/app/features/identity/data/interceptors/session_auth_interceptor.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../support/builders/auth_session_builder.dart';
import '../../../../support/fakes/fake_http_client_adapter.dart';
import '../../../../support/fakes/fake_session_store.dart';

void main() {
  group('SessionAuthInterceptor', () {
    late FakeSessionStore store;
    late FakeHttpClientAdapter adapter;
    late Dio dio;
    late List<String?> rejectedTokens;

    void setUpDio({required int statusCode}) {
      adapter = FakeHttpClientAdapter(statusCode);
      rejectedTokens = [];
      dio = Dio(BaseOptions(baseUrl: 'https://api.test'))
        ..httpClientAdapter = adapter
        ..interceptors.add(
          SessionAuthInterceptor(
            store,
            onUnauthorized: (token) async => rejectedTokens.add(token),
          ),
        );
    }

    setUp(() {
      store = FakeSessionStore();
    });

    test('should attach bearer token on protected requests', () async {
      store.session = buildAuthSession(accessToken: 'valid.jwt.token');
      setUpDio(statusCode: 200);

      await dio.get<dynamic>(
        '/characters/me',
        options: Options(
          extra: {SessionAuthInterceptor.requiresAuthKey: true},
        ),
      );

      expect(
        adapter.lastRequest!.headers['Authorization'],
        'Bearer valid.jwt.token',
      );
    });

    test('should not attach token on public requests', () async {
      store.session = buildAuthSession(accessToken: 'valid.jwt.token');
      setUpDio(statusCode: 200);

      await dio.get<dynamic>('/public');

      expect(adapter.lastRequest!.headers['Authorization'], isNull);
    });

    test('should notify unauthorized for protected HTTP 401', () async {
      store.session = buildAuthSession(accessToken: 'rejected.jwt.token');
      setUpDio(statusCode: 401);

      await expectLater(
        dio.get<dynamic>(
          '/characters/me',
          options: Options(
            extra: {SessionAuthInterceptor.requiresAuthKey: true},
          ),
        ),
        throwsA(isA<DioException>()),
      );

      expect(rejectedTokens, ['rejected.jwt.token']);
    });

    test('should not notify unauthorized for public HTTP 401', () async {
      setUpDio(statusCode: 401);

      await expectLater(
        dio.get<dynamic>('/public'),
        throwsA(isA<DioException>()),
      );

      expect(rejectedTokens, isEmpty);
    });
  });
}
