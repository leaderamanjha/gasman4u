// import 'package:gasman4u/custom_loader/custom_loader_service.dart';
import 'package:gasman4u/data/api_services/products_api_services.dart';
import 'package:gasman4u/data/api_services/cart_api_services.dart';
import 'package:gasman4u/data/models/products/products.dart';
import 'package:gasman4u/data/models/cart/cart_model.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ProductDetailsController extends GetxController {
  final ProductsApiServices _productsApiServices = ProductsApiServices();
  final CartApiServices _cartApiServices = CartApiServices();
  final Rx<Products?> product = Rx<Products?>(null);
  RxBool isLoading = true.obs;
  RxInt itemCount = 1.obs;
  RxInt cartQuantity = 0.obs;
  RxBool isInCart = false.obs;
  final num productId;

  ProductDetailsController(this.productId);

  @override
  void onInit() {
    super.onInit();
    fetchProductDetails();
  }

  Future<void> fetchProductDetails() async {
    try {
      product.value = await _productsApiServices.getProductById(productId);
      await checkIfInCart();
    } catch (e) {
      print('Error fetching product details: $e');
    } finally {
      isLoading(false);
    }
  }

  void incrementItemCount() {
    if (itemCount.value < 10) {
      itemCount.value++;
      if (isInCart.value) {
        updateCart();
      }
    }
  }

  void decrementItemCount() {
    if (itemCount.value > 1) {
      itemCount.value--;
      if (isInCart.value) {
        updateCart();
      }
    }
  }

  Future<void> addToCart() async {
    try {
      await _cartApiServices.addToCart(productId, itemCount.value);
      isInCart.value = true;
      cartQuantity.value = itemCount.value;
      showToast('Item added to cart');
    } catch (e) {
      print('Error adding to cart: $e');
      showToast('Failed to add item to cart');
    } finally {
      // CustomLoaderService.hide();
    }
  }

  Future<void> updateCart() async {
    try {
      // CustomLoaderService.show();
      await _cartApiServices.updateCart(productId, itemCount.value);
      cartQuantity.value = itemCount.value;
      showToast('Cart updated');
    } catch (e) {
      print('Error updating cart: $e');
      showToast('Failed to update cart');
    } finally {
      // CustomLoaderService.hide();
    }
  }

  Future<void> removeFromCart() async {
    try {
      // CustomLoaderService.show();
      await _cartApiServices.removeItem(productId);
      isInCart.value = false;
      cartQuantity.value = 0;
      itemCount.value = 1;
      showToast('Item removed from cart');
    } catch (e) {
      print('Error removing from cart: $e');
      showToast('Failed to remove item from cart');
    } finally {
      // CustomLoaderService.hide();
    }
  }

  Future<void> checkIfInCart() async {
    try {
      final List<CartModel> cartItems = await _cartApiServices.getCart();
      final cartItem = cartItems.where((item) => item.id == productId).toList();

      if (cartItem.isNotEmpty) {
        isInCart.value = true;
        cartQuantity.value = cartItem.first.productQuantity?.toInt() ?? 0;
        itemCount.value = cartQuantity.value;
      } else {
        isInCart.value = false;
        cartQuantity.value = 0;
        itemCount.value = 1;
      }
    } catch (e) {
      print('Error checking cart: $e');
      isInCart.value = false;
      cartQuantity.value = 0;
      itemCount.value = 1;
    }
  }

  void showToast(String message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.transparent,
        textColor: Colors.black,
        fontSize: 16.0);
  }

  bool get canAddToCart => !isInCart.value;
}
