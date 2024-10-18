import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gasman4u/controller/add_address_controller.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AddAddressScreen extends StatelessWidget {
  final AddAddressController controller = Get.put(AddAddressController());

  // Create TextEditingController instances
  final TextEditingController addressLine1Controller = TextEditingController();
  final TextEditingController addressLine2Controller = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController stateController = TextEditingController();
  final TextEditingController pincodeController = TextEditingController();

  AddAddressScreen() {
    ever(controller.addressLine1, (value) {
      if (addressLine1Controller.text != value) {
        addressLine1Controller.text = value;
      }
    });
    ever(controller.addressLine2, (value) {
      if (addressLine2Controller.text != value) {
        addressLine2Controller.text = value;
      }
    });
    ever(controller.city, (value) {
      if (cityController.text != value) {
        cityController.text = value;
      }
    });
    ever(controller.state, (value) {
      if (stateController.text != value) {
        stateController.text = value;
      }
    });
    ever(controller.pincode, (value) {
      if (pincodeController.text != value) {
        pincodeController.text = value;
      }
    });
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
            icon: Icon(Icons.arrow_back_ios, color: Colors.white),
            onPressed: () => Get.back(),
          ),
          title: Text(
            "Add Address ",
            style: GoogleFonts.inter(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                readOnly: true,
                onTap: controller.searchLocation,
                decoration: InputDecoration(
                  hintText: 'Search Location',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Stack(
                children: [
                  Obx(() => GoogleMap(
                        initialCameraPosition: CameraPosition(
                          target: controller.selectedLocation.value,
                          zoom: 15,
                        ),
                        onMapCreated: (GoogleMapController mapController) {
                          controller.mapController = mapController;
                        },
                        markers: {
                          Marker(
                            markerId: MarkerId('selected_location'),
                            position: controller.selectedLocation.value,
                            draggable: true,
                            onDragEnd: (LatLng position) {
                              controller.updateSelectedLocation(position);
                            },
                          ),
                        },
                        onTap: (LatLng position) {
                          controller.updateSelectedLocation(position);
                        },
                        myLocationEnabled: true,
                        myLocationButtonEnabled: true,
                        zoomControlsEnabled: true,
                        zoomGesturesEnabled: true,
                        mapToolbarEnabled: true,
                        compassEnabled: true,
                        rotateGesturesEnabled: true,
                        scrollGesturesEnabled: true,
                        tiltGesturesEnabled: true,
                      )),
                  Positioned(
                    bottom: 16,
                    right: 16,
                    child: FloatingActionButton(
                      onPressed: controller.getCurrentLocation,
                      child: Icon(Icons.my_location),
                      backgroundColor: Colors.orange.shade700,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Address Details',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8),
                      Obx(() => DropdownButtonFormField<String>(
                            value: controller.addressType.value,
                            items: controller.addressTypes.map((String type) {
                              return DropdownMenuItem<String>(
                                value: type,
                                child: Text(type),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              if (newValue != null) {
                                controller.addressType.value = newValue;
                              }
                            },
                            decoration: InputDecoration(
                              labelText: 'Address Type',
                              border: OutlineInputBorder(),
                            ),
                          )),
                      SizedBox(height: 16),
                      TextField(
                        controller: addressLine1Controller,
                        decoration: InputDecoration(
                          labelText: 'Address Line 1',
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (value) =>
                            controller.addressLine1.value = value,
                      ),
                      SizedBox(height: 16),
                      TextField(
                        controller: addressLine2Controller,
                        decoration: InputDecoration(
                          labelText: 'Address Line 2',
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (value) =>
                            controller.addressLine2.value = value,
                      ),
                      SizedBox(height: 16),
                      TextField(
                        controller: cityController,
                        decoration: InputDecoration(
                          labelText: 'City',
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (value) => controller.city.value = value,
                      ),
                      SizedBox(height: 16),
                      TextField(
                        controller: stateController,
                        decoration: InputDecoration(
                          labelText: 'State',
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (value) => controller.state.value = value,
                      ),
                      SizedBox(height: 16),
                      TextField(
                        controller: pincodeController,
                        decoration: InputDecoration(
                          labelText: 'Pin Code',
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (value) => controller.pincode.value = value,
                      ),
                      SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: controller.addAddress,
                          child: Text(
                            'Add Address',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange.shade700,
                            padding: EdgeInsets.symmetric(vertical: 16),
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
          ],
        ),
      ),
    );
  }
}
