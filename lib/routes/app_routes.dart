import 'package:gasman4u/data/models/home/home_categories_model.dart';
import 'package:gasman4u/homescreen_container_screen/homescreen_container_screen.dart';
import 'package:gasman4u/views/address/add_address_screen.dart';
import 'package:gasman4u/views/address/saved_address_screen.dart';
import 'package:gasman4u/views/address/select_address.dart';
import 'package:gasman4u/views/cart/cart_screen.dart';
import 'package:gasman4u/views/home/home_screen.dart';
import 'package:gasman4u/views/login/login_screen.dart';
import 'package:gasman4u/views/login/login_signup_screen.dart';
import 'package:gasman4u/views/order/confirm_order.dart';
import 'package:gasman4u/views/order/fetch_orders.dart';
import 'package:gasman4u/views/order/order_details.dart';
import 'package:gasman4u/views/order/thankyou_screen.dart';
import 'package:gasman4u/views/product_details/product_details_screen.dart';
import 'package:gasman4u/views/products/products_screen.dart';
import 'package:gasman4u/views/profile/profile_screen.dart';
import 'package:gasman4u/views/splash_screen/splash_screen.dart';
import 'package:gasman4u/views/wallet/wallet_screen.dart';
import 'package:get/get.dart';

class AppRoutes {
  static String get initialRoute => splash;
  static const String splash = '/splash';
  static const String login = '/login';
  static const String loginSignupScreen = '/login_Signup_screen';
  static const String homeContainer = '/home-container';
  static const String home = '/home';
  static const String productScreen = '/product-screen';
  static const String productDetailsScreen = '/product-details-screen';
  static const String cart = '/cart';
  static const String payment = '/payment';
  static const String thankyouScreen = '/thankyouScreen';
  static const String profileScreen = '/profile-screen';
  static const String savedAddressScreen = '/address-screen';
  static const String addAddressScreen = '/add-address-screen';
  static const String selectAddressScreen = '/select-address-screen';
  static const String confirmOrderScreen = '/confirm-order';
  static const String fetchOrders = '/fetch-orders';
  static const String orderDetails = '/order-details';
  static const String walletScreen = '/wallet-screen';

  static List<GetPage> get pages => [
        //splash_screen
        GetPage(name: splash, page: () => SplashScreen()),
        //login_screen
        GetPage(
          name: login,
          page: () => LoginScreen(),
          transition: Transition.leftToRight,
        ),
        //login_signup_screen
        GetPage(
          name: loginSignupScreen,
          page: () =>
              LoginSignupScreen(mobileNumber: Get.arguments['mobileNumber']),
          transition: Transition.leftToRight,
        ),
        //home_container
        GetPage(
          name: homeContainer,
          page: () => HomescreenContainerScreen(),
          transition: Transition.rightToLeft,
        ),
        //home_screen
        GetPage(
          name: home,
          page: () => HomeScreen(),
          transition: Transition.rightToLeft,
        ),
        //product_screen
        GetPage(
          name: productScreen,
          page: () {
            final Categories category = Get.arguments as Categories;
            return ProductsScreen(category: category);
          },
          transition: Transition.rightToLeft,
        ),
        //product_details_screen
        GetPage(
          name: productDetailsScreen,
          page: () {
            final num productId = Get.arguments as num;
            return ProductDetailsScreen(productId: productId);
          },
          transition: Transition.rightToLeft,
        ),
        GetPage(
          name: cart,
          page: () => CartScreen(),
          transition: Transition.downToUp,
        ),
        //Profile
        GetPage(
          name: profileScreen,
          page: () => ProfileScreen(),
          transition: Transition.rightToLeft,
        ),
        //wallet screen
        GetPage(
          name: walletScreen,
          page: () => WalletScreen(),
          transition: Transition.rightToLeft,
        ),
        //savedaddress
        GetPage(
          name: savedAddressScreen,
          page: () => SavedAddressScreen(),
          transition: Transition.rightToLeft,
        ),
        GetPage(
          name: selectAddressScreen,
          page: () => SelectAddressScreen(),
          transition: Transition.rightToLeft,
        ),
        GetPage(
          name: addAddressScreen,
          page: () => AddAddressScreen(),
          transition: Transition.rightToLeft,
        ),
        GetPage(
          name: confirmOrderScreen,
          page: () => ConfirmOrderScreen(),
          transition: Transition.rightToLeft,
        ),
        GetPage(
          name: thankyouScreen,
          page: () => ThankYouScreen(),
          transition: Transition.leftToRight,
        ),

        GetPage(
          name: fetchOrders,
          page: () => FetchOrdersScreen(),
          transition: Transition.leftToRight,
        ),
        GetPage(
          name: orderDetails,
          transition: Transition.leftToRight,
          page: () {
            final String productId = Get.arguments;
            return OrderDetailsScreen(orderId: productId);
          },
        ),
      ];
}
