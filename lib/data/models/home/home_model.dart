import 'package:gasman4u/data/models/home/home_data_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'home_model.g.dart';

@JsonSerializable()
class ResponseModel {
  final int code;
  final String message;
  final HomeData homeData;

  ResponseModel({
    required this.code,
    required this.message,
    required this.homeData,
  });

  factory ResponseModel.fromJson(Map<String, dynamic> json) =>
      _$ResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$ResponseModelToJson(this);
}
