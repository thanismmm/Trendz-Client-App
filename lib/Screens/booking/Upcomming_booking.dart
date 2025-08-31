import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:trendz_customer/Components/elevated_button.dart';
import 'package:trendz_customer/Services/api_services.dart';

class UpcomingBookingsPage extends StatefulWidget {
  @override
  _UpcomingBookingsPageState createState() => _UpcomingBookingsPageState();
}

class _UpcomingBookingsPageState extends State<UpcomingBookingsPage> {
  final ApiService _apiService = ApiService();
  List<dynamic> _upcomingBookings = [];
  bool _isLoading = true;
  bool _isCancelling = false;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _loadUpcomingBookings();
  }

  Future<void> _loadUpcomingBookings() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = '';
      });
      
      final bookings = await _apiService.fetchPendingBookings();
      setState(() {
        _upcomingBookings = bookings;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = e.toString();
      });
    }
  }

  String _formatDateTime(String date) {
    try {
      final dateTime = DateTime.parse(date);
      return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    } catch (e) {
      return date;
    }
  }

  String _formatTime(String time) {
    try {
      final timeParts = time.split(':');
      final hour = int.parse(timeParts[0]);
      final minute = timeParts[1];
      final period = hour >= 12 ? 'PM' : 'AM';
      final displayHour = hour > 12 ? hour - 12 : hour;
      return '$displayHour:$minute $period';
    } catch (e) {
      return time;
    }
  }

  Future<void> _cancelBooking(int bookingId) async {
    String? reason = await showDialog<String>(
      context: context,
      builder: (context) {
        final TextEditingController reasonController = TextEditingController();
        return AlertDialog(
          title: const Text('Cancel Booking'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Are you sure you want to cancel this booking?'),
              const SizedBox(height: 16),
              TextField(
                style: const TextStyle(fontSize: 14),
                controller: reasonController,
                decoration:  const InputDecoration(
                  hintText: 'Enter cancellation reason (required)',
                  border: OutlineInputBorder(),
                  // labelText: 'Cancellation Reason', 
                ),
                maxLines: 3,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('No, Keep Booking', style: TextStyle(fontSize: 16)),
            ),
            ElevatedButton(
              onPressed: () {
                final reason = reasonController.text.trim();
                if (reason.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please enter a cancellation reason')),
                  );
                  return;
                }
                Navigator.pop(context, reason);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              child: const Text('Yes, Cancel Booking', style: TextStyle(fontSize: 16)),
            ),
          ],
        );
      },
    );

    if (reason != null && reason.isNotEmpty) {
      try {
        setState(() {
          _isCancelling = true;
        });
        
        await _apiService.cancelBooking(bookingId, reason);
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Booking cancelled successfully'),
            backgroundColor: Colors.green,
          ),
        );
        
        // Refresh the upcoming bookings list
        await _loadUpcomingBookings();
        
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to cancel booking: $e'),
            backgroundColor: Colors.red,
          ),
        );
      } finally {
        setState(() {
          _isCancelling = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Your Upcoming Bookings',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                
                if (_isLoading && _upcomingBookings.isEmpty)
                  const Center(child: CircularProgressIndicator())
                else if (_errorMessage.isNotEmpty && _upcomingBookings.isEmpty)
                  Center(
                    child: Column(
                      children: [
                        Text('Error: $_errorMessage'),
                        ElevatedButton(
                          onPressed: _loadUpcomingBookings,
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  )
                else if (_upcomingBookings.isEmpty)
                  const Center(child: Text('No upcoming bookings found'))
                else
                  Expanded(
                    child: RefreshIndicator(
                      onRefresh: _loadUpcomingBookings,
                      child: ListView.builder(
                        itemCount: _upcomingBookings.length,
                        itemBuilder: (context, index) {
                          final booking = _upcomingBookings[index];
                          final slot = booking['slots']?.isNotEmpty == true 
                              ? booking['slots'][0] 
                              : null;
                          
                          return Card(
                            color: Theme.of(context).cardColor,
                            margin: const EdgeInsets.symmetric(vertical: 6.0),
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                InkWell(
                                  onTap: () {
                                    _showQRCodeDialog(
                                      context, 
                                      booking["unique_reference"], 
                                      booking["unique_reference"], 
                                      booking["booking_number"].toString()
                                    );
                                  },
                                  child: QrImageView(
                                    data: booking["unique_reference"],
                                    backgroundColor: Colors.white,
                                    version: QrVersions.auto,
                                    size: 60.0,
                                  ),
                                ),
                                Expanded(
                                  child: ListTile(
                                    contentPadding:
                                        const EdgeInsets.symmetric(horizontal: 15),
                                    title: InkWell(
                                      onTap: () {
                                        _showBookingDetailsDialog(context, booking);
                                      },
                                      child: Text(
                                        "Reference: ${booking["unique_reference"]}",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium
                                            ?.copyWith(fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    subtitle: InkWell(
                                      onTap: () {
                                        _showBookingDetailsDialog(context, booking);
                                      },
                                      child: Text(
                                        "${_formatDateTime(booking["booking_date"])}${slot != null ? ' | ${_formatTime(slot["start_time"])}' : ''}\n"
                                        "Booking #${booking["booking_number"]}",
                                        style: Theme.of(context).textTheme.bodySmall,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ),
              ],
            ),
          ),
          
          if (_isCancelling)
            Container(
              color: Colors.black54,
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }

  void _showBookingDetailsDialog(BuildContext context, dynamic booking) {
    final services = booking['services'] as List<dynamic>? ?? [];
    final slot = booking['slots']?.isNotEmpty == true 
        ? booking['slots'][0] 
        : null;
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Theme.of(context).cardColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Container(
            width: 350,
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Booking Details",
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  "Reference: ${booking["unique_reference"]}",
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Text(
                  "Date: ${_formatDateTime(booking["booking_date"])}\n"
                  "Time: ${slot != null ? _formatTime(slot["start_time"]) : 'N/A'}\n"
                  "Booking #: ${booking["booking_number"]}\n"
                  "Total: LKR${booking["total_amount"]}",
                  style: Theme.of(context).textTheme.bodySmall,
                  textAlign: TextAlign.center,
                ),
                const Divider(height: 20),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Services:",
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 5),
                ...services.map<Widget>((service) {
                  return Container(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.check_circle,
                          color: Colors.green,
                          size: 18,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            "${service['name']} - LKR${service['price']}",
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
                const Divider(height: 20),
                Column(
                  children: [
                    const SizedBox(height: 8),
                    CustomElevatedButton(
                      backgroundColor: const Color.fromARGB(255, 255, 17, 0),
                      text: "Cancel Booking",
                      icon: Iconsax.pen_remove,
                      onPressed: () {
                        Navigator.of(context).pop();
                        _cancelBooking(booking['id']);
                      },
                    ),
                    const SizedBox(height: 4),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showQRCodeDialog(BuildContext context, String qrCodeData,
      String referenceNumber, String bookingNumber) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Theme.of(context).cardColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxHeight: 350,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    "Booking Details",
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Divider(thickness: 1, color: Theme.of(context).dividerColor),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Reference Number:", style: TextStyle(fontWeight: FontWeight.bold)),
                      Text(referenceNumber),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Booking Number:", style: TextStyle(fontWeight: FontWeight.bold)),
                      Text(bookingNumber),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: QrImageView(
                      data: qrCodeData,
                      backgroundColor: Colors.white,
                      version: QrVersions.auto,
                      size: 150.0,
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text("Close"),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}