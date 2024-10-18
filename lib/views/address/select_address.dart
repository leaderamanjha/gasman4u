import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gasman4u/controller/select_address_controller.dart';
import 'package:gasman4u/core/utils/size_utils.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class SelectAddressScreen extends StatelessWidget {
  final SelectAddressController controller = Get.put(SelectAddressController());

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
            "Select Address",
            style: GoogleFonts.inter(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10.h),
              Center(
                child: ElevatedButton(
                  onPressed: controller.navigateToAddAddress,
                  child: Text(
                    'Add New Address',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade900,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                ),
              ),
              Obx(() {
                if (controller.isLoading.value) {
                  return Center(child: CircularProgressIndicator());
                } else if (controller.addresses.isEmpty) {
                  return Center(
                      child: Text(
                    'No addresses found',
                    style: TextStyle(color: Colors.blue.shade900),
                  ));
                } else {
                  return Obx(() => controller.showAllAddresses.value
                      ? _buildAllAddresses()
                      : _buildSelectedAddress());
                }
              }),
              Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  'Select delivery type:',
                  style: GoogleFonts.roboto(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue.shade900,
                  ),
                ),
              ),
              Obx(() => Column(
                    children: [
                      RadioListTile<String>(
                        title: Text(
                          'Delivery Now',
                          style: TextStyle(color: Colors.blue.shade900),
                        ),
                        value: 'Delivery Now',
                        groupValue: controller.deliveryType.value,
                        onChanged: (value) =>
                            controller.setDeliveryType(value!),
                      ),
                      RadioListTile<String>(
                        title: Text(
                          'Schedule Later',
                          style: TextStyle(color: Colors.blue.shade900),
                        ),
                        value: 'Schedule Later',
                        groupValue: controller.deliveryType.value,
                        onChanged: (value) =>
                            controller.setDeliveryType(value!),
                      ),
                    ],
                  )),
              Obx(() => controller.deliveryType.value == 'Schedule Later'
                  ? Padding(
                      padding: EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Text(
                            'Select date:',
                            style: GoogleFonts.roboto(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue.shade900),
                          ),
                          SizedBox(width: 10),
                          IconButton(
                            icon: Icon(
                              Icons.calendar_month,
                              color: Colors.blue.shade900,
                            ),
                            onPressed: () => controller.selectDateTime(context),
                          ),
                          Obx(() => Text(controller.selectedDateTime.value)),
                        ],
                      ),
                    )
                  : SizedBox.shrink()),
              Center(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: ElevatedButton(
                    onPressed: () => controller.proceedToCheckout(),
                    child: Text('Proceed Next',
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
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSelectedAddress() {
    return Obx(() => controller.selectedAddress.value != null
        ? Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Selected Address',
                        style: GoogleFonts.roboto(
                          color: Colors.blue.shade900,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      TextButton(
                        onPressed: controller.toggleShowAllAddresses,
                        child: Text(
                          'Change',
                          style: TextStyle(color: Colors.orange.shade700),
                        ),
                      ),
                    ],
                  ),
                  Text(
                    'Address type: ${controller.selectedAddress.value!.label}',
                    style: TextStyle(color: Colors.blue.shade900),
                  ),
                  Text(
                    'Address: ${controller.selectedAddress.value!.addressLine1}, ${controller.selectedAddress.value!.addressLine2}',
                    style: TextStyle(color: Colors.blue.shade900),
                  ),
                  Text(
                    'City: ${controller.selectedAddress.value!.city}',
                    style: TextStyle(color: Colors.blue.shade900),
                  ),
                  Text(
                    'State: ${controller.selectedAddress.value!.state}',
                    style: TextStyle(color: Colors.blue.shade900),
                  ),
                  Text(
                    'Pincode: ${controller.selectedAddress.value!.pincode}',
                    style: TextStyle(color: Colors.blue.shade900),
                  ),
                  Text(
                    'Country: ${controller.selectedAddress.value!.country}',
                    style: TextStyle(color: Colors.blue.shade900),
                  ),
                ],
              ),
            ),
          )
        : Center(
            child: TextButton(
              onPressed: controller.toggleShowAllAddresses,
              child: Text(
                'Select Address',
                style: TextStyle(color: Colors.blue.shade900),
              ),
            ),
          ));
  }

  Widget _buildAllAddresses() {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: controller.addresses.length,
      itemBuilder: (context, index) {
        final address = controller.addresses[index];
        return Card(
          child: ListTile(
            title: Text(
              'Address type: ${address.label}',
              style: GoogleFonts.roboto(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Address Line 1: ${address.addressLine1}',
                ),
                Text('Address Line 2: ${address.addressLine2}'),
                Text('City: ${address.city}'),
                Text('State: ${address.state}'),
                Text('Pincode: ${address.pincode}'),
                Text('Country: ${address.country}'),
              ],
            ),
            onTap: () => controller.selectAddress(address),
          ),
        );
      },
    );
  }
}
