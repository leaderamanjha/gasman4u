import 'package:gasman4u/data/api_services/api_constants.dart';
import 'package:gasman4u/data/api_services/endpoints.dart';
import 'package:gasman4u/data/api_services/token_service.dart';
import 'package:gasman4u/data/models/login/user_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProfileApiService {
  Future<User> getProfile() async {
    final Uri url = Uri.parse('${ApiConstants.baseUrl}${Endpoints.getProfile}');
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
      return User.fromJson(responseData['data']['user']);
    } else {
      throw Exception("Failed to fetch profile");
    }
  }

// update profile picture
  Future<void> updateProfile(String base64Image) async {
    final token = await TokenService.getToken();
    if (token == null) {
      throw Exception("No authentication token found");
    }
    final response = await http.post(
      Uri.parse('${ApiConstants.baseUrl}${Endpoints.updateProfile}'),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: json.encode({
        "image": base64Image,
      }),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to update profile');
    }
  }
}
