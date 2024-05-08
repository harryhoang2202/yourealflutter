import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:dio/src/response.dart';
import 'package:injectable/injectable.dart';
import 'package:youreal/services/data/api_remote.dart';
import 'package:youreal/services/data/auth/mappers/login_mapper.dart';
import 'package:youreal/services/domain/auth/auth_failure.dart';
import 'package:youreal/services/domain/auth/i_auth_repository.dart';
import 'package:youreal/services/domain/auth/models/token_info/token_info.dart';
import 'package:youreal/services/domain/auth/models/user.dart';

import 'models/login_request_dto/login_request_dto.dart';
import 'models/login_response_dto/login_response_dto.dart';

@Singleton(as: IAuthRepository)
class AuthRepositoryImpl extends IAuthRepository {
  final ApiRemote _apiRemote;

  AuthRepositoryImpl(this._apiRemote);

  @override
  Future<Either<AuthFailure, TokenInfo>> loginWithPhoneNumberAndPassword(
      String phoneNumber, String password) async {
    try {
      final res = await _apiRemote.post(
        "connect/token",
        url: serverConfig["urlToken"],
        data: LoginRequestDto(
          grantType: "password",
          scope: "api openid profile",
          username: phoneNumber.replaceFirst("0", "+84"),
          password: password,
        ).toJson(),
        options: Options(
          headers: {'Authorization': 'Basic WW91UmVhbDpue244TntUVkY1JChkYi5x'},
        ),
      );
      final dto = LoginResponseDto.fromJson(res.data);
      return right(dto.toEntity());
    } catch (e) {
      return left(const AuthFailure.unknown());
    }
  }

  @override
  Future<Either<AuthFailure, User>> userInfo() async {
    try {
      final res = await _apiRemote.get(
        "account/info",
      );
      return right(User.fromJson(res.data));
    } catch (e) {
      return left(const AuthFailure.unknown());
    }
  }

  @override
  Future<Either<AuthFailure, dynamic>> registerWithPhoneNumberAndPassword(
      String phoneNumber,
      String password,
      String rePassword,
      String pinCode,
      String createdDateUtc) {
    // TODO: implement registerWithPhoneNumberAndPassword
    throw UnimplementedError();
  }

  @override
  Future<Either<AuthFailure, dynamic>> verifyPhoneNumber(String phoneNumber) {
    // TODO: implement verifyPhoneNumber
    throw UnimplementedError();
  }
}
