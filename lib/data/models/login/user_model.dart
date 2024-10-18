import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

@JsonSerializable()
class User {
  int? id;
  String? slug;
  String? name;
  String? phone;
  String? email;
  @JsonKey(name: 'email_verified_at')
  String? emailVerifiedAt;
  int? role;
  String? otp;
  @JsonKey(name: 'fcm_token')
  String? fcmToken;
  String? image;
  @JsonKey(name: 'org_id')
  String? orgId;
  int? status;
  @JsonKey(name: 'created_at')
  String? createdAt;
  @JsonKey(name: 'updated_at')
  String? updatedAt;

  User({
    this.id,
    this.slug,
    this.name,
    this.phone,
    this.email,
    this.emailVerifiedAt,
    this.role,
    this.otp,
    this.fcmToken,
    this.image,
    this.orgId,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);
}
