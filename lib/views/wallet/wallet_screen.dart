import 'package:flutter/material.dart';
import 'package:gasman4u/controller/wallet_controller.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class WalletScreen extends StatelessWidget {
  final WalletController controller = Get.put(WalletController());
  final TextEditingController amountController = TextEditingController();

  WalletScreen() {
    // Listen to changes in the controller's observable variable
    ever(controller.inputAmount, (value) {
      if (amountController.text != value) {
        amountController.text = value;
      }
    });
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
          // leading: IconButton(
          //   icon: Icon(Icons.arrow_back_ios, color: Colors.white),
          //   onPressed: () => Get.back(),
          // ),
          title: Text(
            "Wallet",
            style: GoogleFonts.inter(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            Obx(() => Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: Text(
                      'Balance: ₹${controller.walletBalance.value.toStringAsFixed(2)}',
                      style: GoogleFonts.inter(
                        color: controller.walletBalance.value < 500
                            ? Colors.red
                            : Colors.blue.shade900,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                )),
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Add Money',
                  style: GoogleFonts.inter(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue.shade900),
                ),
                SizedBox(height: 16),
                TextField(
                  controller: amountController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.currency_rupee,
                        color: Colors.blue.shade900,
                      ),
                      border: OutlineInputBorder(),
                      hintText: 'Enter amount'),
                  onChanged: controller.updateInputAmount,
                ),
                SizedBox(height: 16),
                Wrap(
                  spacing: 8,
                  children: [1000, 2000, 3000]
                      .map((amount) => OutlinedButton(
                            onPressed: () => controller
                                .selectSuggestedAmount(amount.toDouble()),
                            child: Text('₹$amount'),
                          ))
                      .toList(),
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    Get.dialog(
                      AlertDialog(
                        title: Text('Confirm'),
                        content: Text('Are you sure you want to add money?'),
                        actions: [
                          TextButton(
                            child: Text('No'),
                            onPressed: () => Get.back(),
                          ),
                          TextButton(
                            child: Text('Yes'),
                            onPressed: () {
                              Get.back();
                              controller.addMoneyToWallet();
                            },
                          ),
                        ],
                      ),
                    );
                  },
                  child: Center(
                    child: Text(
                      'Add Money',
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade900,
                  ),
                ),
                SizedBox(height: 24),
                Text(
                  'Wallet History',
                  style: GoogleFonts.inter(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 16),
                Obx(() => ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: controller.walletHistory.length,
                      itemBuilder: (context, index) {
                        final transaction = controller.walletHistory[index];
                        return Card(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                    'Transaction ID: ${transaction.transactionId ?? "N/A"}'),
                                Text(
                                    'Amount: ₹${transaction.amount?.toStringAsFixed(2) ?? "0.00"}'),
                                Text(
                                    'Closing Balance: ₹${transaction.closingBalance?.toStringAsFixed(2) ?? "0.00"}'),
                              ],
                            ),
                          ),
                        );
                      },
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
