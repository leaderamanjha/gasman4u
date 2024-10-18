import 'package:json_annotation/json_annotation.dart';

part 'products.g.dart';

@JsonSerializable()
class Products {
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

  Products({
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

  factory Products.fromJson(Map<String, dynamic> json) =>
      _$ProductsFromJson(json);

  Map<String, dynamic> toJson() => _$ProductsToJson(this);
}
