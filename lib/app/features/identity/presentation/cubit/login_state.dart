import 'package:bloodline_mobile/app/features/identity/domain/models/auth_session.dart';
import 'package:bloodline_mobile/core/networking/api_failure.dart';

sealed class LoginState {
  const LoginState();
}

final class LoginInitial extends LoginState {
  const LoginInitial();
}

final class LoginLoading extends LoginState {
  const LoginLoading();
}

final class LoginSuccess extends LoginState {
  const LoginSuccess(this.session);

  final AuthSession session;
}

final class LoginFailure extends LoginState {
  const LoginFailure(this.failure);

  final ApiFailure failure;
}
