import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gasman4u/routes/app_routes.dart';
import 'package:gasman4u/views/profile/profile_controller.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileScreen extends StatelessWidget {
  final ProfileController controller = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Color.fromARGB(255, 246, 176, 71),
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.light,
        systemNavigationBarColor: Color.fromARGB(255, 13, 71, 161),
        systemNavigationBarIconBrightness: Brightness.light,
      ),
    );
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 246, 176, 71), // Updated color
          title: Text(
            "My Profile",
            style: GoogleFonts.roboto(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
        ),
        body: Column(
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color.fromARGB(255, 246, 176, 71), // Gradient start
                    Colors.orange.shade700, // Gradient end
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Column(
                children: [
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border:
                              Border.all(color: Colors.blue.shade900, width: 2),
                        ),
                        child: Obx(
                          () => CircleAvatar(
                            radius: 50,
                            backgroundColor: Colors.orange.shade600,
                            backgroundImage: controller
                                        .profileImageBase64.value !=
                                    null
                                ? MemoryImage(base64Decode(
                                    controller.profileImageBase64.value!))
                                : (controller.userInfo.value?.image != null
                                    ? NetworkImage(
                                        'https://gasman.litspark.cloud/storage/${controller.userInfo.value!.image}')
                                    : null),
                            child: (controller.profileImageBase64.value ==
                                        null &&
                                    controller.userInfo.value?.image == null)
                                ? Icon(Icons.person_rounded,
                                    size: 90, color: Colors.blue.shade900)
                                : null,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: controller.pickImage,
                        child: CircleAvatar(
                          radius: 15,
                          backgroundColor: Colors.blue.shade900,
                          child: Icon(Icons.edit,
                              size: 18, color: Colors.orange.shade300),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Obx(() => Text(
                        controller.userInfo.value?.name ?? 'Aman Jha',
                        style: GoogleFonts.roboto(
                          color: Colors.white, // Updated text color
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      )),
                  SizedBox(height: 5),
                  Obx(() => Text(
                        controller.userInfo.value?.email ?? 'aman1.gmail.com',
                        style: GoogleFonts.roboto(
                          color: Colors.white, // Updated text color
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                        ),
                      )),
                  SizedBox(height: 5),
                  Obx(() => Text(
                        controller.userInfo.value?.phone ?? '7992231165',
                        style: GoogleFonts.roboto(
                          color: Colors.white, // Updated text color
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                        ),
                      )),
                ],
              ),
            ),
            Expanded(
              child: ListView.separated(
                itemCount: controller.menuItems.length,
                separatorBuilder: (context, index) => Divider(
                  height: 1,
                  color: Colors.grey[300],
                ),
                itemBuilder: (context, index) {
                  final item = controller.menuItems[index];
                  return ListTile(
                    leading: Icon(item['icon'], color: Colors.blue.shade900),
                    title: Text(
                      item['title'],
                      style: GoogleFonts.roboto(
                        color: Colors.blue.shade900,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    trailing:
                        Icon(Icons.chevron_right, color: Colors.blue.shade900),
                    onTap: () {
                      if (item['title'] == 'Logout') {
                        controller.showLogoutConfirmation(context);
                      }
                      if (item['title'] == 'Saved Address') {
                        Get.toNamed(AppRoutes.savedAddressScreen);
                      }
                      // Handle other menu item taps
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
