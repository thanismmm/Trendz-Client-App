import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trendz_customer/Pages/splashScreen.dart';
import 'package:trendz_customer/Providers/theme_provider.dart';
import 'package:trendz_customer/Providers/user_provider.dart';
import 'package:trendz_customer/theming/dark_theme.dart';
import 'package:trendz_customer/theming/light_theme.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ChangeNotifierProvider(create: (_) => UserProvider())
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return MaterialApp(
        title: 'TrendZ Hair Studio',
        debugShowCheckedModeBanner: false,
        theme: lightTheme,
        // darkTheme: darkTheme,
        // themeMode: themeProvider.themeMode,
        home: const Splashscreen());
  }
}
