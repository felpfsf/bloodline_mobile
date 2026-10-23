import 'package:bloodline_mobile/app/app.dart';
import 'package:bloodline_mobile/app/features/identity/presentation/cubit/session_cubit.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support/builders/auth_session_builder.dart';
import 'support/fakes/fake_login_repository.dart';
import 'support/fakes/fake_session_store.dart';

void main() {
  testWidgets(
    'Should submit credentials through LoginCubit',
    (WidgetTester tester) async {
      // Arrange
      final repository = FakeLoginRepository();
      final sessionStore = FakeSessionStore();

      await tester.pumpWidget(
        BloodlineApp(
          loginRepository: repository,
          sessionCubit: SessionCubit(sessionStore),
        ),
      );

      await tester.pumpAndSettle();

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
        find.byKey(const Key('login_button')),
      );

      await tester.pumpAndSettle();

      // Assert
      expect(find.text('DASHBOARD EM CONSTRUÇÃO'), findsOneWidget);

      expect(
        sessionStore.session,
        isNotNull,
      );
    },
  );

  testWidgets('should return to welcome page on logout', (
    WidgetTester tester,
  ) async {
    final repository = FakeLoginRepository();
    final sessionStore = FakeSessionStore(session: buildAuthSession());

    await tester.pumpWidget(
      BloodlineApp(
        loginRepository: repository,
        sessionCubit: SessionCubit(sessionStore),
      ),
    );

    await tester.pumpAndSettle();

    expect(
      find.text('DASHBOARD EM CONSTRUÇÃO'),
      findsOneWidget,
    );

    await tester.tap(find.text('Sair'));
    await tester.pumpAndSettle();

    expect(
      find.text('PROJECT BLOODLINE'),
      findsOneWidget,
    );

    expect(sessionStore.session, isNull);
  });
}
