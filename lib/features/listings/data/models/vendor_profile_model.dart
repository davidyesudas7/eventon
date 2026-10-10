import 'package:json_annotation/json_annotation.dart';

part 'vendor_profile_model.g.dart';

@JsonSerializable()
class VendorProfileModel {
  final String id;
  final String fullName;
  final String? businessName;
  final String? bio;
  final String? profilePhotoUrl;

  VendorProfileModel({
    required this.id,
    required this.fullName,
    this.businessName,
    this.bio,
    this.profilePhotoUrl,
  });

  factory VendorProfileModel.fromJson(Map<String, dynamic> json) => _$VendorProfileModelFromJson(json);
  Map<String, dynamic> toJson() => _$VendorProfileModelToJson(this);
}
