import 'package:get/get.dart';
import 'package:gasman4u/data/api_services/cart_api_services.dart';
import 'package:gasman4u/data/models/cart/cart_model.dart';

class CartController extends GetxController {
  final CartApiServices _cartApiServices = CartApiServices();
  RxList<CartModel> cartItems = <CartModel>[].obs;
  RxBool isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchCartItems();
  }

  void dataClear() {
    cartItems.clear();
  }

  Future<void> fetchCartItems() async {
    try {
      isLoading(true);
      cartItems.value = await _cartApiServices.getCart();
    } catch (e) {
      print('Error fetching cart items: $e');
    } finally {
      isLoading(false);
    }
  }

  Future<void> incrementItemCount(CartModel item) async {
    try {
      isLoading(true);
      await _cartApiServices.updateCart(
          item.id!, (item.productQuantity! + 1).toInt());
      await fetchCartItems();
    } catch (e) {
      print('Error incrementing item count: $e');
    } finally {
      isLoading(false);
    }
  }

  Future<void> decrementItemCount(CartModel item) async {
    if (item.productQuantity! > 1) {
      try {
        isLoading(true);
        await _cartApiServices.updateCart(
            item.id!, (item.productQuantity! - 1).toInt());
        await fetchCartItems();
      } catch (e) {
        print('Error decrementing item count: $e');
      } finally {
        isLoading(false);
      }
    }
  }

  Future<void> removeFromCart(CartModel item) async {
    try {
      isLoading(true);
      await _cartApiServices.removeItem(item.id!);
      await fetchCartItems();
    } catch (e) {
      print('Error removing item from cart: $e');
    } finally {
      isLoading(false);
    }
  }
}
