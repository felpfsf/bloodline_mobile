import 'package:bloodline_mobile/app/features/identity/domain/models/auth_session.dart';
import 'package:bloodline_mobile/app/features/identity/domain/repository/session_store.dart';
import 'package:bloodline_mobile/app/features/identity/presentation/cubit/session_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final class SessionCubit extends Cubit<SessionState> {
  SessionCubit(
    this._store,
    DateTime Function()? now,
  ) : _now = now ?? DateTime.now,
      super(const SessionInitial());

  final ISessionStore _store;
  final DateTime Function() _now;

  bool _isValidSession(AuthSession session) {
    return session.accessToken.isNotEmpty &&
        session.expiresAtUtc.isAfter(_now().toUtc());
  }

  Future<void> restore() async {
    if (isClosed ||
        (state is! SessionInitial && state is! SessionUnavailable)) {
      return;
    }

    emit(const SessionRestoring());

    try {
      final session = await _store.read();

      if (isClosed) return;

      if (session == null) {
        emit(const SessionUnauthenticated());
        return;
      }

      if (!_isValidSession(session)) {
        await _store.clear();

        if (!isClosed) {
          emit(const SessionUnauthenticated());
        }

        return;
      }

      emit(
        SessionAuthenticated(expiresAtUtc: session.expiresAtUtc),
      );
    } catch (error, stackTrace) {
      _handleStorageError(error, stackTrace);
    }
  }

  Future<void> startSession(AuthSession session) async {
    if (isClosed) return;

    if (!_isValidSession(session)) {
      await logout();
      return;
    }

    try {
      await _store.save(session);

      if (isClosed) return;

      emit(
        SessionAuthenticated(expiresAtUtc: session.expiresAtUtc),
      );
    } catch (error, stackTrace) {
      _handleStorageError(error, stackTrace);
    }
  }

  Future<void> logout() async {
    if (isClosed) return;

    try {
      await _store.clear();

      if (!isClosed) {
        emit(const SessionUnauthenticated());
      }
    } catch (error, stackTrace) {
      _handleStorageError(error, stackTrace);
    }
  }

  void _handleStorageError(
    Object error,
    StackTrace stackTrace,
  ) {
    if (isClosed) return;

    addError(error, stackTrace);
    emit(const SessionUnavailable());
  }
}
