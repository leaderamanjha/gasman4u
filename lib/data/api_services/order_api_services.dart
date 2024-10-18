import 'dart:convert';
import 'package:gasman4u/data/api_services/api_constants.dart';
import 'package:gasman4u/data/api_services/endpoints.dart';
import 'package:gasman4u/data/api_services/token_service.dart';
import 'package:gasman4u/data/models/order/order_model.dart';
import 'package:http/http.dart' as http;

class OrderApiServices {
  //place order
  Future<OrderModel> placeOrder({
    required String deliveryType,
    String? deliveryDateTime,
    required String addressId,
  }) async {
    final Uri url = Uri.parse('${ApiConstants.baseUrl}${Endpoints.placeOrder}');
    final token = await TokenService.getToken();
    if (token == null) {
      throw Exception("No authentication token found");
    }

    var request = http.MultipartRequest('POST', url);
    request.headers['Authorization'] = 'Bearer $token';
    request.fields['delivery_type'] = deliveryType;
    request.fields['address_id'] = addressId;
    request.fields['delivery_date_time'] = deliveryDateTime ?? '';

    var response = await request.send();
    var responseBody = await response.stream.bytesToString();

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(responseBody);
      return OrderModel.fromJson(responseData['data']['order']);
    } else {
      throw Exception("Failed to place order");
    }
  }

  //update order
  Future<void> updateOrderPayment({
    required String orderId,
    required num paymentTypeId,
    required String transactionId,
  }) async {
    final Uri url =
        Uri.parse('${ApiConstants.baseUrl}${Endpoints.updateOrderPaymemt}');
    final token = await TokenService.getToken();
    if (token == null) {
      throw Exception("No authentication token found");
    }

    var request = http.MultipartRequest('POST', url);
    request.headers['Authorization'] = 'Bearer $token';
    request.fields['order_id'] = orderId.toString();
    request.fields['payment_type_id'] = paymentTypeId.toString();
    request.fields['transaction_id'] = transactionId.toString();

    var response = await request.send();

    if (response.statusCode != 200) {
      throw Exception("Failed to update order payment");
    }
  }

  //get orders in a list
  Future<List<OrderModel>> getOrders() async {
    final Uri url = Uri.parse('${ApiConstants.baseUrl}${Endpoints.getOrders}');
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
      final List<dynamic> ordersData = responseData['data']['orders'];

      return ordersData.map((orders) {
        return OrderModel.fromJson(orders);
      }).toList();
    } else {
      throw Exception("Failed to fetch services");
    }
  }

  // get order by order_id
  Future<OrderModel> getOrderByOrderId(String orderId) async {
    final Uri url = Uri.parse(
        '${ApiConstants.baseUrl}${Endpoints.getOrderByOrderId}/$orderId');
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
      final Map<String, dynamic> orderData = responseData['data']['order'];

      return OrderModel.fromJson(orderData);
    } else {
      throw Exception("Failed to fetch product details");
    }
  }

  //cancel order
  Future<void> removeItem(String orderId) async {
    final Uri url =
        Uri.parse('${ApiConstants.baseUrl}${Endpoints.cancelOrderByOrderId}');
    final token = await TokenService.getToken();

    if (token == null) {
      throw Exception("No authentication token found");
    }

    var request = http.MultipartRequest('POST', url);
    request.headers['Authorization'] = 'Bearer $token';

    var response = await request.send();

    if (response.statusCode != 200) {
      throw Exception("Failed to remove item from cart");
    }
  }
}
