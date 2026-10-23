import 'dart:typed_data';

import 'package:bloodline_mobile/app/features/identity/data/interceptors/session_auth_interceptor.dart';
import 'package:bloodline_mobile/app/features/identity/domain/models/auth_session.dart';
import 'package:bloodline_mobile/app/features/identity/domain/repository/session_store.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

final class FakeSessionStore implements ISessionStore {
  AuthSession? session;

  @override
  Future<void> clear() async {
    session = null;
  }

  @override
  Future<AuthSession?> read() async => session;

  @override
  Future<void> save(AuthSession session) async {
    this.session = session;
  }
}

final class FakeHttpClientAdapter implements HttpClientAdapter {
  FakeHttpClientAdapter(this.statusCode);

  final int statusCode;
  RequestOptions? lastRequest;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    lastRequest = options;
    return ResponseBody.fromString('{}', statusCode);
  }

  @override
  void close({bool force = false}) {}
}

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

    AuthSession sessionWith(String token) => AuthSession(
      accessToken: token,
      expiresAtUtc: DateTime.now().add(const Duration(hours: 1)),
    );

    setUp(() {
      store = FakeSessionStore();
    });

    test('should attach bearer token on protected requests', () async {
      store.session = sessionWith('valid.jwt.token');
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
      store.session = sessionWith('valid.jwt.token');
      setUpDio(statusCode: 200);

      await dio.get<dynamic>('/public');

      expect(adapter.lastRequest!.headers['Authorization'], isNull);
    });

    test('should notify unauthorized for protected HTTP 401', () async {
      store.session = sessionWith('rejected.jwt.token');
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
