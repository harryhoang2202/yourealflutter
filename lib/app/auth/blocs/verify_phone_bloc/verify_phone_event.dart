part of 'verify_phone_bloc.dart';

abstract class VerifyPhoneEvent extends Equatable {
  const VerifyPhoneEvent();
}

class VerifyPhoneCodeChanged extends VerifyPhoneEvent {
  final String code;

  const VerifyPhoneCodeChanged(this.code);

  @override
  List<Object?> get props => [code];
}

class VerifyPhoneClicked extends VerifyPhoneEvent {
  const VerifyPhoneClicked();
  @override
  List<Object?> get props => [];
}

class VerifyPhoneTimerStarted extends VerifyPhoneEvent {
  const VerifyPhoneTimerStarted();
  @override
  List<Object?> get props => [];
}

class VerifyPhoneCodeResent extends VerifyPhoneEvent {
  const VerifyPhoneCodeResent();
  @override
  List<Object?> get props => [];
}
