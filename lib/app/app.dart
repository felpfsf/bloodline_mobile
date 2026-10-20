import 'package:bloodline_mobile/app/features/identity/domain/repository/login_repository.dart';
import 'package:bloodline_mobile/app/router/app_router.dart';
import 'package:bloodline_mobile/core/design_system/theme/bloodline_theme.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BloodlineApp extends StatefulWidget {
  const BloodlineApp({
    super.key,
    required this.loginRepository,
  });

  final ILoginRepository loginRepository;

  @override
  State<BloodlineApp> createState() => _BloodlineAppState();
}

class _BloodlineAppState extends State<BloodlineApp> {
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();
    _router = createAppRouter(
      loginRepository: widget.loginRepository,
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Project Bloodline',
      debugShowCheckedModeBanner: false,
      routerConfig: _router,
      theme: BloodlineTheme.dark,
    );
  }

  @override
  void dispose() {
    _router.dispose();
    super.dispose();
  }
}
