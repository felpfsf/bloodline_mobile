sealed class SessionState {
  const SessionState();
}

class SessionInitial extends SessionState {
  const SessionInitial();
}

class SessionRestoring extends SessionState {
  const SessionRestoring();
}

class SessionAuthenticated extends SessionState {
  const SessionAuthenticated({
    required this.expiresAtUtc,
  });

  final DateTime expiresAtUtc;
}

class SessionUnauthenticated extends SessionState {
  const SessionUnauthenticated();
}

class SessionUnavailable extends SessionState {
  const SessionUnavailable();
}
