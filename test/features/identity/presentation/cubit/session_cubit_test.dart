import 'package:bloc_test/bloc_test.dart';
import 'package:bloodline_mobile/app/features/identity/domain/models/auth_session.dart';
import 'package:bloodline_mobile/app/features/identity/domain/repository/session_store.dart';
import 'package:bloodline_mobile/app/features/identity/presentation/cubit/session_cubit.dart';
import 'package:bloodline_mobile/app/features/identity/presentation/cubit/session_state.dart';
import 'package:flutter_test/flutter_test.dart';

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

void main() {
  group('SessionCubit', () {
    final now = DateTime.utc(2026, 10, 20, 12);

    blocTest<SessionCubit, SessionState>(
      'should restore as unauthenticated when no session exists',
      build: () => SessionCubit(
        FakeSessionStore(),
        () => now,
      ),
      act: (cubit) => cubit.restore(),
      expect: () => [
        isA<SessionRestoring>(),
        isA<SessionUnauthenticated>(),
      ],
    );

    blocTest(
      'should restore a valid session',
      build: () => SessionCubit(
        FakeSessionStore(
          session: AuthSession(
            accessToken: 'valid.jwt.token',
            expiresAtUtc: now.add(const Duration(hours: 1)),
          ),
        ),
        () => now,
      ),
      act: (cubit) => cubit.restore(),
      expect: () => [
        isA<SessionRestoring>(),
        isA<SessionAuthenticated>().having(
          (state) => state.expiresAtUtc,
          'expiresAtUtc',
          now.add(const Duration(hours: 1)),
        ),
      ],
    );

    blocTest<SessionCubit, SessionState>(
      'should report unavailable session when storage fails',
      build: () => SessionCubit(
        FakeSessionStore(failOnRead: true),
        () => now,
      ),
      act: (cubit) => cubit.restore(),
      expect: () => [
        isA<SessionRestoring>(),
        isA<SessionUnavailable>(),
      ],
      errors: () => [
        isA<StateError>(),
      ],
    );

    test('should discard an expired session', () async {
      final store = FakeSessionStore(
        session: AuthSession(
          accessToken: 'expired.jwt.token',
          expiresAtUtc: now.subtract(const Duration(hours: 1)),
        ),
      );

      final cubit = SessionCubit(
        store,
        () => now,
      );

      await cubit.restore();

      expect(cubit.state, isA<SessionUnauthenticated>());
      expect(store.clearCount, 1);
      expect(store.session, isNull);
    });

    test('should persist a session before authenticating', () async {
      final store = FakeSessionStore();

      final cubit = SessionCubit(store, () => now);

      addTearDown(cubit.close);

      final session = AuthSession(
        accessToken: 'new.jwt.token',
        expiresAtUtc: now.add(const Duration(hours: 1)),
      );

      await cubit.startSession(session);

      expect(cubit.state, isA<SessionAuthenticated>());
      expect(store.session, same(session));
    });

    test('should clear the session on logout', () async {
      final store = FakeSessionStore();

      final cubit = SessionCubit(store, () => now);

      addTearDown(cubit.close);

      await cubit.startSession(
        AuthSession(
          accessToken: 'valid.jwt.token',
          expiresAtUtc: now.add(const Duration(hours: 1)),
        ),
      );

      await cubit.logout();

      expect(cubit.state, isA<SessionUnauthenticated>());
      expect(store.session, isNull);
      expect(store.clearCount, 1);
    });
  });
}
