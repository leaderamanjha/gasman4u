import 'dart:convert';
import 'package:gasman4u/data/api_services/api_constants.dart';
import 'package:gasman4u/data/api_services/endpoints.dart';
import 'package:gasman4u/data/api_services/token_service.dart';
import 'package:http/http.dart' as http;

class HomeApiService {
  Future<Map<String, dynamic>> getHomeData() async {
    final Uri url = Uri.parse(ApiConstants.baseUrl + Endpoints.getHome);
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
      return responseData['data'];
    } else {
      throw Exception("Failed to fetch home data");
    }
  }
}
