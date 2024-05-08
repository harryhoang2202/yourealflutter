import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'token_info.g.dart';

@JsonSerializable()
class TokenInfo extends Equatable {
  @JsonKey(name: 'access_token')
  final String? accessToken;
  @JsonKey(name: 'expires_in')
  final int? expiresIn;
  @JsonKey(name: 'token_type')
  final String? tokenType;
  final String? scope;

  const TokenInfo({
    this.accessToken,
    this.expiresIn,
    this.tokenType,
    this.scope,
  });

  factory TokenInfo.fromJson(Map<String, dynamic> json) {
    return _$TokenInfoFromJson(json);
  }

  Map<String, dynamic> toJson() => _$TokenInfoToJson(this);

  TokenInfo copyWith({
    String? accessToken,
    int? expiresIn,
    String? tokenType,
    String? scope,
  }) {
    return TokenInfo(
      accessToken: accessToken ?? this.accessToken,
      expiresIn: expiresIn ?? this.expiresIn,
      tokenType: tokenType ?? this.tokenType,
      scope: scope ?? this.scope,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [accessToken, expiresIn, tokenType, scope];
}
