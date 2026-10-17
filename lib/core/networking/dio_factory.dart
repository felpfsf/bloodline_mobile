import 'package:dio/dio.dart';

abstract final class DioFactory {
  static Dio create({
    required String baseUrl,
  }) {
    final uri = Uri.tryParse(baseUrl);

    bool hasScheme =
        uri?.isScheme('http') == true || uri?.isScheme('https') == true;
    bool isValid = uri != null && uri.hasAuthority && hasScheme;

    if (!isValid) {
      throw ArgumentError.value(
        baseUrl,
        'baseUrl',
        'A valid HTTP or HTTPS URL is required.',
      );
    }

    return Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 5),
        receiveTimeout: const Duration(seconds: 15),
        headers: {
          'Accept': 'application/json',
        },
      ),
    );
  }
}
