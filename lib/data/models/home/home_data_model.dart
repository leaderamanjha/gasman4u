import 'package:gasman4u/data/models/home/home_categories_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'home_data_model.g.dart';

@JsonSerializable()
class HomeData {
  // List<Banners>? banners;
  List<Categories>? categories;
  String? url;

  HomeData({
    // this.banners,
    this.categories,
    this.url,
  });

  factory HomeData.fromJson(Map<String, dynamic> json) =>
      _$HomeDataFromJson(json);

  Map<String, dynamic> toJson() => _$HomeDataToJson(this);
}
