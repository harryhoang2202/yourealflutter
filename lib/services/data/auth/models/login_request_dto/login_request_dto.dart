import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'login_request_dto.g.dart';

@JsonSerializable()
class LoginRequestDto extends Equatable {
  @JsonKey(name: 'grant_type')
  final String? grantType;
  final String? scope;
  final String? username;
  final String? password;

  const LoginRequestDto({
    this.grantType,
    this.scope,
    this.username,
    this.password,
  });

  factory LoginRequestDto.fromJson(Map<String, dynamic> json) {
    return _$LoginRequestDtoFromJson(json);
  }

  Map<String, dynamic> toJson() => _$LoginRequestDtoToJson(this);

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [grantType, scope, username, password];
}
