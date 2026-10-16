import 'package:bloodline_mobile/app/router/app_router.dart';
import 'package:bloodline_mobile/core/design_system/theme/bloodline_theme.dart';
import 'package:flutter/material.dart';

class BloodlineApp extends StatelessWidget {
  const BloodlineApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Project Bloodline',
      debugShowCheckedModeBanner: false,
      routerConfig: appRouter,
      theme: BloodlineTheme.dark,
    );
  }
}
