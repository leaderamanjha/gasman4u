import 'package:get/get.dart';
import 'package:gasman4u/data/api_services/order_api_services.dart';
import 'package:gasman4u/data/models/order/order_model.dart';

class FetchOrdersController extends GetxController {
  final OrderApiServices _orderApiServices = OrderApiServices();
  final RxList<OrderModel> orders = <OrderModel>[].obs;
  final RxBool isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchOrders();
  }

  Future<void> fetchOrders() async {
    try {
      isLoading.value = true;
      final fetchedOrders = await _orderApiServices.getOrders();
      orders.assignAll(fetchedOrders);
    } catch (e) {
      // Get.snackbar('Error', 'Failed to fetch orders: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void navigateToOrderDetails(String orderId) {
    Get.toNamed('/order-details', arguments: orderId);
  }
}
