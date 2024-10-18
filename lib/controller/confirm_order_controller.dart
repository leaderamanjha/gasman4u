import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:gasman4u/data/api_services/order_api_services.dart';
import 'package:gasman4u/data/models/order/order_model.dart';

class ConfirmOrderController extends GetxController {
  final OrderApiServices _orderApiServices = OrderApiServices();
  final Rx<OrderModel> order = OrderModel().obs;
  final RxInt selectedPaymentTypeId = 1.obs;

  @override
  void onInit() {
    super.onInit();
    order.value = Get.arguments as OrderModel;
  }

  void showConfirmationDialog() {
    Get.dialog(
      AlertDialog(
        title: Text("Confirm Order"),
        content: Text("Are you sure you want to place this order?"),
        actions: [
          TextButton(
            child: Text("No"),
            onPressed: () => Get.back(),
          ),
          TextButton(
            child: Text("Yes"),
            onPressed: () {
              Get.back();
              confirmOrder();
            },
          ),
        ],
      ),
    );
  }

  Future<void> confirmOrder() async {
    try {
      await _orderApiServices.updateOrderPayment(
        orderId: order.value.orderId ?? '',
        paymentTypeId: selectedPaymentTypeId.value,
        transactionId: getTransactionId(),
      );
      Get.offAllNamed('thankyouScreen');
      showToast('Order placed successfully');
    } catch (e) {
      showToast('Failed to place order');
    }
  }

  String getTransactionId() {
    switch (selectedPaymentTypeId.value) {
      case 1:
        return 'COD';
      case 2:
        return 'Online';
      case 3:
        return 'Wallet';
      default:
        return '';
    }
  }

  void showToast(String message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.orange.shade700,
        textColor: Colors.white,
        fontSize: 16.0);
  }
}
