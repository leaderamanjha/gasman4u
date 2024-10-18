import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'custom_loader.dart'; // Make sure this points to your CustomLoader widget

class CustomLoaderService {
  static bool _isLoading = false;

  static void show() {
    if (!_isLoading) {
      _isLoading = true;
      Get.dialog(
        // ignore: deprecated_member_use
        WillPopScope(
          onWillPop: () async => false,
          child: Center(
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const CustomLoader(),
            ),
          ),
        ),
        barrierDismissible: false,
        barrierColor: Colors.orange.shade700.withOpacity(0.5),
      );
      // _isLoading = false;
    }
  }

  static void hide() {
    if (_isLoading) {
      _isLoading = false;
      Get.back();
    }
  }
}
