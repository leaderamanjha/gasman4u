// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_banner_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Banners _$BannersFromJson(Map<String, dynamic> json) => Banners(
      id: (json['id'] as num?)?.toInt(),
      bannerPage: json['banner_page'] as String?,
      image: json['image'] as String?,
      serviceId: (json['service_id'] as num?)?.toInt(),
      top: (json['top'] as num?)?.toInt(),
      bottom: (json['bottom'] as num?)?.toInt(),
      status: (json['status'] as num?)?.toInt(),
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
      serviceName: json['serviceName'] as String?,
    );

Map<String, dynamic> _$BannersToJson(Banners instance) => <String, dynamic>{
      'id': instance.id,
      'banner_page': instance.bannerPage,
      'image': instance.image,
      'service_id': instance.serviceId,
      'top': instance.top,
      'bottom': instance.bottom,
      'status': instance.status,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
      'serviceName': instance.serviceName,
    };
