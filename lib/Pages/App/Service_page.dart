import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:iconsax/iconsax.dart';
import 'dart:convert';
import 'package:trendz_customer/Models/service_modal.dart';
import 'package:intl/intl.dart';
import 'package:trendz_customer/Services/api_services.dart';

class ServicePage extends StatefulWidget {
  final List<Services>? servicesFromHomeScreen;
  final Function(String date, String branch, List<Services> selectedServices)?
      onNavigateToCart;
  final Function(List<Services>? newServices)? onServicesUpdated;

  const ServicePage({
    Key? key,
    required this.servicesFromHomeScreen,
    this.onNavigateToCart,
    this.onServicesUpdated,
  }) : super(key: key);

  @override
  State<ServicePage> createState() => _ServicePageState();
}

class _ServicePageState extends State<ServicePage> {
  final ApiService apiService = ApiService();
  final securestorage = const FlutterSecureStorage();
  String? _fullname;

  List<Services>? services;
  bool isLoading = true;
  List<Services>? cachedServices;
  String? saloon_id;

  final Map<String, String> locationMap = {
    "Maruthamunai": "1",
    "Sainthamaruthu": "2",
  };

  Future<void> _fetchServices(String value) async {
    final id = await securestorage.read(key: "saloon_id");
    try {
      // Defensive: fallback to "1" if value is null or not a number
      final intValue = int.tryParse(value ?? "1");
      // If parsing fails, fallback to 1
      final safeIntValue = intValue ?? 1;
      // If the location is not found, don't call API, just clear services
      if (!locationMap.containsValue(value)) {
        setState(() {
          services = [];
          cachedServices = [];
          isLoading = false;
        });
        widget.onServicesUpdated?.call([]); // Notify HomeScreen
        return;
      }
      // Fetch services from the API
      services = await apiService.fetchServices(safeIntValue);

      // Cache the services to FlutterSecureStorage if not null
      if (services != null) {
        await securestorage.write(
            key: "services",
            value: json.encode(services!.map((e) => e.toJson()).toList()));
      }

      setState(() {
        cachedServices = services;
        isLoading = false;
      });
      widget.onServicesUpdated?.call(services); // Notify HomeScreen
    } catch (e) {
      setState(() {
        services = [];
        cachedServices = [];
        isLoading = false;
      });
      widget.onServicesUpdated?.call([]); // Notify HomeScreen
    }
  }

  Future<void> _initializeData() async {
    saloon_id = await securestorage.read(key: "saloon_id");
    if (widget.servicesFromHomeScreen != null) {
      setState(() {
        services = widget.servicesFromHomeScreen;
        cachedServices = widget.servicesFromHomeScreen;
        isLoading = false;
      });
    } else {
      String? cachedServicesData = await securestorage.read(key: "services");
      if (cachedServicesData != null) {
        List<dynamic> servicesList = json.decode(cachedServicesData);
        cachedServices = servicesList.map((e) => Services.fromJson(e)).toList();
        setState(() {
          services = cachedServices;
          isLoading = false;
        });
      } else {
        _fetchServices(saloon_id.toString());
      }
    }
  }

  Future<void> _loadUserData() async {
    String? fullname = await securestorage.read(key: "fullname");

    setState(() {
      _fullname = fullname;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _initializeData();
  }

  String selectedLocation = "Maruthamunai"; // Default branch
  String selectedDate = DateFormat('dd/MM/yyyy').format(DateTime.now());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(
          "Services",
          style: Theme.of(context)
              .textTheme
              .bodySmall
              ?.copyWith(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    // Greeting and instruction
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Hi $_fullname,",
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "Select the Services",
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            const SizedBox(height: 16),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Location Dropdown
                          Expanded(
                            flex: 1,
                            child: DropdownButtonFormField<String>(
                              value: locationMap.containsKey(selectedLocation)
                                  ? selectedLocation
                                  : locationMap.keys.first,
                              decoration: InputDecoration(
                                isDense: true,
                                labelText: "Location",
                                labelStyle:
                                    Theme.of(context).textTheme.bodyMedium,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                              ),
                              items: locationMap.keys
                                  .map((location) => DropdownMenuItem(
                                        value: location,
                                        child: Text(
                                          location,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall,
                                        ),
                                      ))
                                  .toList(),
                              onChanged: (value) async {
                                if (value == null ||
                                    !locationMap.containsKey(value)) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content:
                                            Text("Invalid location selected.")),
                                  );
                                  return;
                                }
                                final locId = locationMap[value];
                                if (locId == null) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content:
                                            Text("Location ID not found.")),
                                  );
                                  return;
                                }
                                await securestorage.write(
                                    key: "saloon_id",
                                    value: locId); // Store the ID
                                setState(() {
                                  selectedLocation = value;
                                });
                                await _fetchServices(locId);
                              },
                            ),
                          ),
                          const SizedBox(width: 10),

                          // Date Picker
                          Expanded(
                            flex: 1,
                            child: GestureDetector(
                              onTap: () async {
                                DateTime now = DateTime.now();
                                DateTime thirtyDaysLater =
                                    now.add(const Duration(days: 30));

                                DateTime? pickedDate = await showDatePicker(
                                  context: context,
                                  initialDate: now,
                                  firstDate: now,
                                  lastDate: thirtyDaysLater,
                                );

                                if (pickedDate != null) {
                                  setState(() {
                                    selectedDate =
                                        "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
                                  });
                                }
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12.0, vertical: 10.0),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                child: Text(
                                  selectedDate,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(
                                          color:
                                              Theme.of(context).primaryColor),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Services List
                    (!locationMap.containsKey(selectedLocation) ||
                            services == null ||
                            (services?.isEmpty ?? false))
                        ? Container(
                            height: MediaQuery.sizeOf(context).height - 200,
                            alignment: Alignment.center,
                            child: Text(
                              'The shop is not found!',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold,
                                  ),
                              textAlign: TextAlign.center,
                            ),
                          )
                        : SizedBox(
                            height: MediaQuery.sizeOf(context).height - 200,
                            child: ListView.builder(
                              scrollDirection: Axis.vertical,
                              itemCount: services?.length ?? 0,
                              itemBuilder: (context, index) {
                                final singleservice = services![index];
                                return Container(
                                  width: MediaQuery.sizeOf(context).width,
                                  child: Card(
                                    color: Theme.of(context).cardColor,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(12)),
                                    elevation: 3,
                                    child: ExpansionTile(
                                      leading: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          IconButton(
                                            icon: Icon(
                                              singleservice.isSelected!
                                                  ? Icons.check_circle
                                                  : Icons.circle_outlined,
                                              color: singleservice.isSelected!
                                                  ? Colors.green
                                                  : Colors.grey,
                                            ),
                                            onPressed: () {
                                              setState(() {
                                                singleservice.isSelected =
                                                    !singleservice.isSelected!;
                                              });
                                            },
                                          ),
                                          Image.asset(
                                            singleservice.icon,
                                            width: 40,
                                            height: 40,
                                            fit: BoxFit.cover,
                                          ),
                                        ],
                                      ),
                                      title: Text(
                                        singleservice.name,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium,
                                      ),
                                      subtitle: Text(
                                        "Rs. ${singleservice.price} ",
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall
                                            ?.copyWith(
                                                color: Theme.of(context)
                                                    .primaryColor),
                                      ),
                                      trailing: Icon(
                                        singleservice.isExpanded!
                                            ? Iconsax.arrow_up_2
                                            : Iconsax.arrow_down_1,
                                      ),
                                      onExpansionChanged: (isExpanded) {
                                        setState(() {
                                          singleservice.isExpanded = isExpanded;
                                        });
                                      },
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 8.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                  "Duration: ${singleservice.duration}"),
                                              const SizedBox(height: 4),
                                              Text(
                                                  "Description: ${singleservice.description}"),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                  ],
                ),
              ),
            ),
          ),

          // Bottom Button
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                if (selectedDate != "Select Date" &&
                    selectedLocation.isNotEmpty) {
                  List<Services> selectedServices = services
                          ?.where((service) => service.isSelected ?? false)
                          .toList() ??
                      [];
                  if (selectedServices.isNotEmpty) {
                    // Call the onNavigateToCart callback with selected date, location, and services
                    widget.onNavigateToCart?.call(
                        selectedDate, selectedLocation, selectedServices);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text("Please select at least one service")),
                    );
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text("Please select both date and location")),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                minimumSize: const Size(double.infinity, 50),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Next",
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 4),
                  const Icon(
                    Iconsax.arrow_right_3,
                    size: 16,
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
