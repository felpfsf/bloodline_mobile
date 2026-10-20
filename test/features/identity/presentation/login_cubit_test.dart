import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:bloodline_mobile/app/features/identity/domain/models/auth_session.dart';
import 'package:bloodline_mobile/app/features/identity/domain/repository/login_repository.dart';
import 'package:bloodline_mobile/app/features/identity/presentation/cubit/login_cubit.dart';
import 'package:bloodline_mobile/app/features/identity/presentation/cubit/login_state.dart';
import 'package:bloodline_mobile/core/networking/api_failure.dart';
import 'package:flutter_test/flutter_test.dart';

final class FakeLoginRepository implements ILoginRepository {
  FakeLoginRepository(this.onLogin);

  final Future<LoginResult> Function(String email, String password) onLogin;

  int callCount = 0;
  @override
  Future<LoginResult> login({
    required String email,
    required String password,
  }) {
    callCount++;

    return onLogin(email, password);
  }
}

void main() {
  group('LoginCubit', () {
    final session = AuthSession(
      accessToken: 'fake.jwt.token',
      expiresAtUtc: DateTime.now().toUtc(),
    );

    blocTest<LoginCubit, LoginState>(
      'should emit [LoginLoading, LoginSuccess] when login is successful',
      build: () {
        final fakeRepository = FakeLoginRepository(
          (email, password) async => LoginSucceeded(session),
        );

        return LoginCubit(fakeRepository);
      },
      act: (cubit) => cubit.login(
        email: 'test@example.com',
        password: 'password123',
      ),
      expect: () => [
        isA<LoginLoading>(),
        isA<LoginSuccess>().having(
          (state) => state.session.accessToken,
          'accessToken',
          'fake.jwt.token',
        ),
      ],
    );

    blocTest<LoginCubit, LoginState>(
      'should emit [LoginLoading, LoginFailure] when login fails',
      build: () {
        final fakeRepository = FakeLoginRepository(
          (email, password) async {
            return const LoginFailed(
              ApiFailure(
                type: ApiFailureType.unauthorized,
                statusCode: 401,
              ),
            );
          },
        );

        return LoginCubit(fakeRepository);
      },
      act: (cubit) => cubit.login(
        email: 'test@example.com',
        password: 'wrongpassword',
      ),
      expect: () => [
        isA<LoginLoading>(),
        isA<LoginFailure>().having(
          (state) => state.failure.type,
          'failure.type',
          ApiFailureType.unauthorized,
        ),
      ],
    );

    test(
      'should ignore subsequent login attempts while already logging in',
      () async {
        // Arrange
        final completer = Completer<LoginResult>();

        final repository = FakeLoginRepository(
          (email, password) => completer.future,
        );

        final cubit = LoginCubit(repository);

        addTearDown(cubit.close);

        // Act
        final firstRequest = cubit.login(
          email: 'test@example.com',
          password: 'password123',
        );

        final secondRequest = cubit.login(
          email: 'test@example.com',
          password: 'password123',
        );

        // Assert
        expect(repository.callCount, 1);
        expect(cubit.state, isA<LoginLoading>());

        completer.complete(
          LoginSucceeded(
            AuthSession(
              accessToken: 'fake.jwt.token',
              expiresAtUtc: DateTime.now().toUtc(),
            ),
          ),
        );

        await Future.wait([firstRequest, secondRequest]);

        expect(cubit.state, isA<LoginSuccess>());
      },
    );
  });
}
