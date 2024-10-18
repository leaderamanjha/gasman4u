import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gasman4u/controller/products_controller.dart';
import 'package:gasman4u/controller/home_screen_controller.dart';
import 'package:gasman4u/data/models/home/home_categories_model.dart';
import 'package:gasman4u/data/models/products/products.dart';
import 'package:gasman4u/routes/app_routes.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'dart:io';

class ProductsScreen extends StatefulWidget {
  final Categories category;

  const ProductsScreen({required this.category, Key? key}) : super(key: key);

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  final ProductsController controller = Get.put(ProductsController());
  final HomeScreenController homeController = Get.find<HomeScreenController>();
  bool _hasInternet = true;

  @override
  void initState() {
    super.initState();
    _initializeScreen();
  }

  Future<void> _initializeScreen() async {
    bool hasInternet = await checkRealConnectivity();
    setState(() {
      _hasInternet = hasInternet;
    });
    if (_hasInternet) {
      await controller.fetchServicesByCategory(widget.category.id ?? 0);
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
      await controller.fetchServicesByCategory(widget.category.id ?? 0);
      await homeController.fetchCartItems();
    } else {
      Get.snackbar(
        'No Internet',
        'Please check your internet connection',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Widget _buildFloatingCartButton() {
    return Obx(() {
      final cartItemCount = homeController.cartItems.length;
      if (cartItemCount == 0) return const SizedBox.shrink();

      return Positioned(
        left: 110,
        bottom: 50,
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

  Widget _buildNoInternetWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.wifi_off, size: 64, color: Colors.grey),
          const SizedBox(height: 16),
          Text(
            'No Internet Connection',
            style: GoogleFonts.roboto(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: _handleRefresh,
            child: const Text('Retry'),
          ),
        ],
      ),
    );
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
            icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
            onPressed: () => Get.back(),
          ),
          title: Text(
            "${widget.category.name}",
            style: GoogleFonts.inter(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        body: !_hasInternet
            ? RefreshIndicator(
                onRefresh: _handleRefresh,
                child: Stack(
                  children: [
                    ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.7,
                          child: _buildNoInternetWidget(),
                        ),
                      ],
                    ),
                  ],
                ),
              )
            : Stack(
                children: [
                  RefreshIndicator(
                    onRefresh: _handleRefresh,
                    child: Container(
                      decoration: const BoxDecoration(
                          color: Color.fromARGB(238, 245, 245, 245)),
                      child: Obx(() {
                        if (controller.isLoading.value) {
                          return _buildShimmerEffect();
                        } else if (controller.products.isEmpty) {
                          return Center(
                            child: Text(
                              "No services available",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            ),
                          );
                        } else {
                          return ListView.builder(
                            itemCount: controller.products.length,
                            itemBuilder: (context, index) {
                              return _buildProductCard(
                                  controller.products[index]);
                            },
                          );
                        }
                      }),
                    ),
                  ),
                  _buildFloatingCartButton(),
                ],
              ),
      ),
    );
  }

  Widget _buildShimmerEffect() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: ListView.builder(
        itemCount: 10,
        itemBuilder: (_, __) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 90,
                height: 90,
                color: Colors.white,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      height: 16,
                      color: Colors.white,
                    ),
                    const SizedBox(height: 8),
                    Container(
                      width: double.infinity,
                      height: 12,
                      color: Colors.white,
                    ),
                    const SizedBox(height: 8),
                    Container(
                      width: 80,
                      height: 12,
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

  Widget _buildProductCard(Products product) {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        onTap: () =>
            Get.toNamed(AppRoutes.productDetailsScreen, arguments: product.id),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  product.image ?? '',
                  width: 90,
                  height: 90,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      Icon(Icons.error),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name ?? "",
                      style: GoogleFonts.poppins(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      product.description ?? "",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.inter(
                        color: Colors.blueGrey,
                        fontSize: 12,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    const SizedBox(height: 4),
                    _buildPriceRow(
                        "Security Deposit:", "₹${product.securityDeposit}"),
                    const SizedBox(height: 4),
                    _buildPriceRow("Price:", "₹${product.price}"),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPriceRow(String label, String value) {
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
        const SizedBox(width: 4),
        Text(
          value,
          style: GoogleFonts.poppins(
            color: Colors.green,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
