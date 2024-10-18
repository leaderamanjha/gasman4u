import 'package:flutter/material.dart';
import 'package:gasman4u/controller/fetch_orders_controller.dart';
import 'package:gasman4u/views/order/order_details.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

class FetchOrdersScreen extends StatefulWidget {
  @override
  _FetchOrdersScreenState createState() => _FetchOrdersScreenState();
}

class _FetchOrdersScreenState extends State<FetchOrdersScreen> {
  final FetchOrdersController controller = Get.put(FetchOrdersController());

  @override
  void initState() {
    super.initState();
    controller.fetchOrders();
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
          title: Center(
            child: Text(
              "My Orders",
              style: GoogleFonts.inter(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        body: Obx(() {
          if (controller.isLoading.value) {
            return _buildShimmerEffect();
          } else {
            return ListView.builder(
              itemCount: controller.orders.length,
              itemBuilder: (context, index) {
                final order = controller.orders[index];
                return Card(
                  margin: EdgeInsets.all(8),
                  child: InkWell(
                    onTap: () => Get.to(
                        () => OrderDetailsScreen(orderId: order.orderId!)),
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.shopping_cart, size: 20),
                              SizedBox(width: 8),
                              Text(
                                'Order: ${order.orderId}',
                                style: GoogleFonts.roboto(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Delivery Type: ${order.deliveryType}',
                            style: GoogleFonts.roboto(
                                fontSize: 12, color: Colors.black),
                          ),
                          if (order.deliveryType == 'Schedule Later' &&
                              order.deliveryDateTime != null)
                            Text(
                              'Delivery Date: ${DateFormat('yyyy-MM-dd').format(order.deliveryDateTime!)}',
                              style: GoogleFonts.roboto(
                                  fontSize: 12, color: Colors.black),
                            ),
                          SizedBox(height: 8),
                          Row(
                            children: [
                              Text(
                                'Address : ',
                                style: GoogleFonts.roboto(
                                    fontSize: 12, color: Colors.black),
                              ),
                              SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  '${order.addressLine1}, ${order.addressLine2}, ${order.addressCity}, ${order.addressState}, ${order.addressPincode}',
                                  style: GoogleFonts.roboto(
                                      fontSize: 12, color: Colors.black),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Payment Status: ${order.paymentStatus}',
                            style: GoogleFonts.roboto(
                                fontSize: 12, color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }
        }),
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
}
