import 'dart:convert';
import 'package:gasman4u/data/api_services/endpoints.dart';
import 'package:gasman4u/data/models/login/login_model.dart';
import 'package:gasman4u/data/models/login/otp_model.dart';
import 'package:http/http.dart' as http;
import 'api_constants.dart';

class LoginApiService {
  // for Sending otp

  Future<OtpModel> sendOtp(String phoneNumber) async {
    final Uri url = Uri.parse(ApiConstants.baseUrl + Endpoints.sendOtp);

    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/x-www-form-urlencoded",
      },
      body: {
        "phone": phoneNumber,
      },
    );
    if (response.statusCode == 200 || response.statusCode == 400) {
      return OtpModel.fromJson(json.decode(response.body));
    } else {
      throw Exception("Failed to send OTP");
    }
  }

// -----------------------------------------------------------------------------
  // for login using mobile number and otp will varify

  Future<LoginModel> login(String phone, String otp, String fcmToken) async {
    final Uri url = Uri.parse(ApiConstants.baseUrl + Endpoints.login);

    final userData = await http.post(
      url,
      headers: {
        "Content-Type": "application/x-www-form-urlencoded",
      },
      body: {
        "phone": phone,
        "otp": otp,
        "fcm_token": fcmToken,
      },
    );
    if (userData.statusCode == 200 || userData.statusCode == 400) {
      return LoginModel.fromJson(json.decode(userData.body));
    } else {
      throw Exception("Login failed");
    }
  }

// -----------------------------------------------------------------------------
// new user signup need to give data as name , email and mobile number.

  Future<OtpModel> signup(String name, String email, String phone) async {
    final Uri url = Uri.parse(ApiConstants.baseUrl + Endpoints.register);

    final registerResponse = await http.post(
      url,
      headers: {
        "Content-Type": "application/x-www-form-urlencoded",
      },
      body: {
        "name": name,
        "email": email,
        "phone": phone,
      },
    );

    if (registerResponse.statusCode == 200 ||
        registerResponse.statusCode == 400) {
      return OtpModel.fromJson(json.decode(registerResponse.body));
    } else {
      throw Exception("Failed to Register");
    }
  }
}
