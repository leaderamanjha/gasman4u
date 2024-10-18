import 'dart:convert';
import 'package:gasman4u/data/api_services/api_constants.dart';
import 'package:gasman4u/data/api_services/endpoints.dart';
import 'package:gasman4u/data/api_services/token_service.dart';
import 'package:gasman4u/data/models/address/address_model.dart';
import 'package:http/http.dart' as http;

class AddressApiServices {
  // get Address items in a list
  Future<List<AddressModel>> getAddress() async {
    final Uri url = Uri.parse('${ApiConstants.baseUrl}${Endpoints.getAddress}');
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
      final List<dynamic> addressData = responseData['data']['address'];

      return addressData.map((address) {
        return AddressModel.fromJson(address);
      }).toList();
    } else {
      throw Exception("Failed to fetch address");
    }
  }

//Add Address
  Future<void> addAddress(
      String label,
      String addressLine1,
      String addressLine2,
      String city,
      String state,
      String pincode,
      String latitude,
      String longitude) async {
    final Uri url = Uri.parse('${ApiConstants.baseUrl}${Endpoints.addAddress}');
    final token = await TokenService.getToken();

    if (token == null) {
      throw Exception("No authentication token found");
    }
    var request = http.MultipartRequest('POST', url);
    request.headers['Authorization'] = 'Bearer $token';
    request.fields['label'] = label;
    request.fields['address_line1'] = addressLine1;
    request.fields['address_line2'] = addressLine2;
    request.fields['city'] = city;
    request.fields['state'] = state;
    request.fields['pincode'] = pincode.toString();
    request.fields['latitude'] = latitude.toString();
    request.fields['longitude'] = longitude.toString();

    var response = await request.send();

    if (response.statusCode != 200) {
      throw Exception("Failed to add address");
    }
  }

//delete address
  Future<void> deleteAddress(num addressId) async {
    final Uri url =
        Uri.parse('${ApiConstants.baseUrl}${Endpoints.deleteAddress}');
    final token = await TokenService.getToken();
    if (token == null) {
      throw Exception("No authentication token found");
    }
    var request = http.MultipartRequest('POST', url);
    request.headers['Authorization'] = 'Bearer $token';
    request.fields['address_id'] = addressId.toString();

    var response = await request.send();

    if (response.statusCode != 200) {
      throw Exception("Failed to delete address");
    }
  }
}
