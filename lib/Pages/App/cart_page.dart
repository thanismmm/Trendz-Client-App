import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:trendz_customer/Components/BookingPopup.dart';
import 'package:trendz_customer/Models/service_modal.dart';
import 'package:trendz_customer/Services/api_services.dart';

class CartPage extends StatefulWidget {
  final String selectedLocation;
  final String selectedDate;
  final List<Services>? selectedServicesFromServicePage;

  const CartPage({
    super.key,
    this.selectedServicesFromServicePage,
    required this.selectedDate,
    required this.selectedLocation,
  });

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  // Add these helper methods to your _CartPageState class
  String _formatDateForApi(String dateString) {
    try {
      final parts = dateString.split('/');
      if (parts.length == 3) {
        final day = parts[0].padLeft(2, '0');
        final month = parts[1].padLeft(2, '0');
        final year = parts[2];
        return '$year-$month-$day'; // Format: YYYY-MM-DD
      }
      return dateString;
    } catch (e) {
      return dateString;
    }
  }

  String _extractTimeFromSlot(String timeSlot) {
    // Extract just the start time from the formatted time slot
    // Example: "9:00 AM - 10:00 AM" -> "9:00 AM"
    final parts = timeSlot.split(' - ');
    return parts.isNotEmpty ? parts[0] : timeSlot;
  }

  final ApiService apiService = ApiService();
  final secureStorage = FlutterSecureStorage();
  bool _isBottomBarExpanded = false;

  List<dynamic> apiTimeSlots = [];
  List<Services> selectedServices = [];
  String? saloonId;
  int? selectedBarberIndex;
  int? selectedSlotId;
  String selectedTime = "Not Selected";
  bool isLoading = false;
  double bookingFee = 0.0;

  List<Map<String, dynamic>> barbers = [];

  String _buildImageUrl(String imagePath) {
    if (imagePath.startsWith('http')) {
      return imagePath;
    }
    return 'http://35.169.19.237/$imagePath';
  }

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    setState(() => isLoading = true);

    try {
      saloonId = await secureStorage.read(key: "saloon_id");
      selectedServices = widget.selectedServicesFromServicePage
              ?.where((service) => service.isSelected ?? false)
              .toList() ??
          [];

      if (saloonId != null) {
        await Future.wait([
          _fetchShopWithBarbers(),
          _fetchTimeSlots(),
          _loadBookingFee(),
        ]);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading data: $e')),
      );
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  Future<void> _loadBookingFee() async {
    final shopData =
        await apiService.fetchShopWithBarbers(int.parse(saloonId!));
    setState(
        () => bookingFee = double.parse(shopData['booking_fees'] ?? "0.00"));
  }

  Future<void> _fetchShopWithBarbers() async {
    try {
      if (saloonId == null) return;

      final shopData =
          await apiService.fetchShopWithBarbers(int.parse(saloonId!));

      setState(() {
        barbers = (shopData['barbers'] as List).map((barber) {
          return {
            'id': barber['id'],
            'name': barber['name'] ?? 'No Name',
            'profile': barber['image'] != null
                ? _buildImageUrl(barber['image'])
                : 'assets/images/default_barber.png',
            'specialty': barber['description'] ?? 'General Barbering',
            'is_available': (barber['is_available'] as int?) == 1,
          };
        }).toList();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load barbers: $e')),
      );
    }
  }

  Future<void> _fetchTimeSlots() async {
    try {
      final result = await apiService.fetchTimeSlot();
      setState(() => apiTimeSlots = result);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load time slots: $e')),
      );
    }
  }

  void _selectTime(String timeSlot, int slotId) {
    setState(() {
      selectedTime = timeSlot;
      selectedSlotId = slotId;
    });
  }

  void _handleBooking() {
    if (widget.selectedDate == "Select Date" ||
        selectedTime == "Not Selected" ||
        selectedServices.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select all fields")),
      );
      return;
    }
    _showConfirmationDialog();
  }

  int get _totalPrice {
    final servicesTotal = selectedServices.fold(0, (sum, service) {
      // Convert price string to double, then to int
      final priceValue = double.tryParse(service.price) ?? 0.0;
      return sum + priceValue.toInt();
    });

    return servicesTotal + bookingFee.toInt();
  }

  String _formatTime(String timeString) {
    try {
      final timeParts = timeString.split(':');
      if (timeParts.length >= 2) {
        int hour = int.parse(timeParts[0]);
        final minute = timeParts[1];
        final period = hour >= 12 ? 'PM' : 'AM';
        hour = hour > 12 ? hour - 12 : hour;
        hour = hour == 0 ? 12 : hour;
        return '$hour:$minute $period';
      }
      return timeString;
    } catch (e) {
      return timeString;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Booking Summary",
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 0,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _buildBarberCard(theme), // Keep barber card
                  const SizedBox(height: 16),
                  _buildServicesCard(theme),
                  const SizedBox(height: 16),
                  _buildTimeSlotCard(theme),
                  const SizedBox(height: 80),
                ],
              ),
            ),
      bottomSheet: _buildExpandableBottomBar(theme, colorScheme),
    );
  }

  Widget _buildExpandableBottomBar(ThemeData theme, ColorScheme colorScheme) {
    final servicesTotal = selectedServices.fold(0, (sum, service) {
      return sum + int.parse(service.price.split(".")[0]);
    });
    final totalWithFee = servicesTotal + bookingFee.toInt();
    final barberName = selectedBarberIndex != null
        ? barbers[selectedBarberIndex!]['name']
        : 'Not Selected';

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      height: _isBottomBarExpanded ? 300 : 90,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: Colors.grey.shade200),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SingleChildScrollView(
        child: Padding(
          
          padding: const EdgeInsets.all(10),
          
          child: Column(
            children: [
              // Summary Header (always visible)
              GestureDetector(
                onTap: () {
                  setState(() {
                    _isBottomBarExpanded = !_isBottomBarExpanded;
                  });
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Text(
                        //   "${selectedServices.length} service(s)",
                        //   style: theme.textTheme.bodyLarge,
                        // ),
                        Text(
                          "Total: LKR $totalWithFee",
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                    Icon(
                      _isBottomBarExpanded
                          ? Icons.keyboard_arrow_down
                          : Icons.keyboard_arrow_up,
                      color: colorScheme.primary,
                      size: 28,
                    ),
                  ],
                ),
              ),
        
              // Expandable Content
              if (_isBottomBarExpanded) ...[
                const SizedBox(height: 16),
                const Divider(),
                const SizedBox(height: 16),
                _buildBookingDetails(theme),
                const SizedBox(height: 16),
              ],
        
              // Confirm Button (always visible)
              SizedBox(
                width: double.infinity,
                height: 40,
                child: ElevatedButton(
                  onPressed: _handleBooking,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    "Confirm Booking",
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
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

  Widget _buildBookingDetails(ThemeData theme) {
    final servicesTotal = selectedServices.fold(0, (sum, service) {
      final priceValue = double.tryParse(service.price) ?? 0.0;
      return sum + priceValue.toInt();
    });

    final barberName = selectedBarberIndex != null
        ? barbers[selectedBarberIndex!]['name']
        : 'Not Selected';

    return Column(
      children: [
        // Barber Details (optional)
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Barber", style: theme.textTheme.bodyMedium),
            Text(
              barberName,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: selectedBarberIndex == null ? Colors.grey : Colors.black,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Time Slot
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Time Slot", style: theme.textTheme.bodyMedium),
            Text(
              selectedSlotId != null ? selectedTime : "Not Selected",
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Services Total
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Services Total", style: theme.textTheme.bodyMedium),
            Text(
              "LKR $servicesTotal",
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Booking Fee
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Booking Fee", style: theme.textTheme.bodyMedium),
            Text(
              "LKR ${bookingFee.toStringAsFixed(2)}",
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildBarberCard(ThemeData theme) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  "Select Barber",
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  "(Optional)",
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.grey,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (barbers.isEmpty)
              const Center(child: Text("No barbers available"))
            else
              SizedBox(
                height: 120,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: barbers.asMap().entries.map((entry) {
                    final index = entry.key;
                    final barber = entry.value;
                    final isSelected = selectedBarberIndex == index;
                    final isAvailable = barber['is_available'] ?? true;

                    return GestureDetector(
                      onTap: isAvailable
                          ? () => setState(() => selectedBarberIndex = index)
                          : null,
                      child: Opacity(
                        opacity: isAvailable ? 1.0 : 0.5,
                        child: Container(
                          width: 100,
                          margin: const EdgeInsets.only(right: 12),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? theme.primaryColor.withOpacity(0.1)
                                : Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isSelected
                                  ? theme.primaryColor
                                  : Colors.grey.shade200,
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircleAvatar(
                                radius: 28,
                                backgroundImage:
                                    barber['profile'].startsWith('assets/')
                                        ? AssetImage(barber['profile'])
                                            as ImageProvider
                                        : NetworkImage(barber['profile']),
                                child: barber['profile']
                                            .endsWith('default_barber.png') ||
                                        barber['profile'].isEmpty
                                    ? const Icon(Icons.person, size: 28)
                                    : null,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                barber['name'],
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color:
                                      isAvailable ? Colors.black : Colors.grey,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              if (!isAvailable)
                                Text(
                                  "Not Available",
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: Colors.red,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildServicesCard(ThemeData theme) {
    if (widget.selectedServicesFromServicePage == null ||
        widget.selectedServicesFromServicePage!.isEmpty) {
      return Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Your Services",
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Center(
                child: Text(
                  "Services are not selected",
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.grey,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Your Services",
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            ...widget.selectedServicesFromServicePage!.map((service) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Checkbox(
                    value: service.isSelected ?? false,
                    onChanged: (value) {
                      setState(() {
                        service.isSelected = value;
                        if (value!) {
                          selectedServices.add(service);
                        } else {
                          selectedServices
                              .removeWhere((s) => s.name == service.name);
                        }
                      });
                    },
                    activeColor: theme.primaryColor,
                  ),
                  title: Text(service.name, style: theme.textTheme.bodyMedium),
                  trailing: Text(
                    "LKR ${service.price}",
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeSlotCard(ThemeData theme) {
    return SizedBox(
      width: double.infinity,
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Select Time Slot",
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              if (apiTimeSlots.isEmpty)
                const Center(child: CircularProgressIndicator())
              else
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: apiTimeSlots.map((slot) {
                    final startTime =
                        slot['start_time']?.toString() ?? '00:00:00';
                    final endTime = slot['end_time']?.toString() ?? '00:00:00';
                    final slotId = slot['id'] as int; // Get the slot ID
                    final displayText =
                        '${_formatTime(startTime)} - ${_formatTime(endTime)}';
                    final isSelected = selectedSlotId == slotId;

                    return FilterChip(
                      label: Text(displayText),
                      selected: isSelected,
                      onSelected: (_) => _selectTime(displayText, slotId),
                      selectedColor: theme.primaryColor.withOpacity(0.2),
                      checkmarkColor: theme.primaryColor,
                      labelStyle: theme.textTheme.bodyMedium?.copyWith(
                        color: isSelected ? theme.primaryColor : Colors.black,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: BorderSide(
                          color: isSelected
                              ? theme.primaryColor
                              : Colors.grey.shade300,
                        ),
                      ),
                    );
                  }).toList(),
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _showConfirmationDialog() {
    // Validate required fields (barber is optional now)
    if (selectedSlotId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select a time slot")),
      );
      return;
    }

    if (selectedServices.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select at least one service")),
      );
      return;
    }

    final barberName = selectedBarberIndex != null
        ? barbers[selectedBarberIndex!]['name']
        : 'Not selected';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Booking'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Are you sure you want to confirm this booking?'),
            const SizedBox(height: 16),
            Text('Total: LKR $_totalPrice'),
            Text('Barber: $barberName'),
            Text('Date: ${widget.selectedDate}'),
            Text('Time: $selectedTime'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(fontSize: 16),),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              await _createBooking();
            },
            child: const Text('Confirm Booking', style: TextStyle(fontSize: 16)),
          ),
        ],
      ),
    );
  }

  Future<void> _createBooking() async {
    try {
      setState(() => isLoading = true);

      if (selectedSlotId == null) {
        throw "Please select a time slot";
      }

      final formattedDate = _formatDateForApi(widget.selectedDate);

      final List<Map<String, dynamic>> services =
          selectedServices.map((service) {
        return {
          "service_id": service.id,
        };
      }).toList();

      // Get barber ID only if selected, otherwise send null
      final int? barberId = selectedBarberIndex != null
          ? barbers[selectedBarberIndex!]['id']
          : null;

      // Call the booking API with optional barber_id
      final response = await apiService.createBooking(
        shopId: int.parse(saloonId!),
        barberId: barberId, // This can be null
        bookingDate: formattedDate,
        slotId: selectedSlotId!,
        services: services,
        totalAmount: _totalPrice.toDouble(),
      );

      if (response['success'] == true) {
        final bookingData = response['booking'];
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => BookingPopup(
            bookingDate: widget.selectedDate,
            bookingTime: selectedTime,
            bookingReference: bookingData['unique_reference'] ?? "N/A",
            bookingNumber: bookingData['booking_number']?.toString() ?? "N/A",
            onAcknowledge: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
          ),
        );
      } else {
        throw Exception(response['message'] ?? 'Booking failed');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Booking failed: $e')),
      );
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }
}
