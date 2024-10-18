import 'dart:convert';
import 'package:gasman4u/data/api_services/api_constants.dart';
import 'package:gasman4u/data/api_services/endpoints.dart';
import 'package:gasman4u/data/api_services/token_service.dart';
import 'package:gasman4u/data/models/cart/cart_model.dart';
import 'package:http/http.dart' as http;

class CartApiServices {
  // fetch cart items in a list
  Future<List<CartModel>> getCart() async {
    final Uri url = Uri.parse('${ApiConstants.baseUrl}${Endpoints.getCart}');
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
      final List<dynamic> cartData = responseData['data']['cart_items'];
      final String baseImageUrl = responseData['data']['url'];

      return cartData.map((cart) {
        cart['image'] = baseImageUrl + '/' + cart['image'];
        return CartModel.fromJson(cart);
      }).toList();
    } else {
      throw Exception("Failed to fetch cart");
    }
  }

//Add to cart
  Future<void> addToCart(num productId, int quantity) async {
    final Uri url = Uri.parse('${ApiConstants.baseUrl}${Endpoints.addToCart}');
    final token = await TokenService.getToken();

    if (token == null) {
      throw Exception("No authentication token found");
    }

    var request = http.MultipartRequest('POST', url);
    request.headers['Authorization'] = 'Bearer $token';
    request.fields['product_id'] = productId.toString();
    request.fields['quantity'] = quantity.toString();

    var response = await request.send();

    if (response.statusCode != 200) {
      throw Exception("Failed to add item to cart");
    }
  }

// update cart
  Future<void> updateCart(num productId, int quantity) async {
    final Uri url = Uri.parse('${ApiConstants.baseUrl}${Endpoints.updateItem}');
    final token = await TokenService.getToken();

    if (token == null) {
      throw Exception("No authentication token found");
    }

    var request = http.MultipartRequest('POST', url);
    request.headers['Authorization'] = 'Bearer $token';
    request.fields['product_id'] = productId.toString();
    request.fields['quantity'] = quantity.toString();

    var response = await request.send();

    if (response.statusCode != 200) {
      throw Exception("Failed to add item to cart");
    }
  }

//remove cart
  Future<void> removeItem(num productId) async {
    final Uri url = Uri.parse('${ApiConstants.baseUrl}${Endpoints.removeItem}');
    final token = await TokenService.getToken();

    if (token == null) {
      throw Exception("No authentication token found");
    }

    var request = http.MultipartRequest('POST', url);
    request.headers['Authorization'] = 'Bearer $token';
    request.fields['product_id'] = productId.toString();

    var response = await request.send();

    if (response.statusCode != 200) {
      throw Exception("Failed to remove item from cart");
    }
  }

//empty cart
  Future<void> emptyCart() async {
    final Uri url = Uri.parse('${ApiConstants.baseUrl}${Endpoints.emptyCart}');
    final token = await TokenService.getToken();

    if (token == null) {
      throw Exception("No authentication token found");
    }

    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode != 200) {
      throw Exception("Failed to empty cart");
    }
  }
}
