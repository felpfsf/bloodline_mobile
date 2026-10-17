import 'package:bloodline_mobile/core/networking/api_failure.dart';
import 'package:dio/dio.dart';

abstract final class ApiFailureMapper {
  static ApiFailure fromDioException(DioException exception) {
    return switch (exception.type) {
      DioExceptionType.connectionTimeout ||
      DioExceptionType.sendTimeout ||
      DioExceptionType.receiveTimeout ||
      DioExceptionType.transformTimeout => const ApiFailure(
        type: ApiFailureType.timeout,
      ),

      DioExceptionType.connectionError => const ApiFailure(
        type: ApiFailureType.connection,
      ),

      DioExceptionType.badResponse => _fromResponse(
        exception.response?.statusCode,
      ),

      DioExceptionType.cancel => const ApiFailure(
        type: ApiFailureType.cancelled,
      ),

      DioExceptionType.badCertificate || DioExceptionType.unknown =>
        const ApiFailure(type: ApiFailureType.unexpected),
    };
  }

  static ApiFailure _fromResponse(int? statusCode) {
    final type = switch (statusCode) {
      400 || 422 => ApiFailureType.validation,
      401 => ApiFailureType.unauthorized,
      403 => ApiFailureType.forbidden,
      404 => ApiFailureType.notFound,
      409 => ApiFailureType.conflict,
      429 => ApiFailureType.rateLimited,
      final int code when code >= 500 && code < 600 => ApiFailureType.server,
      _ => ApiFailureType.unexpected,
    };

    return ApiFailure(
      type: type,
      statusCode: statusCode,
    );
  }
}
