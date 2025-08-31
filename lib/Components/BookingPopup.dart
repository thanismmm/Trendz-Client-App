import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:lottie/lottie.dart';

class BookingPopup extends StatelessWidget {
  final String bookingDate;
  final String bookingTime;
  final String bookingReference;
  // final String barber;
  final String bookingNumber;
  final VoidCallback onAcknowledge;

  const BookingPopup({
    super.key,
    required this.bookingDate,
    required this.bookingTime,
    required this.bookingReference,
    // required this.barber,
    required this.bookingNumber,
    required this.onAcknowledge,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Theme.of(context).cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      insetPadding: const EdgeInsets.all(20),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Animated Success Icon
                Lottie.asset(
                  'lib/assets/images/success.json', // Add a Lottie JSON file in your assets
                  width: 100,
                  height: 100,
                  repeat: false,
                ),
                const SizedBox(height: 16),
                Text(
                  "Your Booking is Confirmed!",
                  style: Theme.of(context)
                      .textTheme
                      .headlineSmall
                      ?.copyWith(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Text(
                  "Your booking details are as follows:",
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Booking Date:",
                        style: Theme.of(context).textTheme.bodyMedium),
                    Text(bookingDate,
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(fontWeight: FontWeight.bold)),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Booking Time:",
                        style: Theme.of(context).textTheme.bodyMedium),
                    Text(bookingTime,
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(fontWeight: FontWeight.bold)),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Reference No.:",
                        style: Theme.of(context).textTheme.bodyMedium),
                    Text(bookingReference,
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(fontWeight: FontWeight.bold)),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Branch:",
                        style: Theme.of(context).textTheme.bodyMedium),
                    Text("Maruthamunai",
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(fontWeight: FontWeight.bold)),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Booking queue No:",
                        style: Theme.of(context).textTheme.bodyMedium),
                    Text(bookingNumber,
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(fontWeight: FontWeight.bold)),
                  ],
                ),
                // Uncomment if you want to display the barber's name
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //   children: [
                //     Text("Barber:",
                //         style: Theme.of(context).textTheme.bodyMedium),
                //     Text(barber,
                //         style: Theme.of(context)
                //             .textTheme
                //             .bodyMedium
                //             ?.copyWith(fontWeight: FontWeight.bold)),
                //   ],
                // ),
                const SizedBox(height: 16),
                // QR Code
                QrImageView(
                    data: "$bookingReference",
                    version: QrVersions.auto,
                    size: 150.0,
                    backgroundColor: Theme.of(context).cardColor),
                const SizedBox(height: 16),
                ElevatedButton(
                    onPressed: (){
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24.0, vertical: 12.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      decoration:
                          BoxDecoration(color: Theme.of(context).primaryColor),
                      child: Center(
                        child: Text(
                          "Okay",
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(
                                  fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                      ),
                    ))
              ],
            ),
          ),
        ],
      ),
    );
  }
}
