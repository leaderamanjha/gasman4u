import 'package:flutter/material.dart';
import 'package:gasman4u/controller/login_controller.dart';
import 'package:gasman4u/core/utils/size_utils.dart';
import 'package:gasman4u/routes/app_routes.dart';
import 'package:gasman4u/views/login/otp_input_widget.dart';
import 'package:gasman4u/widgets/custom_outlined_button.dart';
import 'package:gasman4u/widgets/custom_text_form_field.dart';
import 'package:get/get.dart';

import 'package:google_fonts/google_fonts.dart';

class LoginSignupScreen extends StatelessWidget {
  final String mobileNumber;

  LoginSignupScreen({super.key, required this.mobileNumber});

  final LoginController controller = Get.put(LoginController());
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    controller.mobileNumberInputController.text = mobileNumber;

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.blue.shade50,
        resizeToAvoidBottomInset: false,
        body: Form(
          key: _formKey,
          child: Container(
            width: double.maxFinite,
            padding: EdgeInsets.only(
              left: 34.h,
              top: 40.v,
              right: 34.h,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Image.asset(
                    'assets/images/gasmanlogo.png',
                    height: 230,
                    width: 230,
                  ),
                ),
                SizedBox(height: 25.v),
                Obx(() {
                  if (controller.statusCode.value == 200) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(children: [
                          Text(
                            "We have sent OTP to   ",
                            style: GoogleFonts.roboto(
                              fontSize: 16,
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 10.v),
                          Text(
                            mobileNumber,
                            style: GoogleFonts.inter(
                              fontSize: 16,
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ]),
                        SizedBox(height: 30.v),
                        Center(
                          child: Text(
                            "Enter OTP",
                            style: GoogleFonts.roboto(
                              fontSize: 16,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        SizedBox(height: 10.v),
                        OtpInputWidget(
                          onOtpChanged: (String otp) {
                            controller.otpInputController.value = otp;
                            controller.otpLength.value = otp.length;
                            controller.messageText.value = "";
                            if (otp.length == 4) {
                              _attemptLogin();
                            }
                          },
                        ),
                        SizedBox(height: 10.v),
                        _buildMessageText(),
                        SizedBox(height: 10.v),
                        _buildOtpButton(),
                        SizedBox(height: 10.v),
                      ],
                    );
                  } else if (controller.statusCode.value == 400) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 10.v),
                        _buildSignupForm(),
                        SizedBox(height: 10.v),
                        _buildErrorMessage(),
                        SizedBox(height: 10.v),
                        _buildSignupButton(),
                      ],
                    );
                  } else {
                    return Container();
                  }
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _attemptLogin() async {
    if (_formKey.currentState!.validate()) {
      await controller.login();
      if (controller.loginStaus.value == 200) {
        Get.offAllNamed(AppRoutes.homeContainer);
      }
    }
  }

  // Widget _buildLoadingIndicator() {
  //   return Obx(() {
  //     if (controller.otpLength.value == 4) {
  //       return Center(child: CircularProgressIndicator());
  //     } else {
  //       return SizedBox.shrink();
  //     }
  //   });
  // }

  TextStyle? createStyle(Color color) {
    return Get.textTheme.headlineLarge?.copyWith(color: color);
  }

  Widget _buildLoginButtonOrGif() {
    return Obx(() {
      if (controller.otpLength.value == 4) {
        return _buildLoginButton();
      } else {
        return Center(
            // child: Image.asset(
            //   'assets/images/gasman.gif',
            //   height: 200, // Adjust as needed
            //   width: 200,
            //   fit: BoxFit.cover,
            // ),
            );
      }
    });
  }

  Widget _buildLoginButton() {
    return CustomOutlinedButton(
      text: "Login",
      margin: EdgeInsets.only(left: 8.h),
      onPressed: () async {
        if (_formKey.currentState!.validate()) {
          await controller.login();
          if (controller.loginStaus.value == 200) {
            Get.offAllNamed(AppRoutes.homeContainer);
          } else {}
        }
      },
    );
  }

  Widget _buildOtpButton() {
    return Obx(() {
      return TextButton(
        onPressed: controller.isButtonEnabled.value
            ? () {
                controller.sendOtp();
                controller.startTimer();
              }
            : null,
        child: Text(controller.isButtonEnabled.value
            ? "Resend OTP"
            : "Resend OTP in ${controller.start.value} seconds"),
      );
    });
  }

  Widget _buildSignupForm() {
    return Container(
      width: double.maxFinite,
      margin: EdgeInsets.only(left: 8.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 4.h),
            child: Text(
              "Name".tr,
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
            ),
          ),
          SizedBox(height: 4.v),
          CustomTextFormField(
            controller: controller.nameInputController,
            hintText: "Enter your name",
            textInputType: TextInputType.text,
            height: 45.0,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your name';
              }
              if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value)) {
                return 'Name can only contain letters';
              }
              return null;
            },
          ),
          SizedBox(height: 10.v),
          Padding(
            padding: EdgeInsets.only(left: 4.h),
            child: Text(
              "Email".tr,
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
            ),
          ),
          SizedBox(height: 4.v),
          CustomTextFormField(
            controller: controller.emailInputController,
            hintText: "Enter your email address",
            textInputType: TextInputType.emailAddress,
            height: 45.0,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your email address';
              }
              if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                return 'Please enter a valid email address';
              }
              return null;
            },
          ),
          SizedBox(height: 10.v),
          Padding(
            padding: EdgeInsets.only(left: 4.h),
            child: Text(
              "Mobile Number",
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
            ),
          ),
          SizedBox(height: 4.v),
          _buildMobileNumberInput(),
        ],
      ),
    );
  }

  Widget _buildMobileNumberInput() {
    return CustomTextFormField(
      controller: controller.mobileNumberInputController,
      hintText: "msg_enter_mobile_number".tr,
      textInputType: TextInputType.phone,
      readOnly: true,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter mobile number';
        }
        if (!RegExp(r'^\d{10}$').hasMatch(value)) {
          return 'Mobile number must be 10 digits';
        }
        return null;
      },
      suffix: TextButton(
        onPressed: () => Get.back(),
        child: const Text("Edit"),
      ),
    );
  }

  Widget _buildErrorMessage() {
    return Obx(() {
      return controller.errorMessage.value.isNotEmpty
          ? Padding(
              padding: EdgeInsets.only(left: 8.h),
              child: Text(
                controller.errorMessage.value,
                style: const TextStyle(color: Colors.red),
              ),
            )
          : Container();
    });
  }

  Widget _buildSignupButton() {
    return CustomOutlinedButton(
      text: "Signup",
      margin: EdgeInsets.only(left: 8.h),
      onPressed: () async {
        if (_formKey.currentState!.validate()) {
          await controller.signup();
          await controller.sendOtp();
          if (controller.statusCode.value == 200) {
            Get.toNamed(AppRoutes.loginSignupScreen, arguments: {
              'mobileNumber': mobileNumber,
              'statusCode': controller.statusCode.value
            });
          }
        }
      },
    );
  }

  Widget _buildMessageText() {
    return Obx(() => controller.messageText.value.isNotEmpty
        ? Padding(
            padding: EdgeInsets.only(top: 8.v, bottom: 8.v),
            child: Text(
              controller.messageText.value,
              style: TextStyle(
                color: controller.messageText.value == "Login Successful"
                    ? Colors.green
                    : Colors.red,
                fontSize: 14,
              ),
            ),
          )
        : SizedBox.shrink());
  }
}
