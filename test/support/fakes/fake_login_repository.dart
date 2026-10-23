import 'package:bloodline_mobile/app/features/identity/domain/repository/login_repository.dart';

import '../builders/auth_session_builder.dart';

typedef LoginHandler = Future<LoginResult> Function(
  String email,
  String password,
);

final class FakeLoginRepository implements ILoginRepository {
  FakeLoginRepository([LoginHandler? onLogin]) : _onLogin = onLogin ?? _succeed;

  final LoginHandler _onLogin;

  int callCount = 0;
  String? receivedEmail;
  String? receivedPassword;

  static Future<LoginResult> _succeed(String email, String password) async {
    return LoginSucceeded(buildAuthSession());
  }

  @override
  Future<LoginResult> login({
    required String email,
    required String password,
  }) {
    callCount++;
    receivedEmail = email;
    receivedPassword = password;

    return _onLogin(email, password);
  }
}
