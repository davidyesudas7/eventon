// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
  id: json['id'] as String,
  email: json['email'] as String?,
  fullName: json['fullName'] as String,
  roles: (json['roles'] as List<dynamic>).map((e) => e as String).toList(),
  phone: json['phone'] as String?,
  phoneSignIn: json['phoneSignIn'] as bool?,
  businessName: json['businessName'] as String?,
  bio: json['bio'] as String?,
  profilePhotoUrl: json['profilePhotoUrl'] as String?,
  territoryId: json['territoryId'] as String?,
  basePincode: json['basePincode'] as String?,
  lsgId: json['lsgId'] as String?,
);

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
  'id': instance.id,
  'email': instance.email,
  'fullName': instance.fullName,
  'roles': instance.roles,
  'phone': instance.phone,
  'phoneSignIn': instance.phoneSignIn,
  'businessName': instance.businessName,
  'bio': instance.bio,
  'profilePhotoUrl': instance.profilePhotoUrl,
  'territoryId': instance.territoryId,
  'basePincode': instance.basePincode,
  'lsgId': instance.lsgId,
};
