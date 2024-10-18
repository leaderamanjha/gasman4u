import 'dart:convert';
import 'package:gasman4u/data/api_services/api_constants.dart';
import 'package:gasman4u/data/api_services/endpoints.dart';
import 'package:gasman4u/data/api_services/token_service.dart';
import 'package:gasman4u/data/models/products/products.dart';
import 'package:http/http.dart' as http;

class ProductsApiServices {
  Future<List<Products>> getServicesByCategory(num categoryId) async {
    final Uri url = Uri.parse(
        '${ApiConstants.baseUrl}${Endpoints.getProductByCategory}/$categoryId');
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
      final List<dynamic> productsData = responseData['data']['products'];
      final String baseImageUrl = responseData['data']['url'];

      return productsData.map((products) {
        products['image'] = baseImageUrl + '/' + products['image'];
        return Products.fromJson(products);
      }).toList();
    } else {
      throw Exception("Failed to fetch services");
    }
  }

  Future<Products> getProductById(num productId) async {
    final Uri url = Uri.parse(
        '${ApiConstants.baseUrl}${Endpoints.getProductByProductId}/$productId');
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
      final Map<String, dynamic> productData = responseData['data']['product'];
      final String baseImageUrl = responseData['data']['url'];

      productData['image'] = baseImageUrl + '/' + productData['image'];
      return Products.fromJson(productData);
    } else {
      throw Exception("Failed to fetch product details");
    }
  }
}
