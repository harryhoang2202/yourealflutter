import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'login_response_dto.g.dart';

@JsonSerializable()
class LoginResponseDto extends Equatable {
  @JsonKey(name: 'access_token')
  final String? accessToken;
  @JsonKey(name: 'expires_in')
  final int? expiresIn;
  @JsonKey(name: 'token_type')
  final String? tokenType;
  final String? scope;

  const LoginResponseDto({
    this.accessToken,
    this.expiresIn,
    this.tokenType,
    this.scope,
  });

  factory LoginResponseDto.fromJson(Map<String, dynamic> json) {
    return _$LoginResponseDtoFromJson(json);
  }

  Map<String, dynamic> toJson() => _$LoginResponseDtoToJson(this);

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [accessToken, expiresIn, tokenType, scope];
}
