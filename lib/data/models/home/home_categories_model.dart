import 'package:json_annotation/json_annotation.dart';

part 'home_categories_model.g.dart';

@JsonSerializable()
class Categories {
  num? id;
  String? slug;
  String? name;
  String? image;
  String? description;
  num? status;
  DateTime? createdAt;
  DateTime? updatedAt;

  Categories({
    this.id,
    this.slug,
    this.name,
    this.image,
    this.description,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  factory Categories.fromJson(Map<String, dynamic> json) =>
      _$CategoriesFromJson(json);

  Map<String, dynamic> toJson() => _$CategoriesToJson(this);
}
