import 'dart:async';

import 'package:bloodline_mobile/app/features/identity/domain/repository/login_repository.dart';
import 'package:bloodline_mobile/app/features/identity/presentation/cubit/session_cubit.dart';
import 'package:bloodline_mobile/app/features/identity/presentation/cubit/session_state.dart';
import 'package:bloodline_mobile/app/router/app_router.dart';
import 'package:bloodline_mobile/core/design_system/theme/bloodline_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class BloodlineApp extends StatefulWidget {
  const BloodlineApp({
    super.key,
    required this.loginRepository,
    required this.sessionCubit,
  });

  final ILoginRepository loginRepository;
  final SessionCubit sessionCubit;

  @override
  State<BloodlineApp> createState() => _BloodlineAppState();
}

class _BloodlineAppState extends State<BloodlineApp> {
  late final GoRouter _router;
  late final SessionCubit _sessionCubit;
  late final StreamSubscription<SessionState> _sessionSub;

  @override
  void initState() {
    super.initState();

    _sessionCubit = widget.sessionCubit;

    _router = createAppRouter(
      loginRepository: widget.loginRepository,
      sessionCubit: _sessionCubit,
    );

    _sessionSub = _sessionCubit.stream.listen(
      (_) => _router.refresh(),
    );

    unawaited(_sessionCubit.restore());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _sessionCubit,
      child: MaterialApp.router(
        title: 'Project Bloodline',
        debugShowCheckedModeBanner: false,
        routerConfig: _router,
        theme: BloodlineTheme.dark,
      ),
    );
  }

  @override
  void dispose() {
    unawaited(_sessionSub.cancel());
    _router.dispose();
    unawaited(_sessionCubit.close());

    super.dispose();
  }
}
