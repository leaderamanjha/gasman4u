import 'package:gasman4u/data/models/wallet/wallet_history_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'wallet_model.g.dart';

@JsonSerializable()
class WalletModel {
  num? id;
  @JsonKey(name: 'user_id')
  num? userId;
  @JsonKey(name: 'wallet_balance')
  num? walletBalance;
  num? status;
  @JsonKey(name: 'created_at')
  DateTime? createdAt;
  @JsonKey(name: 'updated_at')
  DateTime? updatedAt;
  @JsonKey(name: 'wallet_history')
  List<WalletHistoryModel>? walletHistory;

  WalletModel({
    this.id,
    this.userId,
    this.walletBalance,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.walletHistory,
  });

  factory WalletModel.fromJson(Map<String, dynamic> json) =>
      _$WalletModelFromJson(json);

  Map<String, dynamic> toJson() => _$WalletModelToJson(this);
}
