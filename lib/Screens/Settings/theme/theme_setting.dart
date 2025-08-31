import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:trendz_customer/Providers/theme_provider.dart';

class ThemeSetting extends StatefulWidget {
  const ThemeSetting({super.key});

  @override
  State<ThemeSetting> createState() => _ThemeSettingState();
}

class _ThemeSettingState extends State<ThemeSetting> {
  final secureStorage = const FlutterSecureStorage();

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Theme Settings",
          style: Theme.of(context)
              .textTheme
              .bodyMedium
              ?.copyWith(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          ListTile(
            tileColor: themeProvider.themeMode == ThemeMode.light
                ? Theme.of(context)
                    .shadowColor // Set the background color for light theme
                : null,
            title: const Text("Light Theme"),
            onTap: () {
              // Change to light theme if not already
              if (themeProvider.themeMode != ThemeMode.light) {
                themeProvider.setTheme(ThemeMode.light);
                secureStorage.write(key: "theme", value: "light");
              }
            },
            titleTextStyle: Theme.of(context).textTheme.bodyMedium,
          ),
          ListTile(
            tileColor: themeProvider.themeMode == ThemeMode.dark
                ? Theme.of(context)
                    .shadowColor // Set the background color for dark theme
                : null,
            title: const Text("Dark Theme"),
            onTap: () {
              // Change to dark theme if not already
              if (themeProvider.themeMode != ThemeMode.dark) {
                themeProvider.setTheme(ThemeMode.dark);
                secureStorage.write(key: "theme", value: "dark");
              }
            },
            titleTextStyle: Theme.of(context).textTheme.bodyMedium,
          ),
          ListTile(
            tileColor: themeProvider.themeMode == ThemeMode.system
                ? Theme.of(context)
                    .shadowColor // Set the background color for system theme
                : null,
            title: const Text("Rely on System"),
            onTap: () {
              // Change to system theme if not already
              if (themeProvider.themeMode != ThemeMode.system) {
                themeProvider.setTheme(ThemeMode.system);
                secureStorage.write(key: "theme", value: "system");
              }
            },
            titleTextStyle: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}
