import 'package:bloodline_mobile/app/app.dart';
import 'package:bloodline_mobile/app/features/identity/domain/models/auth_session.dart';
import 'package:bloodline_mobile/app/features/identity/domain/repository/login_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';

final class FakeLoginRepository implements ILoginRepository {
  String? receivedEmail;
  String? receivedPassword;

  @override
  Future<LoginResult> login({
    required String email,
    required String password,
  }) async {
    receivedEmail = email;
    receivedPassword = password;

    return LoginSucceeded(
      AuthSession(
        accessToken: 'fake.jwt.token',
        expiresAtUtc: DateTime.now().toUtc(),
      ),
    );
  }
}

void main() {
  testWidgets(
    'Should submit credentials through LoginCubit',
    (WidgetTester tester) async {
      // Arrange
      final repository = FakeLoginRepository();

      await tester.pumpWidget(BloodlineApp(loginRepository: repository));

      await tester.tap(find.text('Entrar'));
      await tester.pumpAndSettle();

      // Act
      await tester.enterText(
        find.byKey(const Key('login_email')),
        'test@example.com',
      );

      await tester.enterText(
        find.byKey(const Key('login_password')),
        'password123',
      );

      await tester.tap(
        find.byKey(const Key('login_submit')),
      );

      await tester.pump();
      await tester.pump(
        const Duration(milliseconds: 300),
      );

      // Assert
      expect(repository.receivedEmail, 'test@example.com');
      expect(repository.receivedPassword, 'password123');

      expect(
        find.text('Login realizado com sucesso!'),
        findsOneWidget,
      );
    },
  );
}
