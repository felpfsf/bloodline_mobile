import 'package:bloodline_mobile/app/features/identity/domain/repository/login_repository.dart';
import 'package:bloodline_mobile/app/features/identity/presentation/cubit/login_cubit.dart';
import 'package:bloodline_mobile/app/features/identity/presentation/cubit/session_cubit.dart';
import 'package:bloodline_mobile/app/features/identity/presentation/cubit/session_state.dart';
import 'package:bloodline_mobile/app/features/identity/presentation/login_page.dart';
import 'package:bloodline_mobile/app/features/welcome/welcome_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

GoRouter createAppRouter({
  required ILoginRepository loginRepository,
  required SessionCubit sessionCubit,
}) {
  return GoRouter(
    initialLocation: '/',
    redirect: (context, state) {
      final location = state.uri.path;
      final sessionState = sessionCubit.state;

      if (sessionState is SessionInitial || sessionState is SessionRestoring) {
        return location == '/session-loading' ? null : '/session-loading';
      }

      if (sessionState is SessionUnavailable) {
        return location == '/session-unavailable'
            ? null
            : '/session-unavailable';
      }

      if (sessionState is SessionAuthenticated) {
        return location == '/dashboard' ? null : '/dashboard';
      }

      if (location == '/' || location == '/login') {
        return null;
      }

      return '/';
    },
    routes: [
      GoRoute(
        path: '/',
        name: 'welcome',
        builder: (context, state) => const WelcomePage(),
      ),
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) {
          return BlocProvider(
            create: (context) => LoginCubit(loginRepository),
            child: const LoginPage(),
          );
        },
      ),
      GoRoute(
        path: '/session-loading',
        name: 'session-loading',
        builder: (context, state) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        },
      ),
      GoRoute(
        path: '/session-unavailable',
        name: 'session-unavailable',
        builder: (context, state) {
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Não foi possível recuperar a sessão'),
                  SizedBox(height: 24),
                  FilledButton(
                    onPressed: () {
                      context.read<SessionCubit>().restore();
                    },
                    child: Text('Tentar novamente'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      GoRoute(
        path: '/dashboard',
        name: 'dashboard',
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Dashboard'),
              centerTitle: true,
            ),
            body: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('DASHBOARD EM CONSTRUÇÃO'),
                  SizedBox(height: 24),
                  OutlinedButton(
                    onPressed: () {
                      context.read<SessionCubit>().logout();
                    },
                    child: const Text('Sair'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    ],
  );
}
