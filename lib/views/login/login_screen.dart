import 'package:flutter/material.dart';
import 'package:gasman4u/controller/login_controller.dart';
import 'package:gasman4u/routes/app_routes.dart';
import 'package:get/get.dart';

class LoginScreen extends StatelessWidget {
  final LoginController controller = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

    return Scaffold(
      backgroundColor: Colors.blue.shade50,
      body: Stack(
        children: [
          // White background covering 75% of the screen
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: screenHeight * 0.75,
            child: Container(color: Colors.blue.shade50),
          ),

          // Orange gradient background covering 25% bottom part of the screen
          Positioned(
            top: screenHeight * 0.75,
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.orange.shade300, Colors.orange.shade900],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
              ),
            ),
          ),

          // Logo in the middle of the white background
          Positioned(
            top: screenHeight * 0.2,
            left: 0,
            right: 0,
            child: Center(
              child: Image.asset(
                'assets/images/gasmanlogo.png',
                height: 300,
                width: 300,
              ),
            ),
          ),

          // The Orange section contains mobile number input and button
          Positioned(
            top: screenHeight * 0.75 + 40 - keyboardHeight,
            left: 20,
            right: 20,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Mobile Number Input
                  TextField(
                    controller: controller.mobileNumberInputController,
                    keyboardType: TextInputType.phone,
                    maxLength: 10,
                    decoration: InputDecoration(
                      hintText: 'Enter your mobile number',
                      fillColor: Colors.white,
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                      counterText: '',
                    ),
                    onChanged: (value) {
                      controller.updateMobileNumber();
                      if (value.length == 10) {
                        FocusScope.of(context).unfocus();
                      }
                    },
                  ),
                  SizedBox(height: 20),

                  // Custom Elevated Button for Login/Signup
                  Obx(() => ElevatedButton(
                        onPressed: controller.isButtonActive.value
                            ? () async {
                                controller.isLoading.value = true;
                                await controller.sendOtp();
                                controller.isLoading.value = false;
                                Get.toNamed(AppRoutes.loginSignupScreen,
                                    arguments: {
                                      'mobileNumber':
                                          controller.mobileNumber.join(),
                                    });
                              }
                            : null,
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(screenWidth - 40, 50),
                          disabledBackgroundColor: Colors.blue.shade900,
                          backgroundColor: Colors.blue.shade900,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                        child: controller.isLoading.value
                            ? SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : Text(
                                'Login / Signup',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      )),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
