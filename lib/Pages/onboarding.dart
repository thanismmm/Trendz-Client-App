import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:trendz_customer/Components/elevated_button.dart';
import 'package:trendz_customer/Models/usermodel.dart';
import 'package:trendz_customer/Providers/user_provider.dart';
import 'package:trendz_customer/Screens/App/Home_screen.dart';
import 'package:trendz_customer/Screens/auth/forgot_password.dart';
import 'package:trendz_customer/Screens/auth/signup_screen.dart';
import 'package:trendz_customer/Services/auth_services.dart';
import 'package:trendz_customer/theming/app_colors.dart';
import 'package:trendz_customer/widgets/form_input.dart';
import 'package:trendz_customer/widgets/socialLogin.dart';

class Onboarding extends StatefulWidget {
  Onboarding({super.key});

  final securestorage = FlutterSecureStorage();

  @override
  State<Onboarding> createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  final _formkey = GlobalKey<FormState>();
  final TextEditingController emailcontroller = TextEditingController();
  final TextEditingController passwordcontroller = TextEditingController();

  bool isButtonDisabled = true;
  bool _isLoading = false;

  Future<void> handleLogin(BuildContext context,
      Future<Map<String, dynamic>> Function() loginMethod) async {
    setState(() {
      _isLoading = true;
    });
    
    try {
      final response = await loginMethod();
      final user = User.fromJson(response);
      print(user.message.toString());

      await widget.securestorage.write(key: "token", value: user.token);
      await widget.securestorage.write(key: "saloon_id", value: 1.toString());
      await widget.securestorage.write(key: "userid", value: user.data?.id.toString());
      await widget.securestorage.write(key: "fullname", value: user.data?.name);
      await widget.securestorage.write(key: "email", value: user.data?.email);

      Provider.of<UserProvider>(context, listen: false).setUser(user);
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
        (Route<dynamic> route) => false,
      );
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    // Add listeners to check for field updates
    emailcontroller.addListener(_checkFormValidity);
    passwordcontroller.addListener(_checkFormValidity);
  }

  @override
  void dispose() {
    emailcontroller.dispose();
    passwordcontroller.dispose();
    super.dispose();
  }

  void _checkFormValidity() {
    final isFormValid =
        emailcontroller.text.isNotEmpty && passwordcontroller.text.isNotEmpty;
    if (isButtonDisabled != !isFormValid) {
      setState(() {
        isButtonDisabled = !isFormValid;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipPath(
            clipper: BottomRoundedClipper(),
            child: Container(
              height: 150,
              width: double.infinity,
              color: Theme.of(context).primaryColor,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 8),
                  Text(
                    "Welcome To Trendz",
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(color: Colors.white),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    "Signin to continue",
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(color: Colors.white),
                  )
                ],
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
                    "Login",
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
                  FormInput(
                    obscureText: true,
                    inputType: "password",
                    inputController: passwordcontroller,
                    inputName: "Password",
                    placeHolder: "Enter Password",
                    showPasswordRequirements: false,
                  ),
                  const SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () => {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const ForgotPassword()))
                        },
                        child: Text(
                          "Forgot Password?",
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 25),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: _isLoading
                        ? ElevatedButton(
                            onPressed: null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(context).primaryColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            ),
                          )
                        : CustomElevatedButton(
                            icon: Iconsax.login,
                            text: "Login",
                            onPressed: isButtonDisabled
                                ? null
                                : () => handleLogin(
                                      context,
                                      () => AuthService().loginWithEmailPassword(
                                        emailcontroller.text,
                                        passwordcontroller.text,
                                      ),
                                    ),
                          ),
                  ),
                  const SizedBox(height: 25),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Don't Have an Account?",
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      GestureDetector(
                        onTap: () => {
                          Navigator.push(
                              context,
                              CupertinoPageRoute(
                                  builder: (context) => const SignupScreen()))
                        },
                        child: const Text(
                          "Register",
                          style: TextStyle(color: AppColors.gold),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 45,
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