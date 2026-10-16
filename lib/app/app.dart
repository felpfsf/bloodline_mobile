import 'package:flutter/material.dart';

class BloodlineApp extends StatelessWidget {
  const BloodlineApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Project Bloodline',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF8F263A),
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: const Color(0xFF101016),
      ),
      home: const Scaffold(
        body: SafeArea(
          child: Center(
            child: Text(
              'PROJECT BLOODLINE',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
