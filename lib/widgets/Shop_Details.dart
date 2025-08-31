import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:iconsax/iconsax.dart';
import 'package:trendz_customer/Components/elevated_button.dart';
import 'package:url_launcher/url_launcher.dart';

class ShopDetails extends StatelessWidget {
  const ShopDetails({super.key});

  // Shop's actual latitude and longitude
  final double shopLatitude = 9.795676721865817;
  final double shopLongitude = 80.06756975406358;

  // Function to launch Google Maps with the shop location
  Future<void> _launchGoogleMaps() async {
    final Uri googleMapsUrl = Uri.parse(
        'https://www.google.com/maps?q=$shopLatitude,$shopLongitude'); // Google Maps URL format
    if (await canLaunchUrl(googleMapsUrl)) {
      await launchUrl(googleMapsUrl);
    } else {
      throw 'Could not open the map.';
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Show bottom sheet when shop details are tapped
        showModalBottomSheet(
          context: context,
          isScrollControlled: true, // Allow the sheet to take more space
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          builder: (context) {
            return SizedBox(
              height: MediaQuery.of(context).size.height * 0.3,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CloseButton(),
                    Text(
                      "Trendz Hair Studio",
                      style: Theme.of(context).textTheme.headlineLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Email: TrendzHairStudio@gmail.com",
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Contact: 077 98 98 445",
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    const SizedBox(height: 8),
                    CustomElevatedButton(
                        text: "Get Directions",
                        icon: Iconsax.location,
                        onPressed: _launchGoogleMaps)
                  ],
                ),
              ),
            );
          },
        );
      },
      child: Padding(
        padding: EdgeInsets.only(left: 15, right: 15, bottom: 15),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          decoration: BoxDecoration(
            color: Theme.of(context).focusColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: 70,
                child: Image.asset("lib/assets/images/logo.png"),
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Trendz Saloon",
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium
                              ?.copyWith(fontSize: 20),
                        ),
                        Text(
                          "153B, Akbar Road,",
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        Text(
                          "Maruthamunai, Sri Lanka",
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                    const Icon(Icons.location_on_outlined),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
