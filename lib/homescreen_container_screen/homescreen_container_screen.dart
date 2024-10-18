import 'package:flutter/material.dart';
import 'package:gasman4u/routes/app_routes.dart';
import 'package:gasman4u/views/cart/cart_screen.dart';
import 'package:gasman4u/views/home/home_screen.dart';
import 'package:gasman4u/views/order/fetch_orders.dart';
import 'package:gasman4u/views/profile/profile_screen.dart';
import 'package:gasman4u/views/wallet/wallet_screen.dart';
import 'package:get/get.dart';
import '../../widgets/custom_bottom_bar.dart';
import 'homescreen_container_controller.dart';
import 'package:flutter/services.dart';

class HomescreenContainerScreen extends StatelessWidget {
  HomescreenContainerScreen({super.key});

  final HomescreenContainerController controller =
      Get.put(HomescreenContainerController());

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
        body: Obx(() => _buildCurrentScreen()),
        bottomNavigationBar: Obx(() {
          return CustomBottomBar(
            selectedIndex: controller.selectedIndex.value,
            onChanged: (BottomBarEnum type) {
              controller.updateCurrentRoute(type);
            },
          );
        }),
      ),
    );
  }

  Widget _buildCurrentScreen() {
    switch (controller.currentRoute.value) {
      case AppRoutes.home:
        return HomeScreen();
      case AppRoutes.fetchOrders:
        return FetchOrdersScreen();
      case AppRoutes.walletScreen:
        return WalletScreen();
      case AppRoutes.cart:
        return CartScreen();
      case AppRoutes.profileScreen:
        return ProfileScreen();
      default:
        return const DefaultWidget();
    }
  }
}
