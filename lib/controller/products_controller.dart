import 'package:gasman4u/data/api_services/products_api_services.dart';
import 'package:gasman4u/data/models/products/products.dart';
import 'package:get/get.dart';

class ProductsController extends GetxController {
  final ProductsApiServices _productsApiServices = ProductsApiServices();
  RxList<Products> products = <Products>[].obs;
  RxBool isLoading = true.obs;

  Future<void> fetchServicesByCategory(num categoryId) async {
    try {
      isLoading(true);
      products.value =
          await _productsApiServices.getServicesByCategory(categoryId);
    } catch (e) {
      print('Error fetching services: $e');
    } finally {
      isLoading(false);
    }
  }
}
