import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gasman4u/routes/app_routes.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';
import 'package:gasman4u/controller/cart_controller.dart';
import 'package:gasman4u/data/models/cart/cart_model.dart';

class CartScreen extends StatefulWidget {
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final CartController controller = Get.put(CartController());

  @override
  void initState() {
    super.initState();
    controller.fetchCartItems();
  }

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
        appBar: _buildAppBar(),
        body: Obx(() {
          if (controller.isLoading.value) {
            return _buildShimmerEffect();
          } else if (controller.cartItems.isEmpty) {
            return _buildEmptyCart();
          } else {
            return _buildCartList();
          }
        }),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      toolbarHeight: 48,
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color.fromARGB(255, 246, 176, 71), Colors.orange],
          ),
        ),
      ),
      title: Center(
        child: Text(
          "Cart",
          style: GoogleFonts.roboto(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildShimmerEffect() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: ListView.builder(
        itemCount: 5,
        itemBuilder: (_, __) => Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 110,
                height: 140,
                color: Colors.white,
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      width: double.infinity,
                      height: 8.0,
                      color: Colors.white,
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 2.0),
                    ),
                    Container(
                      width: double.infinity,
                      height: 8.0,
                      color: Colors.white,
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 2.0),
                    ),
                    Container(
                      width: 40.0,
                      height: 8.0,
                      color: Colors.white,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyCart() {
    return const Center(
      child: Text(
        "Your cart is empty",
        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
      ),
    );
  }

  Widget _buildCartList() {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: controller.cartItems.length,
            itemBuilder: (context, index) {
              return _buildCartItem(context, controller.cartItems[index]);
            },
          ),
        ),
        _buildProceedButton(),
      ],
    );
  }

  Widget _buildCartItem(BuildContext context, CartModel item) {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: InkWell(
        onTap: () =>
            Get.toNamed(AppRoutes.productDetailsScreen, arguments: item.id),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 1.0),
          child: Row(
            children: [
              Image.network(
                item.image ?? '',
                width: 110,
                height: 140,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.error),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.name ?? "",
                      style: GoogleFonts.poppins(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      item.description ?? "",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.inter(
                        color: Colors.blueGrey,
                        fontSize: 12,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildPriceRow(
                        "Total Deposit : ",
                        item.securityDeposit?.toDouble() ?? 0,
                        item.productQuantity?.toInt() ?? 1),
                    const SizedBox(height: 8),
                    _buildPriceRow(
                        "Total Price : ",
                        item.price?.toDouble() ?? 0,
                        item.productQuantity?.toInt() ?? 1),
                  ],
                ),
              ),
              _buildQuantityControls(item),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPriceRow(String label, double price, int quantity) {
    return Row(
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            color: Colors.black,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          "₹${(price * quantity).toStringAsFixed(2)}",
          style: GoogleFonts.poppins(
            color: Colors.green,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildQuantityControls(CartModel item) {
    return Column(
      children: [
        IconButton(
          icon: const Icon(Icons.add_circle_outline),
          onPressed: () => controller.incrementItemCount(item),
        ),
        Text(
          '${item.productQuantity}',
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        IconButton(
          icon: const Icon(Icons.remove_circle_outline),
          onPressed: () => controller.decrementItemCount(item),
        ),
        IconButton(
          icon: const Icon(
            Icons.delete_outline,
            color: Colors.red,
          ),
          onPressed: () => _showDeleteConfirmation(Get.context!, item),
        ),
      ],
    );
  }

  Widget _buildProceedButton() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: ElevatedButton(
        onPressed: () => Get.toNamed(AppRoutes.selectAddressScreen),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.orange.shade700,
          padding: const EdgeInsets.symmetric(vertical: 12),
        ),
        child: const Text(
          'Proceed Order',
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, CartModel item) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Remove Item"),
          content: const Text(
              "Are you sure you want to remove this item from cart?"),
          actions: <Widget>[
            TextButton(
              child: const Text("No"),
              onPressed: () => Get.back(),
            ),
            TextButton(
              child: const Text("Yes"),
              onPressed: () {
                controller.removeFromCart(item);
                controller.dataClear();
                controller.fetchCartItems();
                Get.back();
              },
            ),
          ],
        );
      },
    );
  }
}
