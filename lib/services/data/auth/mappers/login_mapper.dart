import 'package:youreal/services/data/auth/models/login_response_dto/login_response_dto.dart';
import 'package:youreal/services/domain/auth/models/token_info/token_info.dart';

extension LoginMapper on LoginResponseDto {
  TokenInfo toEntity() {
    return TokenInfo(
      accessToken: accessToken,
      expiresIn: expiresIn,
      scope: scope,
      tokenType: tokenType,
    );
  }
}
