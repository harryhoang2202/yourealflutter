abstract class StatusState {
  const StatusState();
}

class LoadingState extends StatusState {
  const LoadingState();
}

class ErrorState extends StatusState {
  final String error;
  const ErrorState({
    required this.error,
  });
}

class SuccessState extends StatusState {
  final String message;

  const SuccessState({this.message = ""});
}

class IdleState extends StatusState {
  const IdleState();
}
