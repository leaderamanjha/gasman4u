// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderModel _$OrderModelFromJson(Map<String, dynamic> json) => OrderModel(
      id: json['id'] as num?,
      orderId: json['order_id'] as String?,
      userId: json['user_id'] as num?,
      metaData: json['meta_data'] as String?,
      orderTotalPrice: json['order_total'] as num?,
      paymentTypeId: json['payment_type_id'] as num?,
      paymentStatusId: json['payment_status'] as num?,
      transactionId: json['transaction_id'] as String?,
      addressId: json['address_id'] as num?,
      deliveryType: json['delivery_type'] as String?,
      deliveryDateTime: json['delivery_date_time'] == null
          ? null
          : DateTime.parse(json['delivery_date_time'] as String),
      deliveredDateTime: json['delivered_date_time'] == null
          ? null
          : DateTime.parse(json['delivered_date_time'] as String),
      dealerId: json['dealer_id'] as num?,
      associateId: json['associate_id'] as num?,
      status: json['status'] as num?,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
      dealerShopname: json['dealerShopname'] as String?,
      orderStatus: json['orderStatus'] as String?,
      paymentTypeName: json['paymentTypeName'] as String?,
      userName: json['userName'] as String?,
      userEmail: json['userEmail'] as String?,
      userPhone: json['userPhone'] as String?,
      associateName: json['associateName'] as String?,
      associateEmail: json['associateEmail'] as String?,
      associatePhone: json['associatePhone'] as String?,
      addressLine1: json['addressLine1'] as String?,
      addressLine2: json['addressLine2'] as String?,
      addressCity: json['addressCity'] as String?,
      addressState: json['addressState'] as String?,
      addressPincode: json['addressPincode'] as String?,
      addressCountry: json['addressCountry'] as String?,
      addressLatitude: json['addressLatitude'] as String?,
      addressLongitude: json['addressLongitude'] as String?,
      paymentStatus: json['paymentStatus'] as String?,
    );

Map<String, dynamic> _$OrderModelToJson(OrderModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'order_id': instance.orderId,
      'user_id': instance.userId,
      'meta_data': instance.metaData,
      'order_total': instance.orderTotalPrice,
      'payment_type_id': instance.paymentTypeId,
      'payment_status': instance.paymentStatusId,
      'transaction_id': instance.transactionId,
      'address_id': instance.addressId,
      'delivery_type': instance.deliveryType,
      'delivery_date_time': instance.deliveryDateTime?.toIso8601String(),
      'delivered_date_time': instance.deliveredDateTime?.toIso8601String(),
      'dealer_id': instance.dealerId,
      'associate_id': instance.associateId,
      'status': instance.status,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
      'dealerShopname': instance.dealerShopname,
      'orderStatus': instance.orderStatus,
      'paymentTypeName': instance.paymentTypeName,
      'userName': instance.userName,
      'userEmail': instance.userEmail,
      'userPhone': instance.userPhone,
      'associateName': instance.associateName,
      'associateEmail': instance.associateEmail,
      'associatePhone': instance.associatePhone,
      'addressLine1': instance.addressLine1,
      'addressLine2': instance.addressLine2,
      'addressCity': instance.addressCity,
      'addressState': instance.addressState,
      'addressPincode': instance.addressPincode,
      'addressCountry': instance.addressCountry,
      'addressLatitude': instance.addressLatitude,
      'addressLongitude': instance.addressLongitude,
      'paymentStatus': instance.paymentStatus,
    };
