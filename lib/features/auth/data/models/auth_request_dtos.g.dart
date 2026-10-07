// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_request_dtos.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LoginDto _$LoginDtoFromJson(Map<String, dynamic> json) => LoginDto(
  email: json['email'] as String,
  password: json['password'] as String,
);

Map<String, dynamic> _$LoginDtoToJson(LoginDto instance) => <String, dynamic>{
  'email': instance.email,
  'password': instance.password,
};

RegisterDto _$RegisterDtoFromJson(Map<String, dynamic> json) => RegisterDto(
  email: json['email'] as String,
  password: json['password'] as String,
  fullName: json['fullName'] as String,
  role: json['role'] as String? ?? 'customer',
);

Map<String, dynamic> _$RegisterDtoToJson(RegisterDto instance) =>
    <String, dynamic>{
      'email': instance.email,
      'password': instance.password,
      'fullName': instance.fullName,
      'role': ?instance.role,
    };

FirebaseSignInDto _$FirebaseSignInDtoFromJson(Map<String, dynamic> json) =>
    FirebaseSignInDto(
      idToken: json['idToken'] as String,
      fullName: json['fullName'] as String?,
      email: json['email'] as String?,
      as: json['as'] as String? ?? 'customer',
    );

Map<String, dynamic> _$FirebaseSignInDtoToJson(FirebaseSignInDto instance) =>
    <String, dynamic>{
      'idToken': instance.idToken,
      'fullName': ?instance.fullName,
      'email': ?instance.email,
      'as': ?instance.as,
    };

RefreshTokenDto _$RefreshTokenDtoFromJson(Map<String, dynamic> json) =>
    RefreshTokenDto(refreshToken: json['refreshToken'] as String);

Map<String, dynamic> _$RefreshTokenDtoToJson(RefreshTokenDto instance) =>
    <String, dynamic>{'refreshToken': instance.refreshToken};

ForgotPasswordDto _$ForgotPasswordDtoFromJson(Map<String, dynamic> json) =>
    ForgotPasswordDto(email: json['email'] as String);

Map<String, dynamic> _$ForgotPasswordDtoToJson(ForgotPasswordDto instance) =>
    <String, dynamic>{'email': instance.email};
