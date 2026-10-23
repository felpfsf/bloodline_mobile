import 'package:bloodline_mobile/app/features/identity/domain/models/auth_session.dart';

/// Builds a session that is valid for one hour unless overridden.
AuthSession buildAuthSession({
  String accessToken = 'fake.jwt.token',
  DateTime? expiresAtUtc,
}) {
  return AuthSession(
    accessToken: accessToken,
    expiresAtUtc:
        expiresAtUtc ?? DateTime.now().toUtc().add(const Duration(hours: 1)),
  );
}
