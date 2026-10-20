import 'package:bloodline_mobile/app/features/identity/data/datasources/login_remote_datasource.dart';
import 'package:bloodline_mobile/app/features/identity/domain/models/auth_session.dart';
import 'package:bloodline_mobile/app/features/identity/domain/repository/login_repository.dart';
import 'package:bloodline_mobile/app/features/identity/data/dto/login_request_dto.dart';
import 'package:bloodline_mobile/core/networking/api_failure_mapper.dart';
import 'package:dio/dio.dart';

class LoginRepositoryImpl implements ILoginRepository {
  const LoginRepositoryImpl(this._datasource);

  final LoginRemoteDatasource _datasource;

  @override
  Future<LoginResult> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _datasource.login(
        LoginRequestDto(
          email: email,
          password: password,
        ),
      );

      final session = AuthSession(
        accessToken: response.accessToken,
        expiresAtUtc: response.expiresAtUtc.toUtc(),
      );

      return LoginSucceeded(session);
    } on DioException catch (exception) {
      final failure = ApiFailureMapper.fromDioException(exception);

      return LoginFailed(failure);
    }
  }
}
