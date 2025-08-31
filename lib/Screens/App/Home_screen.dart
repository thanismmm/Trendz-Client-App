import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:iconsax/iconsax.dart';
import 'package:trendz_customer/Models/service_modal.dart';
import 'package:trendz_customer/Models/shop_details_modal.dart';
import 'package:trendz_customer/Pages/App/Home_page.dart';
import 'package:trendz_customer/Pages/App/Service_page.dart';
import 'package:trendz_customer/Pages/App/booking_page.dart';
import 'package:trendz_customer/Pages/App/cart_page.dart';
import 'package:trendz_customer/Pages/App/profile_page.dart';
import 'package:trendz_customer/Services/api_services.dart';
import 'package:trendz_customer/theming/app_colors.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ApiService apiService = ApiService();
  final securestorage = const FlutterSecureStorage();
  String selectedDate = "Select Date";
  String? saloon_id;
  String selectedLocation = ""; // Shared state for branch
  late ShopDetails shopdetails;
  List<Services>? services;
  List<Services>? selectedServices;
  bool isLoading = true;

  int _selectedPageIndex = 0; // Tracks the currently selected page
  final PageController _pageController =
      PageController(); // Controls the PageView

  // Cached data to avoid re-fetching on app restart
  List<Services>? cachedServices;
  ShopDetails? cachedShopDetails;

  void _updateDateAndLocation(String date, String location,
      List<Services> selectedServicesFromServicePage) {
    setState(() {
      selectedDate = date;
      selectedLocation = location;
      selectedServices = selectedServicesFromServicePage;
    });
  }

  // Navigate to a page using PageView animation
  void _onNavTap(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
    _pageController.jumpToPage(index); // Jump to the specified page
  }

  // Update the selected index when the page changes
  void _onPageChange(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    selectedServices = [];
    _initializeData();
  }

  Future<void> _initializeData() async {
    saloon_id = await securestorage.read(key: "saloon_id");

    // Check if services and shop details are cached in secure storage
    String? cachedServicesData = await securestorage.read(key: "services");
    String? cachedShopDetailsData =
        await securestorage.read(key: "shopDetails");

    if (cachedServicesData != null && cachedShopDetailsData != null) {
      // Parse cached data
      List<dynamic> servicesList = json.decode(cachedServicesData);
      cachedServices = servicesList.map((e) => Services.fromJson(e)).toList();
      cachedShopDetails =
          ShopDetails.fromJson(json.decode(cachedShopDetailsData));

      // Use cached data if available
      setState(() {
        services = cachedServices;
        shopdetails = cachedShopDetails!;
        isLoading = false;
      });
    } else {
      // Fetch and cache data if not already cached
      _fetchServices();
      _fetchShopDetails();
    }
  }

  Future<void> _fetchServices() async {
    final id = await securestorage.read(key: "saloon_id");
    // Fetch services from the API
    services = await apiService.fetchServices(int.parse(id ?? "1"));

    // Cache the services to FlutterSecureStorage
    await securestorage.write(
        key: "services",
        value: json.encode(services!.map((e) => e.toJson()).toList()));

    setState(() {
      cachedServices = services; // Cache the services
      isLoading = false; // Data is loaded, set loading to false
    });
  }

  Future<void> _fetchShopDetails() async {
    final id = await securestorage.read(key: "saloon_id");
    shopdetails = await apiService.fetchshopDetails(int.parse(id ?? "1"));

    // Cache the shop details to FlutterSecureStorage
    await securestorage.write(
        key: "shopDetails", value: json.encode(shopdetails.toJson()));

    setState(() {
      cachedShopDetails = shopdetails; // Cache the shop details
      isLoading = false; // Data is loaded, set loading to false
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ), // Show a loading spinner
      );
    }

    final List<Widget> _pages = [
      HomePage(
        services: services,
        onNavigateToBookings: () => _onNavTap(3),
        onNavigateToServices: () => _onNavTap(1),
      ),
      ServicePage(
        servicesFromHomeScreen: services,
        onNavigateToCart: (String date, String location,
            List<Services> selectedServicesFromServicePage) {
          _updateDateAndLocation(
              date, location, selectedServicesFromServicePage);
          _onNavTap(2); // Navigate to CartPage
        },
        onServicesUpdated: (List<Services>? newServices) {
          setState(() {
            services = newServices;
            cachedServices = newServices;
          });
        },
      ),
      CartPage(
        selectedServicesFromServicePage: selectedServices,
        selectedDate: selectedDate,
        selectedLocation: selectedLocation,
      ),
      const BookingPage(),
      const ProfilePage(),
    ];

    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged:
            _onPageChange, // Syncs the BottomNavigationBar with PageView
        children: _pages,
        physics:
            const NeverScrollableScrollPhysics(), // Disables swipe navigation
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Iconsax.home_2), label: "Home"),
          BottomNavigationBarItem(
              icon: Icon(Iconsax.activity4), label: "Services"),
          BottomNavigationBarItem(
              icon: Icon(Iconsax.shopping_cart), label: "Cart"),
          BottomNavigationBarItem(
              icon: Icon(Iconsax.receipt), label: "My Bookings"),
          BottomNavigationBarItem(
              icon: Icon(Iconsax.frame_1), label: "Profile"),
        ],
        currentIndex: _selectedPageIndex, // Highlights the selected tab
        selectedItemColor: AppColors.gold, // Active tab color
        unselectedItemColor: Colors.grey, // Inactive tab color
        showUnselectedLabels: true, // Show labels for inactive tabs
        onTap: (index) {
          _onNavTap(index); // Navigate to the selected page
        },
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose(); // Dispose of PageController to free resources
    super.dispose();
  }
}
