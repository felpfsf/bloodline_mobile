import 'package:bloodline_mobile/app/features/identity/domain/repository/login_repository.dart';
import 'package:bloodline_mobile/app/features/identity/presentation/cubit/login_cubit.dart';
import 'package:bloodline_mobile/app/features/identity/presentation/login_page.dart';
import 'package:bloodline_mobile/app/features/welcome/welcome_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

GoRouter createAppRouter({
  required ILoginRepository loginRepository,
}) {
  return GoRouter(
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
    ],
  );
}
