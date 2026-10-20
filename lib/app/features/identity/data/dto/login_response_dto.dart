final class LoginResponseDto {
  const LoginResponseDto({
    required this.accessToken,
    required this.expiresAtUtc,
  });

  final String accessToken;
  final DateTime expiresAtUtc;

  factory LoginResponseDto.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'accessToken': final String accessToken,
        'expiresAtUtc': final String expiresAtUtc,
      } =>
        LoginResponseDto(
          accessToken: accessToken,
          expiresAtUtc: DateTime.parse(expiresAtUtc),
        ),
      _ => throw FormatException(
        'Invalid JSON format for LoginResponseDto',
      ),
    };
  }
}
