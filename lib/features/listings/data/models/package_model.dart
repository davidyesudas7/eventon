import 'package:json_annotation/json_annotation.dart';

part 'package_model.g.dart';

@JsonSerializable()
class PackageModel {
  final String id;
  final String listingId;
  final String name;
  final String? description;
  final num price;
  final String? durationLabel;
  final List<String> inclusions;

  PackageModel({
    required this.id,
    required this.listingId,
    required this.name,
    this.description,
    required this.price,
    this.durationLabel,
    required this.inclusions,
  });

  factory PackageModel.fromJson(Map<String, dynamic> json) => _$PackageModelFromJson(json);
  Map<String, dynamic> toJson() => _$PackageModelToJson(this);
}
