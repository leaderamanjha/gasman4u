import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:gasman4u/data/api_services/address_api_services.dart';
import 'package:gasman4u/data/models/address/address_model.dart';

class SavedAddressController extends GetxController {
  final AddressApiServices _addressApiServices = AddressApiServices();
  RxList<AddressModel> addresses = <AddressModel>[].obs;
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchAddresses();
  }

  Future<void> fetchAddresses() async {
    isLoading.value = true;
    try {
      addresses.value = await _addressApiServices.getAddress();
    } catch (e) {
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteAddress(num addressId) async {
    try {
      await _addressApiServices.deleteAddress(addressId);
      clearAddress();
      fetchAddresses();
      showToast('Address deleted Sucessfully');
    } catch (e) {
      showToast('Failed to delete address');
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
