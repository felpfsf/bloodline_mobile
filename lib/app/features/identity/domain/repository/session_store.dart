import 'package:bloodline_mobile/app/features/identity/domain/models/auth_session.dart';

abstract interface class ISessionStore {
  Future<void> save(AuthSession session);
  Future<AuthSession?> read();
  Future<void> clear();
}
