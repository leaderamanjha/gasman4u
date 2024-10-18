import 'package:get/get.dart';
import 'package:gasman4u/data/api_services/order_api_services.dart';
import 'package:gasman4u/data/models/order/order_model.dart';
import 'dart:convert';

class OrderDetailsController extends GetxController {
  final OrderApiServices _orderApiServices = OrderApiServices();
  final Rx<OrderModel?> order = Rx<OrderModel?>(null);
  final RxBool isLoading = true.obs;
  final RxList<Map<String, dynamic>> products = <Map<String, dynamic>>[].obs;

  final String orderId;

  OrderDetailsController(this.orderId);

  @override
  void onInit() {
    super.onInit();
    fetchOrderDetails();
  }

  Future<void> fetchOrderDetails() async {
    try {
      isLoading.value = true;
      final fetchedOrder = await _orderApiServices.getOrderByOrderId(orderId);
      order.value = fetchedOrder;
      parseMetaData();
    } catch (e) {
      // Get.snackbar('Error', 'Failed to fetch order details: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void parseMetaData() {
    if (order.value?.metaData != null) {
      final List<dynamic> parsedData = json.decode(order.value!.metaData!);
      products.assignAll(parsedData.cast<Map<String, dynamic>>());
    }
  }
}
