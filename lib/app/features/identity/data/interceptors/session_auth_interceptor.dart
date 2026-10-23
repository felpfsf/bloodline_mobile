import 'package:bloodline_mobile/app/features/identity/domain/repository/session_store.dart';
import 'package:dio/dio.dart';

final class SessionAuthInterceptor extends Interceptor {
  SessionAuthInterceptor(
    this._sessionStore, {
    required this._onUnauthorized,
  });

  final ISessionStore _sessionStore;
  final Future<void> Function(String? token) _onUnauthorized;

  static const String requiresAuthKey = 'requiresAuth';

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (options.extra[requiresAuthKey] != true) {
      handler.next(options);
      return;
    }

    try {
      final session = await _sessionStore.read();

      if (session != null && session.accessToken.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer ${session.accessToken}';
      }

      handler.next(options);
    } catch (error, stackTrace) {
      handler.reject(
        DioException(
          requestOptions: options,
          type: DioExceptionType.unknown,
          error: error,
          stackTrace: stackTrace,
        ),
      );
    }
  }

  @override
  void onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    try {
      final isUnauthorized = err.response?.statusCode == 401;
      final requiresAuth = err.requestOptions.extra[requiresAuthKey] == true;

      if (isUnauthorized && requiresAuth) {
        final authorization = err.requestOptions.headers['Authorization'];
        final token =
            authorization is String && authorization.startsWith('Bearer ')
            ? authorization.substring('Bearer '.length)
            : null;

        await _onUnauthorized(token);
      }
    } finally {
      handler.next(err);
    }
  }
}
