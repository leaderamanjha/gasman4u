// import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:gasman4u/core/utils/permission_handler.dart';
import 'package:gasman4u/custom_loader/custom_loader_service.dart';
import 'package:gasman4u/data/api_services/login_api_service.dart';
import 'package:gasman4u/data/api_services/token_service.dart';
import 'package:gasman4u/data/models/login/data_model.dart';
import 'package:gasman4u/data/models/login/login_model.dart';
import 'package:gasman4u/data/models/login/otp_model.dart';
import 'package:gasman4u/routes/app_routes.dart';
import 'package:get/get.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class LoginController extends GetxController {
  Future<void> requestPermissions() async {
    Map<Permission, bool> permissionStatuses =
        await PermissionHandler.requestAllPermissions();

    if (!permissionStatuses[Permission.location]!) {
      Get.snackbar('Permission Denied',
          'Location permission is required for this app to function properly.');
    }

    // if (!permissionStatuses[Permission.microphone]!) {
    //   Get.snackbar('Permission Denied',
    //       'Microphone permission is required for voice search functionality.');
    // }
  }

  var mobileNumber = <String>[].obs; // Mobile number stored as a list of digits
  var isButtonActive = false.obs; // Button activation state
  var mobileNumberInputController = TextEditingController();
  var otpInputController = ''.obs;
  var nameInputController = TextEditingController();
  var emailInputController = TextEditingController();
  var statusCode = 0.obs;
  var loginStaus = 0.obs;
  var message = "".obs;
  var responseData = "".obs;
  var isButtonEnabled = true.obs;
  var errorMessage = "".obs;
  var start = 60.obs;
  var otpResponse = Rx<OtpModel?>(null);
  var data = Rx<Data?>(null);
  var userData = Rx<LoginModel?>(null);
  var isMobileNumberValid = false.obs;
  var otpLength = 0.obs;
  var messageText = "".obs;
  var fcmToken = 'abcdefghi'.obs;
  final isLoading = false.obs;
  final screenOffset = 0.0.obs;

  final LoginApiService apiService = LoginApiService();
  final TokenService tokenService = TokenService();

  @override
  void onInit() {
    super.onInit();
    requestPermissions();
    mobileNumberInputController.addListener(validateMobileNumber);
    // getFcmToken();
  }

  // Future<void> getFcmToken() async {
  //   try {
  //     String? token = await FirebaseMessaging.instance.getToken();
  //     if (token != null) {
  //       fcmToken.value = token;
  //     }
  //   } catch (e) {
  //     print("Error getting FCM token: $e");
  //   }
  // }
  // Updates the mobileNumber list based on the input controller's value
  // Updates the mobileNumber list based on the input controller's value

  // Updates the mobileNumber list based on the input controller's value
  void updateMobileNumber() {
    final text = mobileNumberInputController.text;
    if (text.length <= 10) {
      mobileNumber.value = text.split('');
    }
    validateMobileNumber();
  }

  // Validates if the entered mobile number is valid (10 digits)
  void validateMobileNumber() {
    if (mobileNumber.length == 10) {
      isButtonActive.value = true; // Enable button
    } else {
      isButtonActive.value = false; // Disable button
    }
  }

  // Function for handling navigation on button press
  Future<void> onLoginSignupPressed() async {
    if (isButtonActive.value) {
      await sendOtp();
      Get.toNamed(AppRoutes.loginSignupScreen, arguments: {
        'mobileNumber': mobileNumber.join(),
      });
    }
  }

  Future<void> sendOtp() async {
    try {
      final OtpModel response =
          await apiService.sendOtp(mobileNumberInputController.text);
      otpResponse.value = response;
      statusCode.value = response.code != null ? response.code!.toInt() : 0;
      message.value = response.message ?? '';
      responseData.value = response.data ?? '';
      if (statusCode.value == 200) {
        // _showSnackBar("OTP Sent Successfully", true);
      }
    } catch (e) {
      // _showSnackBar("Failed to send OTP", false);
    }
  }

  void startTimer() {
    isButtonEnabled.value = false;
    start.value = 60;
    const oneSec = Duration(seconds: 1);
    Timer.periodic(oneSec, (Timer timer) {
      if (start.value == 0) {
        timer.cancel();
        isButtonEnabled.value = true;
      } else {
        start.value--;
      }
    });
  }

  Future<void> login() async {
    if (_validateLoginForm()) {
      try {
        // CustomLoaderService.show();
        LoginModel loginResponse = await apiService.login(
          mobileNumberInputController.text,
          otpInputController.value,
          fcmToken.value,
        );
        userData.value = loginResponse;
        loginStaus.value =
            loginResponse.code != null ? loginResponse.code!.toInt() : 0;
        message.value = loginResponse.message ?? '';
        data.value = (loginResponse.data ?? '') as Data?;
        CustomLoaderService.hide();
        if (loginStaus.value == 200) {
          // CustomLoaderService.hide();
          await TokenService.saveToken(loginResponse.data!.token!);
          messageText.value = "Login Successful";
        } else {
          // CustomLoaderService.hide();
          messageText.value = "Invalid OTP";
        }
      } catch (e) {
        // CustomLoaderService.hide();
        messageText.value = "Invalid otp, try again";
        // CustomLoaderService.hide();
      } finally {
        // CustomLoaderService.hide();
      }
    }
  }

  Future<void> signup() async {
    if (_validateSignupForm()) {
      try {
        final OtpModel registerResponse = await apiService.signup(
            nameInputController.text,
            emailInputController.text,
            mobileNumberInputController.text);
        otpResponse.value = registerResponse;
        statusCode.value =
            registerResponse.code != null ? registerResponse.code!.toInt() : 0;
        message.value = registerResponse.message ?? '';
        responseData.value = registerResponse.data ?? '';
        // _showSnackBar("Account Created Successfully", statusCode.value == 200);
      } catch (e) {
        errorMessage.value = "Signup failed, try again";
        // _showSnackBar(errorMessage.value, false);
      }
    }
  }

  bool _validateLoginForm() {
    if (mobileNumberInputController.text.isEmpty) {
      errorMessage.value = 'Please enter mobile number';
      return false;
    }
    if (otpInputController.value.isEmpty) {
      errorMessage.value = 'Please enter OTP';
      return false;
    }
    if (!RegExp(r'^\d{4}$').hasMatch(otpInputController.value)) {
      errorMessage.value = 'OTP must be a 4 digit number';
      return false;
    }
    errorMessage.value = '';
    return true;
  }

  bool _validateSignupForm() {
    if (nameInputController.text.isEmpty) {
      errorMessage.value = 'Please enter your name';
      return false;
    }
    if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(nameInputController.text)) {
      errorMessage.value = 'Name can only contain letters';
      return false;
    }
    if (emailInputController.text.isEmpty) {
      errorMessage.value = 'Please enter your email address';
      return false;
    }
    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(emailInputController.text)) {
      errorMessage.value = 'Please enter a valid email address';
      return false;
    }
    if (mobileNumberInputController.text.isEmpty) {
      errorMessage.value = 'Please enter mobile number';
      return false;
    }
    if (!RegExp(r'^\d{10}$').hasMatch(mobileNumberInputController.text)) {
      errorMessage.value = 'Mobile number must be 10 digits';
      return false;
    }
    errorMessage.value = '';
    return true;
  }

  void _showLoader() {
    Get.dialog(
      const Center(child: CircularProgressIndicator()),
      barrierDismissible: false,
    );
  }

  void _hideLoader() {
    if (Get.isDialogOpen!) {
      Get.back();
    }
  }

  void _showSnackBar(String message, bool isSuccess) {
    CustomLoaderService.hide();
    Get.snackbar(
      isSuccess ? 'Success' : 'Error',
      message,
      backgroundColor: isSuccess ? Colors.green : Colors.red,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
      duration: const Duration(seconds: 3),
    );
  }

  void clear() {
    CustomLoaderService.hide();
    errorMessage = "".obs;
    statusCode = 0.obs;
    nameInputController.clear();
    emailInputController.clear();
    message = "".obs;
    responseData = "".obs;
    isButtonEnabled = true.obs;
    otpInputController.value = '';
    otpLength.value = 0;
  }
}
