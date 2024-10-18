import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gasman4u/data/api_services/profile_api_services.dart';
import 'package:gasman4u/data/api_services/token_service.dart';
import 'package:gasman4u/data/models/login/user_model.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

class ProfileController extends GetxController {
  final ProfileApiService _apiService = ProfileApiService();
  Rx<User?> userInfo = Rx<User?>(null);
  Rx<String?> profileImageBase64 = Rx<String?>(null);

  final List<Map<String, dynamic>> menuItems = [
    {"title": "About Gasman4U", "icon": Icons.info_outline},
    {"title": "Saved Address", "icon": Icons.home_repair_service_outlined},
    {"title": "Share Gasman4U", "icon": Icons.share},
    {"title": "Logout", "icon": Icons.logout},
  ];

  @override
  void onInit() {
    super.onInit();
    loadUserInfo();
  }

  Future<void> loadUserInfo() async {
    try {
      final user = await _apiService.getProfile();
      userInfo.value = user;
    } catch (e) {
      print('Error loading user info: $e');
    }
  }

  Future<void> pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      final bytes = await image.readAsBytes();
      final base64Image = base64Encode(bytes);
      profileImageBase64.value = base64Image;

      try {
        await _apiService.updateProfile(base64Image);
        await loadUserInfo(); // Reload user info after update
      } catch (e) {
        print('Error updating profile: $e');
      }
    }
  }

  void showLogoutConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            "Logout",
            style: GoogleFonts.roboto(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            "Are you sure you want to logout?",
            style: GoogleFonts.roboto(
              color: Colors.black,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          actions: [
            TextButton(
              child: Text("Yes", style: TextStyle(color: Colors.white)),
              style:
                  TextButton.styleFrom(backgroundColor: Colors.orange.shade700),
              onPressed: () {
                Navigator.of(context).pop();
                logout();
              },
            ),
            TextButton(
              child: Text("No", style: TextStyle(color: Colors.white)),
              style:
                  TextButton.styleFrom(backgroundColor: Colors.blue.shade900),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> logout() async {
    await TokenService.clearAllData();
    Get.offAllNamed('/login');
  }
}
