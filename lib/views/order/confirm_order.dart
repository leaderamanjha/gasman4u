import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gasman4u/controller/confirm_order_controller.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class ConfirmOrderScreen extends StatelessWidget {
  final ConfirmOrderController controller = Get.put(ConfirmOrderController());

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
            icon: Icon(Icons.arrow_back_ios, color: Colors.white),
            onPressed: () => Get.back(),
          ),
          title: Text(
            "Checkout",
            style: GoogleFonts.inter(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Summary',
                  style: GoogleFonts.roboto(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16),
                Obx(() => Card(
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                'Order ID: ${controller.order.value.orderId ?? ''}'),
                            Text(
                                'Delivery Type: ${controller.order.value.deliveryType ?? ''}'),
                            if (controller.order.value.deliveryDateTime != null)
                              Text(
                                  'Delivery Date: ${controller.order.value.deliveryDateTime?.toString() ?? ''}'),
                            Text(
                                'Address: ${controller.order.value.addressLine1 ?? ''}, ${controller.order.value.addressLine2 ?? ''}, ${controller.order.value.addressCity ?? ''}, ${controller.order.value.addressState ?? ''}, ${controller.order.value.addressPincode ?? ''}'),
                            SizedBox(height: 8),
                            Text(
                              'Total Payable Amount: ₹${controller.order.value.orderTotalPrice?.toStringAsFixed(2) ?? '0.00'}',
                              style: GoogleFonts.roboto(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )),
                SizedBox(height: 24),
                Text(
                  'Select Payment Type',
                  style: GoogleFonts.roboto(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Obx(() => DropdownButton<int>(
                      padding: EdgeInsets.all(8),
                      style: GoogleFonts.roboto(
                        fontSize: 17,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                      value: controller.selectedPaymentTypeId.value,
                      onChanged: (int? newValue) {
                        controller.selectedPaymentTypeId.value = newValue!;
                      },
                      items: [
                        DropdownMenuItem(value: 1, child: Text('COD')),
                        DropdownMenuItem(value: 2, child: Text('Online')),
                        DropdownMenuItem(value: 3, child: Text('Wallet')),
                      ],
                    )),
                SizedBox(height: 24),
                Center(
                  child: ElevatedButton(
                    onPressed: () => controller.showConfirmationDialog(),
                    child: Text('Confirm Order',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange.shade700,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
