import 'dart:async';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:gasman4u/data/api_services/category_api_service.dart';
import 'package:gasman4u/routes/app_routes.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final CategoryApiService _categoryApiService = CategoryApiService();
  bool _hasInternet = true;

  @override
  void initState() {
    super.initState();
    _checkInternetAndProceed();
  }

  Future<bool> checkRealConnectivity() async {
    try {
      var connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult == ConnectivityResult.none) {
        return false;
      }
      final result = await InternetAddress.lookup('google.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      return false;
    }
  }

  Future<void> _checkInternetAndProceed() async {
    bool hasInternet = await checkRealConnectivity();
    setState(() {
      _hasInternet = hasInternet;
    });
    if (_hasInternet) {
      _fetchCategoriesAndNavigate();
    }
  }

  Future<void> _fetchCategoriesAndNavigate() async {
    try {
      await Future.delayed(Duration(seconds: 2));
      // ignore: unused_local_variable
      final categories = await _categoryApiService.getCategories();
      Get.offNamed(AppRoutes.homeContainer);
    } catch (e) {
      Get.offNamed(AppRoutes.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: _hasInternet
            ? Image.asset(
                'assets/images/gasmanlogo.png',
                width: 350,
                height: 350,
              )
            : _buildNoInternetWidget(),
      ),
    );
  }

  Widget _buildNoInternetWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.wifi_off,
          size: 80,
          color: Colors.black,
        ),
        SizedBox(height: 20),
        Text(
          "No Internet Connection",
          style: GoogleFonts.roboto(
            fontSize: 22,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: _checkInternetAndProceed,
          child: Text(
            'Try Again',
            style: GoogleFonts.roboto(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black,
            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
          ),
        ),
      ],
    );
  }
}
