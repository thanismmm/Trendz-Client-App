import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:trendz_customer/Components/elevated_button.dart';
import 'package:trendz_customer/Models/usermodel.dart';
import 'package:trendz_customer/Pages/onboarding.dart';
import 'package:trendz_customer/Providers/user_provider.dart';
import 'package:trendz_customer/Screens/App/Home_screen.dart';
import 'package:trendz_customer/Screens/auth/signup_screen.dart';
import 'package:trendz_customer/Services/auth_services.dart';
import 'package:trendz_customer/theming/app_colors.dart';
import 'package:trendz_customer/widgets/form_input.dart';
import 'package:trendz_customer/widgets/socialLogin.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _OnboardingState();
}

class _OnboardingState extends State<ForgotPassword> {
  final _formkey = GlobalKey<FormState>();
  TextEditingController emailcontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Trendz Hair Studio",
          style: Theme.of(context)
              .textTheme
              .titleLarge
              ?.copyWith(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
        iconTheme: IconThemeData(
          color: Theme.of(context)
              .cardColor, // Set the back button color to cardColor
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipPath(
            clipper: BottomRoundedClipper(),
            child: Container(
              height: 100,
              width: double.infinity,
              color: Theme.of(context).primaryColor,
              child: SafeArea(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 8),
                    Text(
                      "Forgot Password",
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(color: Colors.white),
                    )
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 25),
          Container(
            padding: const EdgeInsets.all(15),
            child: Form(
              key: _formkey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Forgot Password",
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                  const SizedBox(height: 35),
                  FormInput(
                    inputType: "email",
                    inputController: emailcontroller,
                    inputName: "Email",
                    placeHolder: "Enter Email",
                  ),
                  const SizedBox(height: 25),
                  CustomElevatedButton(
                      icon: Iconsax.message_2,
                      text: "Send Verification Mail",
                      onPressed: () => {
                            if (emailcontroller.text.isEmpty)
                              {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content:
                                            Text("Please Fill All Fields ")))
                              }
                          }),
                  const SizedBox(height: 35),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Expanded(
                        child: Divider(
                          height: 1,
                          color: AppColors.gold,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          "Do you know the password",
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                      const Expanded(
                        child: Divider(
                          height: 1,
                          color: AppColors.gold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Onboarding()),
                          );
                        },
                        child: const Text(
                          "Please Login",
                          style: TextStyle(color: AppColors.gold),
                        ),
                      ),
                      const SizedBox(width: 16), // Add space between the texts
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const SignupScreen()),
                          );
                        },
                        child: const Text(
                          "Please Register",
                          style: TextStyle(color: AppColors.gold),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class BottomRoundedClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height - 45); // Bottom-left edge
    path.quadraticBezierTo(
      size.width / 2, // Control point (x)
      size.height + 45, // Control point (y)
      size.width, // End point (x)
      size.height - 45, // End point (y)
    );
    path.lineTo(size.width, 0); // Top-right edge
    path.close(); // Close the path
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
