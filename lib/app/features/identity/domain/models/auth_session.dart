final class AuthSession {
  const AuthSession({
    required this.accessToken,
    required this.expiresAtUtc,
  });

  final String accessToken;
  final DateTime expiresAtUtc;
}
