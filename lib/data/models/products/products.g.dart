// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'products.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Products _$ProductsFromJson(Map<String, dynamic> json) => Products(
      id: json['id'] as num?,
      slug: json['slug'] as String?,
      name: json['name'] as String?,
      catId: json['cat_id'] as num?,
      description: json['description'] as String?,
      image: json['image'] as String?,
      price: json['price'] as num?,
      securityDeposit: json['security_deposit'] as num?,
      status: json['status'] as num?,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
      categoryName: json['categoryName'] as String?,
    );

Map<String, dynamic> _$ProductsToJson(Products instance) => <String, dynamic>{
      'id': instance.id,
      'slug': instance.slug,
      'name': instance.name,
      'cat_id': instance.catId,
      'description': instance.description,
      'image': instance.image,
      'price': instance.price,
      'security_deposit': instance.securityDeposit,
      'status': instance.status,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
      'categoryName': instance.categoryName,
    };
