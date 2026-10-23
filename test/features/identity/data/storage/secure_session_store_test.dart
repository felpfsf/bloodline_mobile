import 'package:bloodline_mobile/app/features/identity/data/storage/secure_session_store.dart';
import 'package:bloodline_mobile/app/features/identity/domain/models/auth_session.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('SecureSessionStore', () {
    setUp(() {
      FlutterSecureStorage.setMockInitialValues({});
    });

    const secureStorage = FlutterSecureStorage();

    test('should return null when no session is stored', () async {
      final store = SecureSessionStore(secureStorage);
      final session = await store.read();
      expect(session, isNull);
    });

    test('should save and restore a session correctly', () async {
      final store = SecureSessionStore(secureStorage);

      final sessionToSave = AuthSession(
        accessToken: 'fake.jwt.token',
        expiresAtUtc: DateTime.now().toUtc(),
      );

      await store.save(sessionToSave);

      final restored = await store.read();

      expect(restored, isNotNull);
      expect(restored!.accessToken, sessionToSave.accessToken);
      expect(restored.expiresAtUtc, sessionToSave.expiresAtUtc);
    });

    test('should clear the stored session', () async {
      final store = SecureSessionStore(secureStorage);

      await store.save(
        AuthSession(
          accessToken: 'fake.jwt.token',
          expiresAtUtc: DateTime.now().toUtc(),
        ),
      );

      await store.clear();

      final cleared = await store.read();
      expect(cleared, isNull);
    });

    test('should discard an invalid stored session', () async {
      final store = SecureSessionStore(secureStorage);

      await secureStorage.write(
        key: 'bloodline.auth.session.v1',
        value: 'invalid_json',
      );

      final session = await store.read();

      expect(session, isNull);

      expect(
        await secureStorage.read(key: 'bloodline.auth.session.v1'),
        isNull,
      );
    });
  });
}
