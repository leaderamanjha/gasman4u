import 'package:json_annotation/json_annotation.dart';

part 'home_banner_model.g.dart';

@JsonSerializable()
class Banners {
  int? id;
  @JsonKey(name: 'banner_page')
  String? bannerPage;
  String? image;
  @JsonKey(name: 'service_id')
  int? serviceId;
  int? top;
  int? bottom;
  int? status;
  @JsonKey(name: 'created_at')
  DateTime? createdAt;
  @JsonKey(name: 'updated_at')
  DateTime? updatedAt;
  String? serviceName;

  Banners(
      {this.id,
      this.bannerPage,
      this.image,
      this.serviceId,
      this.top,
      this.bottom,
      this.status,
      this.createdAt,
      this.updatedAt,
      this.serviceName});

  factory Banners.fromJson(Map<String, dynamic> json) =>
      _$BannersFromJson(json);

  Map<String, dynamic> toJson() => _$BannersToJson(this);
}
