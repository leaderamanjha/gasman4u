import 'package:json_annotation/json_annotation.dart';

part 'wallet_history_model.g.dart';

@JsonSerializable()
class WalletHistoryModel {
  num? id;
  @JsonKey(name: 'user_id')
  num? userId;
  @JsonKey(name: 'transaction_type')
  num? transactionType;
  @JsonKey(name: 'transaction_id')
  String? transactionId;
  @JsonKey(name: 'order_id')
  String? orderId;
  String? description;
  num? amount;
  @JsonKey(name: 'closing_balance')
  num? closingBalance;
  num? status;
  @JsonKey(name: 'created_at')
  DateTime? createdAt;
  @JsonKey(name: 'updated_at')
  DateTime? updatedAt;

  WalletHistoryModel({
    this.id,
    this.userId,
    this.transactionType,
    this.transactionId,
    this.orderId,
    this.description,
    this.amount,
    this.closingBalance,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  factory WalletHistoryModel.fromJson(Map<String, dynamic> json) =>
      _$WalletHistoryModelFromJson(json);

  Map<String, dynamic> toJson() => _$WalletHistoryModelToJson(this);
}
