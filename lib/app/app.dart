import 'package:bloodline_mobile/app/router/app_router.dart';
import 'package:flutter/material.dart';

class BloodlineApp extends StatelessWidget {
  const BloodlineApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Project Bloodline',
      debugShowCheckedModeBanner: false,
      routerConfig: appRouter,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF8F263A),
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: const Color(0xFF101016),
      ),
    );
  }
}
