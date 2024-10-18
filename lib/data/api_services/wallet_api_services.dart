import 'dart:convert';
import 'package:gasman4u/data/api_services/api_constants.dart';
import 'package:gasman4u/data/api_services/endpoints.dart';
import 'package:gasman4u/data/api_services/token_service.dart';
import 'package:gasman4u/data/models/wallet/wallet_model.dart';
import 'package:http/http.dart' as http;

class WalletApiServices {
  Future<WalletModel> getWallet() async {
    final Uri url = Uri.parse('${ApiConstants.baseUrl}${Endpoints.getWallet}');
    final token = await TokenService.getToken();

    if (token == null) {
      throw Exception("No authentication token found");
    }

    final response = await http.get(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      final Map<String, dynamic> walletData = responseData['data']['wallet'];
      return WalletModel.fromJson(walletData);
    } else {
      throw Exception("Failed to fetch wallet");
    }
  }

  Future<void> addMoneyToWallet(num amount, String transactionId) async {
    final Uri url =
        Uri.parse('${ApiConstants.baseUrl}${Endpoints.addMoneyToWallet}');
    final token = await TokenService.getToken();

    if (token == null) {
      throw Exception("No authentication token found");
    }

    var request = http.MultipartRequest('POST', url);
    request.headers['Authorization'] = 'Bearer $token';
    request.fields['amount'] = amount.toString();
    request.fields['transaction_id'] = transactionId.toString();

    var response = await request.send();

    if (response.statusCode != 200) {
      throw Exception("Failed to add money to wallet");
    }
  }
}
