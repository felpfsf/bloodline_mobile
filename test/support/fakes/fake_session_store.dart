import 'package:bloodline_mobile/app/features/identity/domain/models/auth_session.dart';
import 'package:bloodline_mobile/app/features/identity/domain/repository/session_store.dart';

final class FakeSessionStore implements ISessionStore {
  FakeSessionStore({
    this.session,
    this.failOnRead = false,
  });

  AuthSession? session;
  bool failOnRead;

  int clearCount = 0;

  @override
  Future<AuthSession?> read() async {
    if (failOnRead) {
      throw StateError('Secure storage read failed');
    }

    return session;
  }

  @override
  Future<void> save(AuthSession session) async {
    this.session = session;
  }

  @override
  Future<void> clear() async {
    clearCount++;
    session = null;
  }
}
