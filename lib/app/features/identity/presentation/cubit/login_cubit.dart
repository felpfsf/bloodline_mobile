import 'package:bloodline_mobile/app/features/identity/domain/repository/login_repository.dart';
import 'package:bloodline_mobile/app/features/identity/presentation/cubit/login_state.dart';
import 'package:bloodline_mobile/core/networking/api_failure.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final class LoginCubit extends Cubit<LoginState> {
  LoginCubit(this.repository) : super(const LoginInitial());

  final ILoginRepository repository;

  Future<void> login({
    required String email,
    required String password,
  }) async {
    if (isClosed || state is LoginLoading) return;

    emit(const LoginLoading());

    try {
      final result = await repository.login(
        email: email,
        password: password,
      );

      if (isClosed) return;

      switch (result) {
        case LoginSucceeded(:final session):
          emit(LoginSuccess(session));

        case LoginFailed(:final failure):
          emit(LoginFailure(failure));
      }
    } on FormatException {
      if (isClosed) return;

      emit(
        const LoginFailure(ApiFailure(type: ApiFailureType.unexpected)),
      );
    }
  }
}
