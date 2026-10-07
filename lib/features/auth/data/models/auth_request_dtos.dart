import 'package:json_annotation/json_annotation.dart';

part 'auth_request_dtos.g.dart';

@JsonSerializable(includeIfNull: false)
class LoginDto {
  final String email;
  final String password;

  const LoginDto({required this.email, required this.password});

  factory LoginDto.fromJson(Map<String, dynamic> json) =>
      _$LoginDtoFromJson(json);

  Map<String, dynamic> toJson() => _$LoginDtoToJson(this);
}

@JsonSerializable(includeIfNull: false)
class RegisterDto {
  final String email;
  final String password;
  final String fullName;
  final String? role;

  const RegisterDto({
    required this.email,
    required this.password,
    required this.fullName,
    this.role = 'customer',
  });

  factory RegisterDto.fromJson(Map<String, dynamic> json) =>
      _$RegisterDtoFromJson(json);

  Map<String, dynamic> toJson() => _$RegisterDtoToJson(this);
}

@JsonSerializable(includeIfNull: false)
class FirebaseSignInDto {
  final String idToken;
  final String? fullName;
  final String? email;
  final String? as;

  const FirebaseSignInDto({
    required this.idToken,
    this.fullName,
    this.email,
    this.as = 'customer',
  });

  factory FirebaseSignInDto.fromJson(Map<String, dynamic> json) =>
      _$FirebaseSignInDtoFromJson(json);

  Map<String, dynamic> toJson() => _$FirebaseSignInDtoToJson(this);
}

@JsonSerializable(includeIfNull: false)
class RefreshTokenDto {
  final String refreshToken;

  const RefreshTokenDto({required this.refreshToken});

  factory RefreshTokenDto.fromJson(Map<String, dynamic> json) =>
      _$RefreshTokenDtoFromJson(json);

  Map<String, dynamic> toJson() => _$RefreshTokenDtoToJson(this);
}

@JsonSerializable(includeIfNull: false)
class ForgotPasswordDto {
  final String email;

  const ForgotPasswordDto({required this.email});

  factory ForgotPasswordDto.fromJson(Map<String, dynamic> json) =>
      _$ForgotPasswordDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ForgotPasswordDtoToJson(this);
}
