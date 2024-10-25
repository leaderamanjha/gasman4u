import 'package:flutter/material.dart';
import 'package:flutter_google_places_hoc081098/google_maps_webservice_places.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gasman4u/controller/saved_address_controller.dart';
import 'package:gasman4u/controller/select_address_controller.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gasman4u/data/api_services/address_api_services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:flutter_google_places_hoc081098/flutter_google_places_hoc081098.dart';
import 'package:google_api_headers/google_api_headers.dart';
import '../custom_loader/custom_loader_service.dart';

class AddAddressController extends GetxController {
  final AddressApiServices _addressApiServices = AddressApiServices();
  final SavedAddressController savedAddressController =
      Get.put(SavedAddressController());
  final SelectAddressController selectAddressController =
      Get.put(SelectAddressController());

  Rx<LatLng> selectedLocation = LatLng(0, 0).obs;
  GoogleMapController? mapController;

  RxString addressLine1 = ''.obs;
  RxString addressLine2 = ''.obs;
  RxString city = ''.obs;
  RxString state = ''.obs;
  RxString pincode = ''.obs;
  RxString addressType = 'Home'.obs;

  final List<String> addressTypes = ['Home', 'Office', 'Others'];

  // You should replace this with your actual Google Maps API key
  final String googleMapsApiKey = "Google Map Api Key";

  @override
  void onInit() {
    super.onInit();
    getCurrentLocation();
  }

  Future<void> searchLocation() async {
    Prediction? place = await PlacesAutocomplete.show(
      context: Get.context!,
      apiKey: googleMapsApiKey,
      mode: Mode.overlay,
      language: 'en',
      components: [Component(Component.country, 'in')],
    );

    if (place != null) {
      final plist = GoogleMapsPlaces(
        apiKey: googleMapsApiKey,
        apiHeaders: await GoogleApiHeaders().getHeaders(),
      );
      String placeId = place.placeId ?? '';
      final detail = await plist.getDetailsByPlaceId(placeId);
      final geometry = detail.result.geometry!;
      final lat = geometry.location.lat;
      final lng = geometry.location.lng;
      updateSelectedLocation(LatLng(lat, lng));
    }
  }

  Future<void> getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      updateSelectedLocation(LatLng(position.latitude, position.longitude));
    } catch (e) {
      // showToast('Failed to get current location');
    }
  }

  Future<void> getAddressFromLatLng() async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
          selectedLocation.value.latitude, selectedLocation.value.longitude);
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        addressLine1.value = '${place.street}';
        addressLine2.value = '${place.subLocality}';
        city.value = '${place.locality}';
        state.value = '${place.administrativeArea}';
        pincode.value = '${place.postalCode}';
      }
    } catch (e) {
      print(e);
    }
  }

  void updateSelectedLocation(LatLng location) {
    selectedLocation.value = location;
    mapController?.animateCamera(CameraUpdate.newLatLng(location));
    getAddressFromLatLng();
  }

  Future<void> addAddress() async {
    if (addressLine1.isEmpty ||
        addressLine2.isEmpty ||
        city.isEmpty ||
        state.isEmpty ||
        pincode.isEmpty) {
      showToast('Please fill all required fields');
      return;
    }

    CustomLoaderService.show();
    try {
      await _addressApiServices.addAddress(
        addressType.value,
        addressLine1.value,
        addressLine2.value,
        city.value,
        state.value,
        pincode.value,
        selectedLocation.value.latitude.toString(),
        selectedLocation.value.longitude.toString(),
      );
      CustomLoaderService.hide();
      savedAddressController.clearAddress();
      savedAddressController.fetchAddresses();
      selectAddressController.clearAddress();
      selectAddressController.fetchAddresses();
      Get.back();
      showToast('New Address Added Successfully');
    } catch (e) {
      CustomLoaderService.hide();
      showToast('Failed to add address');
    } finally {
      CustomLoaderService.hide();
    }
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
