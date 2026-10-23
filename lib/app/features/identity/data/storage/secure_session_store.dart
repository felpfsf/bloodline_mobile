import 'dart:convert';

import 'package:bloodline_mobile/app/features/identity/domain/models/auth_session.dart';
import 'package:bloodline_mobile/app/features/identity/domain/repository/session_store.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final class SecureSessionStore implements ISessionStore {
  const SecureSessionStore(this._storage);

  static const String _sessionKey = 'bloodline.auth.session.v1';
  final FlutterSecureStorage _storage;

  @override
  Future<void> save(AuthSession session) {
    final data = jsonEncode({
      'accessToken': session.accessToken,
      'expiresAtUtc': session.expiresAtUtc.toUtc().toIso8601String(),
    });

    return _storage.write(
      key: _sessionKey,
      value: data,
    );
  }

  @override
  Future<AuthSession?> read() async {
    final raw = await _storage.read(key: _sessionKey);

    if (raw == null) return null;

    try {
      final decoded = jsonDecode(raw);

      if (decoded case {
        'accessToken': String accessToken,
        'expiresAtUtc': String expiresAtUtc,
      }) {
        if (accessToken.isNotEmpty) {
          return AuthSession(
            accessToken: accessToken,
            expiresAtUtc: DateTime.parse(expiresAtUtc).toUtc(),
          );
        }
      }
    } on FormatException {
      // Ignore format exceptions and return null
    }

    await clear();

    return null;
  }

  @override
  Future<void> clear() {
    return _storage.delete(key: _sessionKey);
  }
}
