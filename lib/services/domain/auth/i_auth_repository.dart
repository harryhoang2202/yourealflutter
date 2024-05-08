import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:youreal/services/domain/auth/auth_failure.dart';

import 'models/token_info/token_info.dart';
import 'models/user.dart';

abstract class IAuthRepository {
  Future<Either<AuthFailure,TokenInfo>> loginWithPhoneNumberAndPassword(
      String phoneNumber, String password);
  Future<Either<AuthFailure,dynamic>> registerWithPhoneNumberAndPassword(
    String phoneNumber,
    String password,
    String rePassword,
    String pinCode,
    String createdDateUtc,
  );

  Future<Either<AuthFailure,dynamic>> verifyPhoneNumber(String phoneNumber);

  Future<Either<AuthFailure,User>> userInfo();
}
