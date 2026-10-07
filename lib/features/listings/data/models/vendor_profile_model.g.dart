// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vendor_profile_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VendorProfileModel _$VendorProfileModelFromJson(Map<String, dynamic> json) =>
    VendorProfileModel(
      id: json['id'] as String,
      fullName: json['fullName'] as String,
      businessName: json['businessName'] as String?,
      profilePhotoUrl: json['profilePhotoUrl'] as String?,
    );

Map<String, dynamic> _$VendorProfileModelToJson(VendorProfileModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'fullName': instance.fullName,
      'businessName': instance.businessName,
      'profilePhotoUrl': instance.profilePhotoUrl,
    };
