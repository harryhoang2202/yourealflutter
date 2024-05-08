part of 'register_bloc.dart';

class RegisterState extends Equatable {
  final String phoneNumber;
  final String password;
  final String rePassword;
  final ButtonStatus buttonStatus;
  final String createdDateUtc;
  final String verificationToken;
  final String error;
  @override
  List<Object?> get props => [
        phoneNumber,
        password,
        rePassword,
        buttonStatus,
        createdDateUtc,
        verificationToken,
        error,
      ];
  factory RegisterState.initial() => const RegisterState(
      phoneNumber: "",
      password: "",
      rePassword: "",
      buttonStatus: ButtonStatus.idle,
      verificationToken: '',
      createdDateUtc: '',
      error: '');

//<editor-fold desc="Data Methods">

  const RegisterState({
    required this.phoneNumber,
    required this.password,
    required this.rePassword,
    required this.buttonStatus,
    required this.createdDateUtc,
    required this.verificationToken,
    required this.error,
  });

  @override
  String toString() {
    return 'RegisterState{' +
        ' phoneNumber: $phoneNumber,' +
        ' password: $password,' +
        ' rePassword: $rePassword,' +
        ' buttonStatus: $buttonStatus,' +
        ' createdDateUtc: $createdDateUtc,' +
        ' verificationToken: $verificationToken,' +
        ' error: $error,' +
        '}';
  }

  RegisterState copyWith({
    String? phoneNumber,
    String? password,
    String? rePassword,
    ButtonStatus? buttonStatus,
    String? createdDateUtc,
    String? verificationToken,
    String? error,
  }) {
    return RegisterState(
      phoneNumber: phoneNumber ?? this.phoneNumber,
      password: password ?? this.password,
      rePassword: rePassword ?? this.rePassword,
      buttonStatus: buttonStatus ?? this.buttonStatus,
      createdDateUtc: createdDateUtc ?? this.createdDateUtc,
      verificationToken: verificationToken ?? this.verificationToken,
      error: error ?? this.error,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'phoneNumber': phoneNumber,
      'password': password,
      'rePassword': rePassword,
      'buttonStatus': buttonStatus,
      'createdDateUtc': createdDateUtc,
      'verificationToken': verificationToken,
      'error': error,
    };
  }

  factory RegisterState.fromMap(Map<String, dynamic> map) {
    return RegisterState(
      phoneNumber: map['phoneNumber'] as String,
      password: map['password'] as String,
      rePassword: map['rePassword'] as String,
      buttonStatus: map['buttonStatus'] as ButtonStatus,
      createdDateUtc: map['createdDateUtc'] as String,
      verificationToken: map['verificationToken'] as String,
      error: map['error'] as String,
    );
  }

//</editor-fold>
}
