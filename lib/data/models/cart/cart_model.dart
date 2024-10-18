import 'package:json_annotation/json_annotation.dart';

part 'cart_model.g.dart';

@JsonSerializable()
class CartModel {
  num? cartID;
  num? productQuantity;
  num? id;
  String? slug;
  String? name;
  @JsonKey(name: 'cat_id')
  num? catId;
  String? description;
  String? image;
  num? price;
  @JsonKey(name: 'security_deposit')
  num? securityDeposit;
  num? status;
  @JsonKey(name: 'created_at')
  DateTime? createdAt;
  @JsonKey(name: 'updated_at')
  DateTime? updatedAt;
  String? categoryName;

  CartModel({
    this.cartID,
    this.productQuantity,
    this.id,
    this.slug,
    this.name,
    this.catId,
    this.description,
    this.image,
    this.price,
    this.securityDeposit,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.categoryName,
  });

  factory CartModel.fromJson(Map<String, dynamic> json) =>
      _$CartModelFromJson(json);

  Map<String, dynamic> toJson() => _$CartModelToJson(this);
}
