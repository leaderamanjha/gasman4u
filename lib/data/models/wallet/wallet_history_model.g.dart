// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wallet_history_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WalletHistoryModel _$WalletHistoryModelFromJson(Map<String, dynamic> json) =>
    WalletHistoryModel(
      id: json['id'] as num?,
      userId: json['user_id'] as num?,
      transactionType: json['transaction_type'] as num?,
      transactionId: json['transaction_id'] as String?,
      orderId: json['order_id'] as String?,
      description: json['description'] as String?,
      amount: json['amount'] as num?,
      closingBalance: json['closing_balance'] as num?,
      status: json['status'] as num?,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$WalletHistoryModelToJson(WalletHistoryModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'transaction_type': instance.transactionType,
      'transaction_id': instance.transactionId,
      'order_id': instance.orderId,
      'description': instance.description,
      'amount': instance.amount,
      'closing_balance': instance.closingBalance,
      'status': instance.status,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };
