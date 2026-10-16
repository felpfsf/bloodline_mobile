import 'package:bloodline_mobile/core/design_system/widgets/bloodline_panel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets(
    'BloodlinePanel should render its child',
    (tester) async {
      // Arrange
      const testContent = 'Character Stats';

      // Act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: BloodlinePanel(
              child: Text(testContent),
            ),
          ),
        ),
      );

      // Assert
      expect(
        find.byType(BloodlinePanel),
        findsOneWidget,
      );

      expect(
        find.text(testContent),
        findsOneWidget,
      );
    },
  );
}
