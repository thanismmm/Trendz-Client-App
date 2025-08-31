import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:trendz_customer/Pages/onboarding.dart';
import 'package:trendz_customer/Screens/App/Home_screen.dart';

class Splashscreen extends StatefulWidget {
  const Splashscreen({super.key});

  @override
  _SplashscreenState createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {
  final secureStorage = FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    _navigateBasedOnToken();
  }

  Future<void> _navigateBasedOnToken() async {
    final token = await secureStorage.read(key: "token");

    // Add a delay of 1 second
    await Future.delayed(const Duration(milliseconds: 700));

    if (!mounted) return; // Avoid navigation if the widget is disposed
    if (token == null || token.isEmpty) {
      // Navigate to Onboarding screen if no token
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Onboarding()),
      );
    } else {
      // Navigate to HomeScreen if token exists
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          Theme.of(context).scaffoldBackgroundColor, // Set background color
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 60),
            // Title text
            Text("Trendz Hair Studio",
                style: Theme.of(context).textTheme.headlineLarge),
            const SizedBox(height: 10),
            // Subtitle text
            const Text(
              "Your Saloon Partner",
              style: TextStyle(
                fontSize: 16,
                color: Colors.white70, // Adjusted color for subtitle contrast
              ),
            ),
            const SizedBox(height: 230),
            // Logo centered below the text
            Center(
              child: Image.asset(
                "lib/assets/images/logo.png",
                width: 200, // Adjust the width as needed
                height: 200, // Adjust the height as needed
              ),
            ),
            const Spacer(), // Spacer to push the text at the bottom
            // Footer section
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Text(
                    "Powered by : SoftExpertz (PVT) Ltd",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white, // Adjusted color for footer contrast
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    "Version: 1.0.0",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white, // Adjusted color for footer contrast
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
