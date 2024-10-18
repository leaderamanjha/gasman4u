// import 'package:flutter/material.dart';
import 'package:gasman4u/data/api_services/address_api_services.dart';
import 'package:gasman4u/data/api_services/cart_api_services.dart';
import 'package:gasman4u/data/api_services/home_api_service.dart';
import 'package:gasman4u/data/models/address/address_model.dart';
import 'package:gasman4u/data/models/cart/cart_model.dart';
import 'package:gasman4u/data/models/home/home_categories_model.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

class HomeScreenController extends GetxController {
  final HomeApiService _homeApiService = HomeApiService();
  final AddressApiServices _addressApiServices = AddressApiServices();
  RxList<AddressModel> addresses = <AddressModel>[].obs;
  final CartApiServices _cartApiServices = CartApiServices();
  RxList<CartModel> cartItems = <CartModel>[].obs;

  RxList<Categories> categories = <Categories>[].obs;
  RxBool isLoading = true.obs;
  RxString currentLocation = 'Loading...'.obs;
  RxList<Categories> filteredCategories = <Categories>[].obs;
  RxBool isSearching = false.obs;

  @override
  void onInit() {
    super.onInit();
    getCurrentLocation();
    fetchHomeData();
    fetchAddresses();
    fetchCartItems();
  }

  Future<void> fetchHomeData() async {
    try {
      isLoading(true);
      final homeData = await _homeApiService.getHomeData();
      print("fetching home bhai");
      // Process categories
      final List<dynamic> categoriesData = homeData['categories'];
      final String baseImageUrl = homeData['url'];
      categories.value = categoriesData.map((category) {
        category['image'] = baseImageUrl + '/' + category['image'];
        return Categories.fromJson(category);
      }).toList();
    } catch (e) {
      print('Error fetching home data: $e');
    } finally {
      isLoading(false);
    }
  }

  Future<void> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      currentLocation.value = 'Location services are disabled.';
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        currentLocation.value = 'Location permissions are denied';
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      currentLocation.value =
          'Location permissions are permanently denied, we cannot request permissions.';
      return;
    }

    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        String city = place.locality ?? '';
        String area = place.subLocality ?? '';

        if (area.isNotEmpty && city.isNotEmpty) {
          currentLocation.value = '$area, $city';
        } else if (city.isNotEmpty) {
          currentLocation.value = city;
        } else {
          currentLocation.value = 'Location found';
        }
      } else {
        currentLocation.value = 'Location found';
      }
    } catch (e) {
      currentLocation.value = 'Unable to get location';
      print('Error getting location: $e');
    }
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

  Future<void> fetchCartItems() async {
    try {
      cartItems.clear();
      isLoading(true);
      cartItems.value = await _cartApiServices.getCart();
    } catch (e) {
      print('Error fetching cart items: $e');
    } finally {
      isLoading(false);
    }
  }
}
