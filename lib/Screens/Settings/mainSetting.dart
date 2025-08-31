import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:trendz_customer/Screens/Settings/branch/branch_setting.dart';
import 'package:trendz_customer/Screens/Settings/theme/theme_setting.dart';
import 'package:trendz_customer/widgets/main_navigation.dart';

class Mainsetting extends StatelessWidget {
  const Mainsetting({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Settings",
          style: Theme.of(context)
              .textTheme
              .bodyMedium
              ?.copyWith(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 5,
            ),
            Text("General Settings",
                style: Theme.of(context).textTheme.labelMedium),
            SizedBox(
              height: 10,
            ),
            CustomNavigation(
                navigationtitle: "Theme Settings",
                navigationsubtitle:
                    "Adjust your app theme for your preference.",
                navigationIcon: Icon(Iconsax.sun_fog),
                navigate: () => {
                      Navigator.push(
                          context,
                          CupertinoPageRoute(
                              builder: (context) => ThemeSetting()))
                    }),
            CustomNavigation(
                navigationtitle: "Preferred Branch",
                navigationsubtitle:
                    "Adjust your branch according your preference.",
                navigationIcon: Icon(Iconsax.shop),
                navigate: () => {
                      Navigator.push(
                          context,
                          CupertinoPageRoute(
                              builder: (context) => BranchSetting()))
                    }),
            CustomNavigation(
                navigationtitle: "Notification Settings",
                navigationsubtitle:
                    "Schedule and mute and limit push notifications",
                navigationIcon: Icon(Iconsax.notification),
                navigate: () => {}),
            SizedBox(
              height: 10,
            ),
            Text("Security Settings",
                style: Theme.of(context).textTheme.labelMedium),
            SizedBox(
              height: 10,
            ),
            CustomNavigation(
                navigationtitle: "Security",
                navigationsubtitle: "Privacy and fingerprint lock",
                navigationIcon: Icon(Iconsax.shield),
                navigate: () => {}),
            CustomNavigation(
                navigationtitle: "Clear Cache",
                navigationsubtitle: "Clear app cache and restart app",
                navigationIcon: Icon(Iconsax.trash),
                navigate: () => {}),
            CustomNavigation(
                navigationtitle: "Rate TrendZ Hair Studio",
                navigationsubtitle: "Rate app and get points",
                navigationIcon: Icon(Iconsax.route_square),
                navigate: () => {}),
            const SizedBox(
              height: 4,
            ),
            Row(
              children: [
                Expanded(
                  child: Divider(
                      thickness: 1,
                      height: 1,
                      color: Theme.of(context).primaryColor?.withOpacity(0.4)),
                )
              ],
            ),
            const SizedBox(
              height: 4,
            ),
            CustomNavigation(
                navigationtitle: "Share App",
                navigationIcon: Icon(Iconsax.share),
                navigate: () => {}),
          ],
        ),
      ),
    );
  }
}
