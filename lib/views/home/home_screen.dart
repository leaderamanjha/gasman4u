import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gasman4u/controller/home_screen_controller.dart';
import 'package:gasman4u/data/models/home/home_categories_model.dart';
import 'package:gasman4u/routes/app_routes.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'dart:io';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with AutomaticKeepAliveClientMixin {
  final HomeScreenController controller = Get.put(HomeScreenController());
  final PageController _pageController = PageController(viewportFraction: 0.85);
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocus = FocusNode();

  Timer? _timer;
  Timer? _searchHintTimer;
  int _currentPage = 0;
  int _currentSearchHintIndex = 0;
  bool _hasInternet = true;
  RxList<Categories> filteredCategories = <Categories>[].obs;

  @override
  bool get wantKeepAlive => true;

// Replace the existing initState with this
  @override
  void initState() {
    super.initState();
    _initializeScreen();
  }

// Add these methods to your _HomeScreenState class
  Future<void> _initializeScreen() async {
    bool hasInternet = await checkRealConnectivity();
    setState(() {
      _hasInternet = hasInternet;
    });
    if (_hasInternet) {
      await controller.fetchHomeData();
      filteredCategories.value = controller.categories;
      controller.fetchCartItems();
      controller.fetchAddresses();
    }
    _startAutoPlay();
    _startSearchHintRotation();
    _setupSearchListener();
  }

  Future<bool> checkRealConnectivity() async {
    try {
      var connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult == ConnectivityResult.none) {
        return false;
      }
      final result = await InternetAddress.lookup('google.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      return false;
    }
  }

  void _setupSearchListener() {
    _searchController.addListener(() {
      _filterCategories(_searchController.text);
    });
  }

  void _filterCategories(String query) {
    if (query.isEmpty) {
      filteredCategories.value = controller.categories;
    } else {
      filteredCategories.value = controller.categories
          .where((category) =>
              category.name?.toLowerCase().contains(query.toLowerCase()) ??
              false)
          .toList();
    }
  }

  void _clearSearch() {
    _searchController.clear();
    _searchFocus.unfocus();
    filteredCategories.value = controller.categories;
  }

  void _startSearchHintRotation() {
    _searchHintTimer?.cancel();
    _searchHintTimer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (controller.categories.isNotEmpty) {
        setState(() {
          _currentSearchHintIndex =
              (_currentSearchHintIndex + 1) % controller.categories.length;
        });
      }
    });
  }

  void _startAutoPlay() {
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (_currentPage < 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
      _pageController.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeIn,
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _searchHintTimer?.cancel();
    _pageController.dispose();
    _searchController.dispose();
    _searchFocus.dispose();
    super.dispose();
  }

  Future<void> _handleRefresh() async {
    bool hasInternet = await checkRealConnectivity();
    setState(() {
      _hasInternet = hasInternet;
    });
    if (_hasInternet) {
      await controller.fetchHomeData();
      filteredCategories.value = controller.categories;
      await controller.fetchCartItems();
      await controller.fetchAddresses();
    } else {
      Get.snackbar(
        'No Internet',
        'Please check your internet connection',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

// Update your _buildContent method
  Widget _buildContent() {
    return RefreshIndicator(
      onRefresh: _handleRefresh,
      child: SingleChildScrollView(
        physics:
            const AlwaysScrollableScrollPhysics(), // This is important for RefreshIndicator to work
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            _buildBanner(),
            _buildCategories(),
            _buildPopularProducts(),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(100),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color.fromARGB(255, 246, 176, 71), Colors.orange.shade600],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          bottom: false,
          child: Column(
            children: [
              Obx(() {
                final address = controller.addresses.isNotEmpty
                    ? controller.addresses.first
                    : null;
                String displayAddress = '';
                if (address != null) {
                  displayAddress =
                      '${address.label} - ${address.addressLine1}, '
                      '${address.addressLine2}, ${address.city}';
                  if (displayAddress.length > 40) {
                    displayAddress = displayAddress.substring(0, 40) + '...';
                  }
                } else {
                  displayAddress = controller.currentLocation.value;
                }

                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.location_on, color: Colors.white),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          displayAddress,
                          style: GoogleFonts.roboto(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                );
              }),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Container(
                  height: 45,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.0),
                        child: Icon(Icons.search, color: Colors.grey),
                      ),
                      Expanded(
                        child: TextField(
                          controller: _searchController,
                          focusNode: _searchFocus,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: controller.categories.isEmpty
                                ? 'Search categories...'
                                : 'Search ${controller.categories[_currentSearchHintIndex].name}',
                          ),
                        ),
                      ),
                      if (_searchController.text.isNotEmpty)
                        IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: _clearSearch,
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNoInternetWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.wifi_off, size: 64, color: Colors.grey),
          const SizedBox(height: 16),
          Text(
            'No Internet Connection',
            style: GoogleFonts.roboto(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: () async {
              bool hasInternet = await checkRealConnectivity();
              setState(() {
                _hasInternet = hasInternet;
              });
              if (_hasInternet) {
                controller.fetchHomeData();
                controller.fetchCartItems();
                controller.fetchAddresses();
              }
            },
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildCategories() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'Categories',
            style: GoogleFonts.roboto(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
        SizedBox(
          height: 100,
          child: Obx(() => ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: filteredCategories.length,
                itemBuilder: (context, index) {
                  final category = filteredCategories[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: GestureDetector(
                      onTap: () {
                        if (!_hasInternet) {
                          Get.snackbar(
                            'No Internet',
                            'Please check your internet connection',
                            snackPosition: SnackPosition.BOTTOM,
                          );
                          return;
                        }
                        Get.toNamed(AppRoutes.productScreen,
                            arguments: category);
                      },
                      child: Column(
                        children: [
                          Material(
                            elevation: 5,
                            shape: const CircleBorder(),
                            child: CircleAvatar(
                              radius: 36,
                              backgroundImage:
                                  NetworkImage(category.image ?? ''),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            category.name ?? '',
                            style: GoogleFonts.roboto(
                                fontSize: 11, fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              )),
        ),
      ],
    );
  }

  Widget _buildFloatingCartButton() {
    return Obx(() {
      final cartItemCount = controller.cartItems.length;
      if (cartItemCount == 0) return const SizedBox.shrink();

      return Positioned(
        left: 110,
        bottom: 20,
        child: FloatingActionButton.extended(
          backgroundColor: Colors.blue.shade900,
          onPressed: () {
            if (!_hasInternet) {
              Get.snackbar(
                'No Internet',
                'Please check your internet connection',
                snackPosition: SnackPosition.BOTTOM,
              );
              return;
            }
            Get.toNamed(AppRoutes.cart);
          },
          label: Row(
            children: [
              SizedBox(
                width: cartItemCount > 1 ? 60 : 40,
                height: 40,
                child: Stack(
                  children: [
                    if (controller.cartItems.isNotEmpty)
                      Positioned(
                        left: 0,
                        child: CircleAvatar(
                          backgroundColor: Colors.white,
                          radius: 20,
                          backgroundImage: NetworkImage(
                            controller.cartItems[0].image ?? '',
                          ),
                        ),
                      ),
                    if (cartItemCount > 1)
                      Positioned(
                        left: 20,
                        child: CircleAvatar(
                          backgroundColor: Colors.white,
                          radius: 20,
                          backgroundImage: NetworkImage(
                            controller.cartItems[1].image ?? '',
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'View Cart\n$cartItemCount Items',
                style: GoogleFonts.roboto(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
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
        appBar: _buildAppBar(),
        body: !_hasInternet
            ? RefreshIndicator(
                onRefresh: _handleRefresh,
                child: Stack(
                  children: [
                    ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.7,
                          child: _buildNoInternetWidget(),
                        ),
                      ],
                    ),
                  ],
                ),
              )
            : Stack(
                children: [
                  Obx(() {
                    return controller.isLoading.value
                        ? _buildShimmerLoading()
                        : _buildContent();
                  }),
                  _buildFloatingCartButton()
                ],
              ),
      ),
    );
  }

  Widget _buildShimmerLoading() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            _buildShimmerBanner(),
            _buildShimmerCategories(),
            _buildShimmerPopularProducts(),
          ],
        ),
      ),
    );
  }

  Widget _buildShimmerBanner() {
    return Container(
      height: 180,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }

  Widget _buildShimmerCategories() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            width: 100,
            height: 20,
            color: Colors.white,
          ),
        ),
        SizedBox(
          height: 100,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 5,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 36,
                      backgroundColor: Colors.white,
                    ),
                    const SizedBox(height: 8),
                    Container(
                      width: 60,
                      height: 10,
                      color: Colors.white,
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildShimmerPopularProducts() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            width: 150,
            height: 20,
            color: Colors.white,
          ),
        ),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.65,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemCount: 4,
          itemBuilder: (context, index) {
            return Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildBanner() {
    return SizedBox(
      height: 180,
      child: PageView.builder(
        controller: _pageController,
        onPageChanged: (int page) {
          setState(() {
            _currentPage = page;
          });
        },
        itemCount: 2,
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 10),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(
                'assets/images/gasBanner${index + 1}.png',
                fit: BoxFit.cover,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildPopularProducts() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'Popular Products',
            style: GoogleFonts.roboto(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.65,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemCount: 4,
          itemBuilder: (context, index) {
            List<String> products = [
              'Induction',
              'LPG Gas',
              'CNG Gas',
              'Gas Stove'
            ];
            List<String> images = [
              'induction.png',
              'lpg.png',
              'cng.png',
              'gasStove.png'
            ];
            return Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Expanded(
                    flex: 2,
                    child: Image.asset(
                      'assets/images/${images[index]}',
                      fit: BoxFit.cover,
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            products[index],
                            style:
                                GoogleFonts.roboto(fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            'Product description is coming here...',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.roboto(fontSize: 12),
                            textAlign: TextAlign.left,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                'Price : ',
                                style: GoogleFonts.roboto(
                                    color: Colors.black,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                '1250',
                                style: GoogleFonts.roboto(
                                    color: Colors.green,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                'Security deposit : ',
                                style: GoogleFonts.roboto(
                                    color: Colors.black,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                '500',
                                style: GoogleFonts.roboto(
                                    color: Colors.green,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}
