import 'package:gasman4u/routes/app_routes.dart';
import 'package:gasman4u/widgets/custom_bottom_bar.dart';
import 'package:get/get.dart';

class HomescreenContainerController extends GetxController {
  RxString currentRoute = AppRoutes.home.obs;
  RxInt selectedIndex = 0.obs;

  void updateCurrentRoute(BottomBarEnum type) {
    switch (type) {
      case BottomBarEnum.home:
        currentRoute.value = AppRoutes.home;
        selectedIndex.value = 0;
        break;
      case BottomBarEnum.order:
        currentRoute.value = AppRoutes.fetchOrders;
        selectedIndex.value = 1;
        break;

      case BottomBarEnum.wallet:
        currentRoute.value = AppRoutes.walletScreen;
        selectedIndex.value = 2;
        break;
      case BottomBarEnum.cart:
        currentRoute.value = AppRoutes.cart;
        selectedIndex.value = 3;
        break;
      case BottomBarEnum.profile:
        currentRoute.value = AppRoutes.profileScreen;
        selectedIndex.value = 4;
        break;
    }
  }
}
