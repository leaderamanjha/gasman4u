import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gasman4u/data/api_services/address_api_services.dart';
import 'package:gasman4u/data/api_services/order_api_services.dart';
import 'package:gasman4u/data/models/address/address_model.dart';
import 'package:gasman4u/data/models/order/order_model.dart';
import 'package:intl/intl.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class SelectAddressController extends GetxController {
  final AddressApiServices _addressApiServices = AddressApiServices();
  final OrderApiServices _orderApiServices = OrderApiServices();
  RxList<AddressModel> addresses = <AddressModel>[].obs;
  RxBool isLoading = false.obs;
  Rx<AddressModel?> selectedAddress = Rx<AddressModel?>(null);
  RxString deliveryType = 'Delivery Now'.obs;
  RxString selectedDateTime = ''.obs;
  RxBool showAllAddresses = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchAddresses();
    getCurrentLocation();
  }

  Future<void> fetchAddresses() async {
    isLoading.value = true;
    try {
      addresses.value = await _addressApiServices.getAddress();
    } catch (e) {
      // showToast('Failed to fetch addresses');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        AddressModel currentAddress = AddressModel(
          label: 'Current Location',
          addressLine1: place.street,
          addressLine2: place.subLocality,
          city: place.locality,
          state: place.administrativeArea,
          pincode: place.postalCode,
          country: place.country,
          latitude: position.latitude.toString(),
          longitude: position.longitude.toString(),
        );
        selectedAddress.value = findNearestAddress(currentAddress);
      }
    } catch (e) {
      // showToast('Failed to get current location');
    }
  }

  AddressModel findNearestAddress(AddressModel currentAddress) {
    AddressModel nearestAddress = addresses.first;
    double smallestDistance = double.infinity;

    for (var address in addresses) {
      double distance = Geolocator.distanceBetween(
        double.parse(currentAddress.latitude!),
        double.parse(currentAddress.longitude!),
        double.parse(address.latitude!),
        double.parse(address.longitude!),
      );

      if (distance < smallestDistance) {
        smallestDistance = distance;
        nearestAddress = address;
      }
    }

    return nearestAddress;
  }

  void toggleShowAllAddresses() {
    showAllAddresses.toggle();
  }

  void selectAddress(AddressModel address) {
    selectedAddress.value = address;
    showAllAddresses.value = false;
  }

  void setDeliveryType(String type) {
    deliveryType.value = type;
    if (type == 'Delivery Now') {
      selectedDateTime.value = '';
    }
  }

  Future<void> selectDateTime(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 30)),
    );
    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );
      if (pickedTime != null) {
        final DateTime pickedDateTime = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );
        selectedDateTime.value =
            DateFormat('yyyy-MM-dd HH:mm').format(pickedDateTime);
      }
    }
  }

  Future<void> proceedToCheckout() async {
    if (selectedAddress.value == null) {
      showToast('Please select an address');
      return;
    }

    try {
      final OrderModel order = await _orderApiServices.placeOrder(
        deliveryType: deliveryType.value,
        deliveryDateTime:
            selectedDateTime.value.isEmpty ? null : selectedDateTime.value,
        addressId: selectedAddress.value!.id.toString(),
      );
      Get.offAllNamed('/confirm-order', arguments: order);
    } catch (e) {
      showToast('Failed to place order');
    }
  }

  void clearAddress() {
    addresses.clear();
  }

  void navigateToAddAddress() {
    Get.toNamed('/add-address-screen');
  }

  void showToast(String message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 16.0);
  }
}
