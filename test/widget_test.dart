import 'package:bloodline_mobile/app/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets(
    'BloodlineApp should render application title',
    (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(const BloodlineApp());

      // Assert
      expect(find.text('PROJECT BLOODLINE'), findsOneWidget);

      expect(find.byType(MaterialApp), findsOneWidget);
    },
  );
}
