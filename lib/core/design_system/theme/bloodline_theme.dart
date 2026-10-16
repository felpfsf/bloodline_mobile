import 'package:bloodline_mobile/core/design_system/theme/bloodline_colors.dart';
import 'package:flutter/material.dart';

abstract final class BloodlineTheme {
  static final ThemeData dark = ThemeData(
    scaffoldBackgroundColor: BloodlineColors.background,

    colorScheme:
        ColorScheme.fromSeed(
          seedColor: BloodlineColors.primary,
          brightness: Brightness.dark,
        ).copyWith(
          primary: BloodlineColors.primary,
          onPrimary: Colors.white,
          secondary: BloodlineColors.gold,
          onSecondary: BloodlineColors.background,
          surface: BloodlineColors.surface,
          onSurface: BloodlineColors.textPrimary,
          surfaceContainer: BloodlineColors.surface,
          surfaceContainerHigh: BloodlineColors.surfaceElevated,
          outline: BloodlineColors.border,
        ),

    textTheme: const TextTheme(
      headlineMedium: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        letterSpacing: 2,
        color: BloodlineColors.textPrimary,
      ),
      titleLarge: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: BloodlineColors.textPrimary,
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        color: BloodlineColors.textPrimary,
      ),
      bodySmall: TextStyle(
        fontSize: 12,
        color: BloodlineColors.textSecondary,
      ),
    ),
  );
}
