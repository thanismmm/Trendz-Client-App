import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:trendz_customer/Components/elevated_button.dart';
import 'package:trendz_customer/Components/homepage_preferred_modal.dart';
import 'package:trendz_customer/Models/service_modal.dart';
import 'package:trendz_customer/Pages/App/service_view_page.dart';
import 'package:trendz_customer/Pages/notification.dart';
import 'package:trendz_customer/Providers/theme_provider.dart';
import 'package:trendz_customer/widgets/Shop_Details.dart';
import 'package:trendz_customer/widgets/service_tiles.dart';

class HomePage extends StatefulWidget {
  final Function? onNavigateToServices;
  final Function? onNavigateToBookings;
  final List<Services>? services;
  const HomePage(
      {super.key,
      required this.services,
      this.onNavigateToBookings,
      this.onNavigateToServices});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Timer _carouselTimer;
  late final PageController _pageController;
  final secureStorage = const FlutterSecureStorage();

  int _currentPage = 0;
  String? _fullName;

  Future<void> _loadUserData() async {
    String? fullName = await secureStorage.read(key: "fullname");

    setState(() {
      if (fullName != null && fullName.contains(' ')) {
        _fullName = fullName.split(' ').last;
      } else {
        _fullName = fullName;
      }
    });
  }

  Future<void> _initializeApp() async {
    final String? firstTime = await secureStorage.read(key: 'first_time');

    if (firstTime == null) {
      await secureStorage.write(key: 'first_time', value: 'done');
      _showbottomSheets(context);
    }
  }

  void _showbottomSheets(BuildContext context) {
    showModalBottomSheet(
        useSafeArea: true,
        isDismissible: false,
        enableDrag: false,
        isScrollControlled: true,
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        builder: (builder) {
          return const HomepagePreferredModal();
        });
  }

  @override
  void initState() {
    super.initState();
    _initializeApp();
    _loadUserData();
    _pageController = PageController(viewportFraction: 0.9);

    // Start a timer to change the page every 2 seconds
    _carouselTimer = Timer.periodic(const Duration(seconds: 2), (timer) {
      if (_pageController.hasClients) {
        _currentPage++;
        _pageController.animateToPage(
          _currentPage % 3, // Loop through 3 pages
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _carouselTimer.cancel(); // Cancel the timer to avoid memory leaks
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    // final userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 30,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Welcome, $_fullName!",
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    Row(
                      children: [
                        IconButton(
                          onPressed: () => {themeProvider.toggleTheme()},
                          icon: themeProvider.themeMode == ThemeMode.light
                              ? const Icon(Iconsax.moon)
                              : const Icon(Iconsax.sun_1),
                        ),
                        IconButton(
                          onPressed: () => {
                            showModalBottomSheet(
                                isDismissible: true,
                                isScrollControlled: true,
                                useSafeArea: true,
                                useRootNavigator: true,
                                context: context,
                                builder: (builder) {
                                  return DraggableScrollableSheet(
                                    initialChildSize: 1, // Start at 40% height
                                    minChildSize: 0.3, // Minimum size
                                    maxChildSize: 1, // Maximum size
                                    expand: false,
                                    builder: (context, scrollController) {
                                      return SingleChildScrollView(
                                        controller: scrollController,
                                        child: const NotificationPage(),
                                      );
                                    },
                                  );
                                })
                          },
                          icon: const Icon(Iconsax.notification4),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Padding(
                padding: const EdgeInsets.only(
                    top: 10.0, left: 15, right: 15, bottom: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "#SpecialForYou",
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 1),
                child: SizedBox(
                  height: 180, // Set the height for the PageView
                  child: PageView(
                    controller: _pageController,
                    children: [
                      Container(
                          margin: const EdgeInsets.only(right: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: Theme.of(context).cardColor,
                          ),
                          width: MediaQuery.sizeOf(context).width - 25,
                          child: Image.asset(
                            "lib/assets/images/offer_1.jpg",
                            fit: BoxFit.cover,
                          )),
                      Container(
                          margin: const EdgeInsets.only(right: 10),
                          width: MediaQuery.sizeOf(context).width - 25,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: Theme.of(context).cardColor,
                          ),
                          child: Image.asset(
                            "lib/assets/images/offer_2.jpg",
                            fit: BoxFit.cover,
                          )),
                      Container(
                          margin: const EdgeInsets.only(right: 10),
                          width: MediaQuery.sizeOf(context).width - 25,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: Theme.of(context).cardColor,
                          ),
                          child: Image.asset(
                            "lib/assets/images/offer_3.jpg",
                            fit: BoxFit.cover,
                          )),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              // Padding(
              //   padding: const EdgeInsets.only(
              //       top: 15.0, left: 15, right: 15, bottom: 5),
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.center,
              //     children: [
              //       // Text(
              //       //   "Your Recent Bookings ",
              //       //   style: Theme.of(context)
              //       //       .textTheme
              //       //       .bodyMedium
              //       //       ?.copyWith(fontSize: 18, fontWeight: FontWeight.bold),
              //       // ),

              //     ],
              //   ),
              // ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 15),
                padding: const EdgeInsets.all(10),
                width: double.infinity,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Theme.of(context).cardColor),
                height: 120,
                child: Center(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    TextButton(
                        onPressed: () {
                          {widget.onNavigateToBookings!();};
                        },
                        child: Text(
                          "All Bookings",
                          style: Theme.of(context).textTheme.headlineSmall,
                        )),
                    // Text(
                    //   "Currently No Bookings ",
                    //   style: Theme.of(context).textTheme.bodyMedium,
                    // ),
                    // Text(
                    //   "Book Appoinments to show here",
                    //   style: Theme.of(context).textTheme.bodySmall,
                    // ),
                    // const SizedBox(
                    //   height: 20,
                    // ),
                    CustomElevatedButton(
                        text: "Book Appointment",
                        icon: Icons.sensor_occupied,
                        onPressed: () => {widget.onNavigateToServices!()})
                  ],
                )),
              ),
              const SizedBox(
                  // height: 5,
                  ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Popular Services",
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    TextButton(
                      onPressed: () => {widget.onNavigateToServices!()},
                      child: Text(
                        "All Services",
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                    ),
                  ],
                ),
              ),
              widget.services == null
                  ? const Center(child: CircularProgressIndicator())
                  : SizedBox(
                      height: MediaQuery.of(context).size.height *
                          0.22, // Increased height to accommodate text
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: widget.services?.length ?? 0,
                        itemBuilder: (context, index) {
                          final singleservice = widget.services![index];
                          return Padding(
                            padding: const EdgeInsets.only(right: 10, left: 15),
                            child: Hero(
                              tag: singleservice.id!,
                              child: GestureDetector(
                                onTap: () {
                                  // Navigator.push(
                                  //   context,
                                  //   MaterialPageRoute(
                                  //     // (
                                  //       // tag: singleservice.id!.toString(),
                                  //       // serviceName: singleservice.name,
                                  //       // price: singleservice.price,
                                  //       // imageurl: singleservice.icon,
                                  //     // ),
                                  //   ),
                                  // );
                                },
                                child: ModernServiceTile(
                                  serviceName: singleservice.name,
                                  price: singleservice.price,
                                  imageurl: singleservice.icon,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15),
                child: Row(
                  children: [
                    Text("Shop Details ",
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              const ShopDetails()
            ],
          ),
        ),
      ),
    );
  }
}
