import 'package:bloodline_mobile/app/features/identity/domain/models/auth_session.dart';
import 'package:bloodline_mobile/core/networking/api_failure.dart';

abstract interface class ILoginRepository {
  Future<LoginResult> login({
    required String email,
    required String password,
  });
}

sealed class LoginResult {
  const LoginResult();
}

final class LoginSucceeded extends LoginResult {
  const LoginSucceeded(this.session);

  final AuthSession session;
}

final class LoginFailed extends LoginResult {
  const LoginFailed(this.failure);

  final ApiFailure failure;
}
