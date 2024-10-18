import 'package:json_annotation/json_annotation.dart';
part 'order_model.g.dart';

@JsonSerializable()
class OrderModel {
  num? id;
  @JsonKey(name: 'order_id')
  String? orderId;
  @JsonKey(name: 'user_id')
  num? userId;
  @JsonKey(name: 'meta_data')
  String? metaData;
  @JsonKey(name: 'order_total')
  num? orderTotalPrice;
  @JsonKey(name: 'payment_type_id')
  num? paymentTypeId;
  @JsonKey(name: 'payment_status')
  num? paymentStatusId;
  @JsonKey(name: 'transaction_id')
  String? transactionId;
  @JsonKey(name: 'address_id')
  num? addressId;
  @JsonKey(name: 'delivery_type')
  String? deliveryType;
  @JsonKey(name: 'delivery_date_time')
  DateTime? deliveryDateTime;
  @JsonKey(name: 'delivered_date_time')
  DateTime? deliveredDateTime;
  @JsonKey(name: 'dealer_id')
  num? dealerId;
  @JsonKey(name: 'associate_id')
  num? associateId;
  num? status;
  @JsonKey(name: 'created_at')
  DateTime? createdAt;
  @JsonKey(name: 'updated_at')
  DateTime? updatedAt;
  String? dealerShopname;
  String? orderStatus;
  String? paymentTypeName;
  String? userName;
  String? userEmail;
  String? userPhone;
  String? associateName;
  String? associateEmail;
  String? associatePhone;
  String? addressLine1;
  String? addressLine2;
  String? addressCity;
  String? addressState;
  String? addressPincode;
  String? addressCountry;
  String? addressLatitude;
  String? addressLongitude;
  String? paymentStatus;

  OrderModel({
    this.id,
    this.orderId,
    this.userId,
    this.metaData,
    this.orderTotalPrice,
    this.paymentTypeId,
    this.paymentStatusId,
    this.transactionId,
    this.addressId,
    this.deliveryType,
    this.deliveryDateTime,
    this.deliveredDateTime,
    this.dealerId,
    this.associateId,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.dealerShopname,
    this.orderStatus,
    this.paymentTypeName,
    this.userName,
    this.userEmail,
    this.userPhone,
    this.associateName,
    this.associateEmail,
    this.associatePhone,
    this.addressLine1,
    this.addressLine2,
    this.addressCity,
    this.addressState,
    this.addressPincode,
    this.addressCountry,
    this.addressLatitude,
    this.addressLongitude,
    this.paymentStatus,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) =>
      _$OrderModelFromJson(json);

  Map<String, dynamic> toJson() => _$OrderModelToJson(this);
}
