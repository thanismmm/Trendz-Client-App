import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:trendz_customer/Components/elevated_button.dart';
import 'package:trendz_customer/Models/customer_location_modal.dart';
import 'package:trendz_customer/Pages/onboarding.dart';
import 'package:trendz_customer/Services/api_services.dart';
import 'package:trendz_customer/theming/app_colors.dart';
import 'package:trendz_customer/widgets/form_input.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  bool _obscureConfirmText = true;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController fullNameController = TextEditingController();
  List<CustomerLocationModal>? locationlist = [];
  String mobileNumber = ''; // To store the complete phone number
  String selectedLocation = "Maruthamunai";
  int selectedLocationid = 1;
  String? selectedGender;
  bool _isLoading = false; // Added loading state

  // Add a flag to track if confirm password has been validated
  bool confirmPasswordValidated = false;

  bool isUpperCase = false;
  bool isLowerCase = false;
  bool isNumber = false;
  bool isSpecialChar = false;
  bool isMinLength = false;

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return null; // Don't show error for empty field
    }
    if (value != passwordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  void _handleRegister() async {
    // Check if passwords match
    if (passwordController.text != confirmPasswordController.text) {
      setState(() {
        confirmPasswordValidated = true; // Show validation error
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Passwords do not match",
            style: Theme.of(context).textTheme.titleSmall,
          ),
          backgroundColor: Colors.red,
        ),
      );
      return; // Exit the function early
    }

    setState(() {
      _isLoading = true;
    });

    try {
      var result = await ApiService().RegisterWithEmailPassword(
        emailController.text,
        selectedLocationid,
        fullNameController.text,
        mobileNumber,
        selectedGender!,
        passwordController.text,
      );

      print(result);

      if (result["success"] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Registration Successful",
              style: Theme.of(context).textTheme.titleSmall,
            ),
            backgroundColor: const Color.fromARGB(255, 71, 218, 76),
          ),
        );
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Onboarding()),
        );
      } else {
        // Check if the error is about email already existing
        if (result["message"] != null &&
            (result["message"].toString().toLowerCase().contains("email") ||
                result["message"].toString().toLowerCase().contains("exist"))) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Your email is already exist"),
              backgroundColor: Colors.red,
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(result["message"]),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      // Handle any other errors
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Your email is already exist"),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> fetchLocation() async {
    try {
      final response = await ApiService().fetchlocation();
      setState(() {
        locationlist = response.data;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    fetchLocation();

    // Add listeners to update validation when passwords change
    passwordController.addListener(() {
      if (confirmPasswordValidated) {
        setState(() {}); // Revalidate when password changes
      }
    });

    confirmPasswordController.addListener(() {
      if (confirmPasswordController.text.isNotEmpty) {
        setState(() {
          confirmPasswordValidated = true;
        });
      }
    });
  }

  @override
  void dispose() {
    passwordController.removeListener(() {});
    confirmPasswordController.removeListener(() {});
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
            onPressed: () {
              Navigator.of(context).pop();
            },
            tooltip: "Go Back",
          ),
          title: Text(
            "Welcome To Trendz",
            style: Theme.of(context)
                .textTheme
                .titleLarge
                ?.copyWith(color: Colors.white),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipPath(
                clipper: BottomRoundedClipper(),
                child: Container(
                  height: 100,
                  width: double.infinity,
                  color: Theme.of(context).primaryColor,
                  child: Center(
                    child: Text(
                      "Register to continue",
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(color: Colors.white),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 25),
              Container(
                padding: const EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Register",
                        style: Theme.of(context).textTheme.headlineLarge),
                    const SizedBox(height: 35),
                    FormInput(
                      inputController: fullNameController,
                      inputType: "text",
                      inputName: "Full Name",
                      placeHolder: "Enter Full Name",
                    ),
                    const SizedBox(height: 25),
                    FormInput(
                      inputController: emailController,
                      inputType: "email",
                      inputName: "Email ID",
                      placeHolder: "Enter Email ",
                    ),
                    const SizedBox(height: 25),
                    Text("Gender",
                        style: Theme.of(context).textTheme.bodyMedium),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Radio(
                                activeColor: Theme.of(context).primaryColor,
                                value: 'Male',
                                groupValue: selectedGender,
                                onChanged: (value) {
                                  setState(() {
                                    selectedGender = value.toString();
                                  });
                                },
                              ),
                              const Text('Male'),
                            ],
                          ),
                        ),
                        const SizedBox(
                          width: 15,
                        ),
                        SizedBox(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Radio(
                                activeColor: Theme.of(context).primaryColor,
                                value: 'Female',
                                groupValue: selectedGender,
                                onChanged: (value) {
                                  setState(() {
                                    selectedGender = value.toString();
                                  });
                                },
                              ),
                              const Text('Female'),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 25),
                    DropdownButtonFormField<String>(
                      style: Theme.of(context).textTheme.bodyMedium,
                      value: selectedLocation,
                      decoration: InputDecoration(
                          isDense: true,
                          labelText: "Residence City",
                          labelStyle: Theme.of(context).textTheme.bodyMedium,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                            color: Theme.of(context).primaryColor,
                          ))),
                      items: locationlist?.map((location) {
                            return DropdownMenuItem<String>(
                              value: location.name,
                              child: Text(location.name ?? "Unknown"),
                            );
                          }).toList() ??
                          [], // Handle null list by providing an empty list
                      onChanged: (value) {
                        setState(() {
                          selectedLocationid = locationlist!
                              .firstWhere((element) => element.name == value)
                              .id!;
                          selectedLocation = value!;
                        });
                      },
                    ),
                    const SizedBox(height: 25),
                    FormInput(
                      inputName: 'Password',
                      placeHolder: 'Create a password',
                      inputController: passwordController,
                      inputType: 'password',
                      obscureText: true,
                      showPasswordRequirements:
                          true, // Show password rules for registration
                    ),
                    const SizedBox(height: 20),
                    // Custom confirm password field without the always-showing error
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextFormField(
                          controller: confirmPasswordController,
                          obscureText: _obscureConfirmText,
                          style: Theme.of(context).textTheme.bodyMedium,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16.0,
                              vertical: 12.0,
                            ),
                            hintText: "Re-enter Password",
                            hintStyle: Theme.of(context).textTheme.bodySmall,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Theme.of(context).primaryColor,
                                width: 2.0,
                              ),
                            ),
                            errorBorder: const OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.red,
                              ),
                            ),
                            focusedErrorBorder: const OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.red,
                                width: 2.0,
                              ),
                            ),
                            errorText: confirmPasswordValidated
                                ? _validateConfirmPassword(
                                    confirmPasswordController.text)
                                : null,
                            errorStyle: const TextStyle(
                              fontSize: 12,
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscureConfirmText
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscureConfirmText = !_obscureConfirmText;
                                });
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 25),
                    IntlPhoneField(
                      style: Theme.of(context).textTheme.bodySmall,
                      decoration: InputDecoration(
                        labelStyle: Theme.of(context).textTheme.bodySmall,
                        labelText: 'Mobile Number',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide:
                              BorderSide(color: Theme.of(context).primaryColor),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide:
                              BorderSide(color: Theme.of(context).primaryColor),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(
                            color: Theme.of(context).primaryColor,
                            width: 2.0,
                          ),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(
                            color: Colors.red,
                            width: 2.0,
                          ),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(
                            color: Colors.red,
                            width: 2.0,
                          ),
                        ),
                      ),
                      initialCountryCode: 'LK',
                      onChanged: (phone) {
                        setState(() {
                          mobileNumber = phone.completeNumber;
                        });
                      },
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
                              icon: Iconsax.login_1,
                              text: "Register",
                              onPressed: _handleRegister,
                            ),
                    ),
                    const SizedBox(height: 25),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Already have an account?",
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        const SizedBox(width: 5),
                        GestureDetector(
                          onTap: () => {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Onboarding(),
                              ),
                            )
                          },
                          child: const Text(
                            "Login",
                            style: TextStyle(
                              color: AppColors.gold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 25),
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

class BottomRoundedClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height - 45);
    path.quadraticBezierTo(
      size.width / 2,
      size.height + 45,
      size.width,
      size.height - 45,
    );
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}