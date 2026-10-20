import 'package:bloodline_mobile/app/features/identity/data/dto/login_request_dto.dart';
import 'package:bloodline_mobile/app/features/identity/data/dto/login_response_dto.dart';
import 'package:dio/dio.dart';

final class LoginRemoteDatasource {
  const LoginRemoteDatasource({
    required this._dio,
  });

  final Dio _dio;

  Future<LoginResponseDto> login(LoginRequestDto request) async {
    final response = await _dio.post(
      '/api/auth/login',
      data: request.toJson(),
    );

    final data = response.data;

    if (data == null) {
      throw const FormatException(
        'Login response body is null',
      );
    }

    return LoginResponseDto.fromJson(data);
  }
}
