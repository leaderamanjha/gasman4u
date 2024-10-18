import 'package:flutter/material.dart';
import 'package:gasman4u/controller/product_details_controller.dart';
import 'package:gasman4u/controller/home_screen_controller.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'dart:io';
import 'package:gasman4u/routes/app_routes.dart';

class ProductDetailsScreen extends StatefulWidget {
  final num productId;

  const ProductDetailsScreen({Key? key, required this.productId})
      : super(key: key);

  @override
  _ProductDetailsScreenState createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  late ProductDetailsController controller;
  final HomeScreenController homeController = Get.find<HomeScreenController>();
  bool _hasInternet = true;

  @override
  void initState() {
    super.initState();
    controller = Get.put(ProductDetailsController(widget.productId));
    _initializeScreen();
  }

  Future<void> _initializeScreen() async {
    bool hasInternet = await checkRealConnectivity();
    setState(() {
      _hasInternet = hasInternet;
    });
    if (_hasInternet) {
      await controller.fetchProductDetails();
      await homeController.fetchCartItems();
    }
  }

  Future<bool> checkRealConnectivity() async {
    try {
      var connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult == ConnectivityResult.none) {
        return false;
      }
      final result = await InternetAddress.lookup('google.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      return false;
    }
  }

  Future<void> _handleRefresh() async {
    bool hasInternet = await checkRealConnectivity();
    setState(() {
      _hasInternet = hasInternet;
    });
    if (_hasInternet) {
      await controller.fetchProductDetails();
      await homeController.fetchCartItems();
    } else {
      Get.snackbar(
        'No Internet',
        'Please check your internet connection',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 48,
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color.fromARGB(255, 246, 176, 71),
                  Colors.orange.shade700
                ],
              ),
            ),
          ),
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: Colors.white),
            onPressed: () => Get.back(),
          ),
          title: Text(
            'Product Details',
            style: GoogleFonts.inter(
                color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ),
        body: RefreshIndicator(
          onRefresh: _handleRefresh,
          child: Stack(
            children: [
              Obx(() {
                if (controller.isLoading.value) {
                  return ShimmerLoading();
                } else if (controller.product.value == null) {
                  return Center(child: Text('Product not found'));
                } else {
                  return ProductDetailsContent(
                    controller: controller,
                    onCartUpdated: () => homeController.fetchCartItems(),
                    homeController: homeController,
                  );
                }
              }),
              _buildFloatingCartButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFloatingCartButton() {
    return Obx(() {
      final cartItemCount = homeController.cartItems.length;
      if (cartItemCount == 0) return const SizedBox.shrink();

      return Positioned(
        left: 110,
        bottom: 20,
        child: FloatingActionButton.extended(
          backgroundColor: Colors.blue.shade900,
          onPressed: () {
            if (!_hasInternet) {
              Get.snackbar(
                'No Internet',
                'Please check your internet connection',
                snackPosition: SnackPosition.BOTTOM,
              );
              return;
            }
            Get.toNamed(AppRoutes.cart);
          },
          label: Row(
            children: [
              SizedBox(
                width: cartItemCount > 1 ? 60 : 40,
                height: 40,
                child: Stack(
                  children: [
                    if (homeController.cartItems.isNotEmpty)
                      Positioned(
                        left: 0,
                        child: CircleAvatar(
                          backgroundColor: Colors.white,
                          radius: 20,
                          backgroundImage: NetworkImage(
                            homeController.cartItems[0].image ?? '',
                          ),
                        ),
                      ),
                    if (cartItemCount > 1)
                      Positioned(
                        left: 20,
                        child: CircleAvatar(
                          backgroundColor: Colors.white,
                          radius: 20,
                          backgroundImage: NetworkImage(
                            homeController.cartItems[1].image ?? '',
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'View Cart\n$cartItemCount Items',
                style: GoogleFonts.roboto(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      );
    });
  }
}

class ShimmerLoading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              height: 200,
              color: Colors.white,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 200,
                    height: 24,
                    color: Colors.white,
                  ),
                  SizedBox(height: 16),
                  Container(
                    width: double.infinity,
                    height: 100,
                    color: Colors.white,
                  ),
                  SizedBox(height: 16),
                  Container(
                    width: 150,
                    height: 20,
                    color: Colors.white,
                  ),
                  SizedBox(height: 8),
                  Container(
                    width: 100,
                    height: 20,
                    color: Colors.white,
                  ),
                  SizedBox(height: 16),
                  Container(
                    width: double.infinity,
                    height: 50,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProductDetailsContent extends StatelessWidget {
  final ProductDetailsController controller;
  final HomeScreenController homeController;
  final VoidCallback onCartUpdated;

  const ProductDetailsContent({
    Key? key,
    required this.controller,
    required this.onCartUpdated,
    required this.homeController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final product = controller.product.value!;
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.network(
            product.image ?? '',
            width: double.infinity,
            height: 200,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) =>
                Icon(Icons.error, size: 200),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    product.name ?? '',
                    style: GoogleFonts.poppins(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  product.description ?? '',
                  style: GoogleFonts.inter(fontSize: 14, color: Colors.black87),
                ),
                SizedBox(height: 16),
                Row(
                  children: [
                    Text("Security Deposit: ",
                        style: GoogleFonts.poppins(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w500)),
                    Text("₹${product.securityDeposit}",
                        style: GoogleFonts.poppins(
                            color: Colors.green,
                            fontSize: 16,
                            fontWeight: FontWeight.w500)),
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Text("Price : ",
                        style: GoogleFonts.poppins(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w500)),
                    Text("₹${product.price}",
                        style: GoogleFonts.poppins(
                            color: Colors.green,
                            fontSize: 16,
                            fontWeight: FontWeight.w500)),
                  ],
                ),
                SizedBox(height: 16),
                Obx(() => Row(
                      children: [
                        IconButton(
                          icon: Icon(
                            Icons.remove,
                            color: Colors.blue.shade900,
                          ),
                          onPressed: controller.decrementItemCount,
                        ),
                        Text(
                          '${controller.itemCount.value}',
                          style: GoogleFonts.poppins(
                              fontSize: 16,
                              color: Colors.blue.shade900,
                              fontWeight: FontWeight.bold),
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.add,
                            color: Colors.blue.shade900,
                          ),
                          onPressed: controller.incrementItemCount,
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: ElevatedButton.icon(
                            icon:
                                Icon(Icons.shopping_cart, color: Colors.white),
                            label: Text(
                              controller.isInCart.value
                                  ? 'Added to Cart'
                                  : 'Add to Cart',
                              style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                            style: ElevatedButton.styleFrom(
                              disabledBackgroundColor: Colors.orange.shade700,
                              backgroundColor: Colors.blue.shade900,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                            ),
                            onPressed: controller.canAddToCart
                                ? () {
                                    controller.addToCart();
                                    homeController.fetchCartItems();
                                    onCartUpdated();
                                  }
                                : null,
                          ),
                        ),
                        if (controller.isInCart.value)
                          IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () =>
                                _showDeleteConfirmationDialog(context),
                          ),
                      ],
                    )),
              ],
            ),
          ),
          SizedBox(
            height: 250,
          )
        ],
      ),
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Remove from Cart"),
          content:
              Text("Are you sure you want to remove this item from the cart?"),
          actions: <Widget>[
            TextButton(
              child: Text("No"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text("Yes"),
              onPressed: () {
                Navigator.of(context).pop();
                controller.removeFromCart();
                onCartUpdated();
              },
            ),
          ],
        );
      },
    );
  }
}
