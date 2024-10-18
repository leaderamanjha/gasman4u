import 'package:flutter/material.dart';
import 'package:gasman4u/controller/order_details_controller.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

class OrderDetailsScreen extends StatelessWidget {
  final String orderId;

  OrderDetailsScreen({required this.orderId});

  @override
  Widget build(BuildContext context) {
    final OrderDetailsController controller =
        Get.put(OrderDetailsController(orderId));

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
            "Order Details",
            style: GoogleFonts.inter(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        body: Obx(() {
          if (controller.isLoading.value) {
            return _buildShimmerEffect();
          } else {
            final order = controller.order.value!;
            return SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.shopping_cart,
                        size: 20,
                        color: Colors.blue.shade900,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Order ID: ${order.orderId}',
                        style: GoogleFonts.roboto(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue.shade900,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  buildProductTable(controller.products),
                  SizedBox(height: 30),
                  Column(
                    children: [
                      Row(
                        children: [
                          Text(
                            'Order Total price : ',
                            style: GoogleFonts.roboto(
                                fontSize: 14,
                                color: Colors.blue.shade900,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              '₹${order.orderTotalPrice}',
                              style: GoogleFonts.roboto(
                                  fontSize: 14, color: Colors.green),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Text(
                        'Delivery Type : ',
                        style: GoogleFonts.roboto(
                            fontSize: 14,
                            color: Colors.blue.shade900,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          '${order.deliveryType}',
                          style: GoogleFonts.roboto(
                              fontSize: 14, color: Colors.blue.shade900),
                        ),
                      ),
                    ],
                  ),
                  if (order.deliveryType == 'Schedule Later' &&
                      order.deliveryDateTime != null)
                    SizedBox(height: 10),
                  if (order.deliveryType == 'Schedule Later' &&
                      order.deliveryDateTime != null)
                    Row(
                      children: [
                        Text(
                          'Delivery Date : ',
                          style: GoogleFonts.roboto(
                              fontSize: 14,
                              color: Colors.blue.shade900,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            '${DateFormat('dd-MM-yyyy').format(order.deliveryDateTime!)}',
                            style: GoogleFonts.roboto(
                                fontSize: 14, color: Colors.blue.shade900),
                          ),
                        ),
                      ],
                    ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Text(
                        'Address : ',
                        style: GoogleFonts.roboto(
                            fontSize: 14,
                            color: Colors.blue.shade900,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          '${order.addressLine1}, ${order.addressLine2}, ${order.addressCity}, ${order.addressState}, ${order.addressPincode}, ${order.addressCountry}',
                          style: GoogleFonts.roboto(
                              fontSize: 14, color: Colors.blue.shade900),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Text(
                        'Payment Status : ',
                        style: GoogleFonts.roboto(
                            fontSize: 14,
                            color: Colors.blue.shade900,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          '${order.paymentStatus}',
                          style: GoogleFonts.roboto(
                              fontSize: 14, color: Colors.blue.shade900),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Text(
                        'Order Status : ',
                        style: GoogleFonts.roboto(
                            fontSize: 14,
                            color: Colors.blue.shade900,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          '${order.orderStatus}',
                          style: GoogleFonts.roboto(
                              fontSize: 14, color: Colors.green),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }
        }),
      ),
    );
  }

  Widget buildProductTable(List<Map<String, dynamic>> products) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                'Product Name',
                style: GoogleFonts.roboto(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue.shade900,
                ),
              ),
            ),
            Expanded(
              child: Text(
                'Quantity',
                style: GoogleFonts.roboto(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue.shade900,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Expanded(
              child: Text(
                'Price',
                style: GoogleFonts.roboto(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue.shade900,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Expanded(
              child: Text(
                'Security',
                style: GoogleFonts.roboto(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue.shade900,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Expanded(
              child: Text(
                'Total Price',
                style: GoogleFonts.roboto(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
        SizedBox(height: 8),
        ...products.map((product) => buildProductRow(product)),
      ],
    );
  }

  Widget buildProductRow(Map<String, dynamic> product) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          Expanded(
            child: Text(
              '${product['product_name']}',
              style:
                  GoogleFonts.roboto(fontSize: 12, color: Colors.blue.shade900),
            ),
          ),
          Expanded(
            child: Text(
              '${product['qty']}',
              style:
                  GoogleFonts.roboto(fontSize: 12, color: Colors.blue.shade900),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: Text(
              '₹${product['price']}',
              style:
                  GoogleFonts.roboto(fontSize: 12, color: Colors.blue.shade900),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: Text(
              '₹${product['security_deposit']}',
              style:
                  GoogleFonts.roboto(fontSize: 12, color: Colors.blue.shade900),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: Text(
              '₹${product['total']}',
              style: GoogleFonts.roboto(fontSize: 12, color: Colors.green),
              textAlign: TextAlign.center,
            ),
          ),
        ],
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
