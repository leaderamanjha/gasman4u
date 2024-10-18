import 'dart:convert';

import 'package:gasman4u/data/api_services/api_constants.dart';
import 'package:gasman4u/data/api_services/endpoints.dart';
import 'package:gasman4u/data/api_services/token_service.dart';
import 'package:gasman4u/data/models/home/home_categories_model.dart';
import 'package:http/http.dart' as http;

class CategoryApiService {
  Future<List<Categories>> getCategories() async {
    final Uri url = Uri.parse(ApiConstants.baseUrl + Endpoints.getCategory);
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
      final List<dynamic> categoriesData = responseData['data']['categories'];
      final String baseImageUrl = responseData['data']['url'];

      return categoriesData.map((category) {
        category['image'] = baseImageUrl + '/' + category['image'];
        return Categories.fromJson(category);
      }).toList();
    } else {
      throw Exception("Failed to fetch categories");
    }
  }
}
