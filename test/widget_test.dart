import 'package:bloodline_mobile/app/app.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets(
    'Should navigate from welcome to login',
    (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(const BloodlineApp());

      // Assert
      expect(
        find.text('PROJECT BLOODLINE'),
        findsOneWidget,
      );

      // Act
      await tester.tap(find.text('Entrar'));
      await tester.pumpAndSettle();

      // Assert navigation to login page
      expect(
        find.text('Login'),
        findsOneWidget,
      );
    },
  );
}
