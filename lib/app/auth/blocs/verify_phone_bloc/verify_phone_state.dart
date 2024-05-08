part of 'verify_phone_bloc.dart';

class VerifyPhoneState extends Equatable {
  final String phoneNumber;
  final String pinCode;
  final int timer;
  final String error;
  final bool isLogged;
  @override
  List<Object?> get props => [phoneNumber, pinCode, timer, error, isLogged];
  factory VerifyPhoneState.initial(String phone) {
    String obscureCharacter = "";
    for (int i = 1; i < phone.length - 2; i++) {
      obscureCharacter += "*";
    }
    String obscurePhone = phone.replaceRange(3, phone.length, obscureCharacter);
    return VerifyPhoneState(
        phoneNumber: obscurePhone,
        pinCode: "",
        timer: 60,
        error: "",
        isLogged: false);
  }

//<editor-fold desc="Data Methods">

  const VerifyPhoneState(
      {required this.phoneNumber,
      required this.pinCode,
      required this.timer,
      required this.error,
      this.isLogged = false});

  @override
  String toString() {
    return 'VerifyPhoneState{ phoneNumber: $phoneNumber, pinCode: $pinCode, timer: $timer, error: $error, isLogged: $isLogged,}';
  }

  VerifyPhoneState copyWith(
      {String? phoneNumber,
      String? pinCode,
      int? timer,
      String? error,
      bool? isLogged}) {
    return VerifyPhoneState(
      phoneNumber: phoneNumber ?? this.phoneNumber,
      pinCode: pinCode ?? this.pinCode,
      timer: timer ?? this.timer,
      error: error ?? this.error,
      isLogged: isLogged ?? this.isLogged,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'phoneNumber': phoneNumber,
      'pinCode': pinCode,
      'timer': timer,
      'error': error,
      'isLogged': isLogged
    };
  }

  factory VerifyPhoneState.fromMap(Map<String, dynamic> map) {
    return VerifyPhoneState(
      phoneNumber: map['phoneNumber'] as String,
      pinCode: map['pinCode'] as String,
      timer: map['timer'] as int,
      error: map['error'] as String,
      isLogged: map['isLogged'] as bool,
    );
  }

//</editor-fold>
}
