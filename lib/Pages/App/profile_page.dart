import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:trendz_customer/Components/elevated_button.dart';
import 'package:trendz_customer/Pages/onboarding.dart';
import 'package:trendz_customer/Providers/user_provider.dart';
import 'package:trendz_customer/Screens/Profile/profile_page.dart';
import 'package:trendz_customer/Screens/Settings/mainSetting.dart';
import 'package:trendz_customer/widgets/main_navigation.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final secureStorage = const FlutterSecureStorage();
  String? _fullName;
  String? _email;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    // Read the full name from SecureStorage
    String? fullName = await secureStorage.read(key: "fullname");
    String? email = await secureStorage.read(key: "email");
    setState(() {
      _fullName = fullName;
      _email = email;
    });
  }

  @override
  Widget build(BuildContext context) {
    final userprovider = Provider.of<UserProvider>(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Profile",
          style: Theme.of(context)
              .textTheme
              .bodyMedium
              ?.copyWith(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              children: [
                Container(
                  height: 60,
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: CircleAvatar(
                          radius: 20,
                          backgroundImage:
                              AssetImage("lib/assets/images/profile.png"),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "$_fullName",
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          Text(
                            "$_email",
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                CustomNavigation(
                  navigationIcon: Icon(
                    Iconsax.devices,
                    color: Theme.of(context).primaryColor,
                  ),
                  navigationtitle: "App Updates",
                  navigate: () {
                    Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (context) =>
                            Mainsetting(), // Replace with your target page
                      ),
                    );
                  },
                ),
                CustomNavigation(
                  navigate: () {
                    Navigator.push(
                        context,
                        CupertinoPageRoute(
                            builder: (context) => Mainsetting()));
                    // Navigate to a settings page
                  },
                  navigationtitle: "Settings",
                  navigationIcon: Icon(
                    Iconsax.setting,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                CustomNavigation(
                  navigate: () {
                    // Navigate to a privacy policy page
                  },
                  navigationtitle: "Privacy Policy",
                  navigationIcon: Icon(
                    Iconsax.setting_4,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                CustomNavigation(
                  navigate: () {
                    // Navigate to a privacy policy page
                  },
                  navigationtitle: "App Updates",
                  navigationIcon: Icon(
                    Iconsax.cpu,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                CustomNavigation(
                  navigate: () {
                    // Navigate to a privacy policy page
                  },
                  navigationtitle: "Invite a Friend",
                  navigationIcon: Icon(
                    Iconsax.user,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  "App Version: 1.0.0",
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey,
                      ),
                ),
                const SizedBox(height: 10),
                CustomElevatedButton(
                  text: "Logout",
                  icon: Iconsax.logout4,
                  onPressed: () {
                    _showConfirmationDialog(context);
                    // await secureStorage.write(key: "token", value: "");
                    // Navigator.pushAndRemoveUntil(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) => Onboarding(),
                    //   ),
                    //   (route) => false,
                    // );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Logout'),
          content: const Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
              },
              child: Text(
                'Cancel',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                await secureStorage.write(key: "token", value: "");
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Onboarding(),
                  ),
                  (route) => false,
                );
              },
              child: Text(
                'Yes',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
          ],
        );
      },
    );
  }
}
