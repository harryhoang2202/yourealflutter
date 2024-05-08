part of 'register_bloc.dart';

abstract class RegisterEvent extends Equatable {
  const RegisterEvent();
}

class RegisterPhoneNumberChanged extends RegisterEvent {
  final String phone;

  const RegisterPhoneNumberChanged(this.phone);
  @override
  List<Object?> get props => [phone];
}

class RegisterPasswordChanged extends RegisterEvent {
  final String password;

  const RegisterPasswordChanged(this.password);
  @override
  List<Object?> get props => [password];
}

class RegisterRePasswordChanged extends RegisterEvent {
  final String password;

  const RegisterRePasswordChanged(this.password);
  @override
  List<Object?> get props => [password];
}

class RegisterClicked extends RegisterEvent {
  final GestureTapCallback? onSuccess;
  final ValueChanged<String>? onFailed;
  final GlobalKey<FormState> formKey;
  const RegisterClicked(this.formKey, {this.onSuccess, this.onFailed});
  @override
  List<Object?> get props => [
        onSuccess,
        onFailed,
        formKey,
      ];
}

class RegisterCodeResent extends RegisterEvent {
  @override
  List<Object?> get props => [];
}
