import 'package:json_annotation/json_annotation.dart';

part 'address_model.g.dart';

@JsonSerializable()
class AddressModel {
  num? id;
  @JsonKey(name: 'user_id')
  String? userId;
  String? label;
  @JsonKey(name: 'address_line1')
  String? addressLine1;
  @JsonKey(name: 'address_line2')
  String? addressLine2;
  String? city;
  String? state;
  String? pincode;
  String? country;
  String? latitude;
  String? longitude;
  num? status;
  @JsonKey(name: 'created_at')
  DateTime? createdAt;
  @JsonKey(name: 'updated_at')
  DateTime? updatedAt;

  AddressModel({
    this.id,
    this.userId,
    this.label,
    this.addressLine1,
    this.addressLine2,
    this.city,
    this.state,
    this.pincode,
    this.country,
    this.latitude,
    this.longitude,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  factory AddressModel.fromJson(Map<String, dynamic> json) =>
      _$AddressModelFromJson(json);

  Map<String, dynamic> toJson() => _$AddressModelToJson(this);
}
