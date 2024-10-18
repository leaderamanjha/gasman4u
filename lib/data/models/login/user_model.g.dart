// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
      id: (json['id'] as num?)?.toInt(),
      slug: json['slug'] as String?,
      name: json['name'] as String?,
      phone: json['phone'] as String?,
      email: json['email'] as String?,
      emailVerifiedAt: json['email_verified_at'] as String?,
      role: (json['role'] as num?)?.toInt(),
      otp: json['otp'] as String?,
      fcmToken: json['fcm_token'] as String?,
      image: json['image'] as String?,
      orgId: json['org_id'] as String?,
      status: (json['status'] as num?)?.toInt(),
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'id': instance.id,
      'slug': instance.slug,
      'name': instance.name,
      'phone': instance.phone,
      'email': instance.email,
      'email_verified_at': instance.emailVerifiedAt,
      'role': instance.role,
      'otp': instance.otp,
      'fcm_token': instance.fcmToken,
      'image': instance.image,
      'org_id': instance.orgId,
      'status': instance.status,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
    };
