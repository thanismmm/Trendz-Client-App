import 'package:flutter/material.dart';
import 'package:trendz_customer/Pages/onboarding.dart';
import 'package:trendz_customer/Screens/auth/signup_screen.dart';
import 'package:trendz_customer/theming/app_colors.dart';

class OtpVerification extends StatelessWidget {
  const OtpVerification({super.key});

  @override
  Widget build(BuildContext context) {
    final List<FocusNode> focusNodes = List.generate(6, (index) => FocusNode());

    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
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
                        "Verify Your Account",
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(color: Colors.white),
                      )
                    ],
                  ),
                ),
              ),
              Positioned(
                top: 16,
                left: 16,
                child: IconButton(
                  icon: Icon(Icons.arrow_back_ios, color: Colors.white),
                  onPressed: () {
                    Navigator.of(context)
                        .pop(); // Go back to the previous screen
                  },
                  tooltip: "Go Back",
                ),
              ),
            ],
          ),
          const SizedBox(height: 25),
          Container(
            padding: const EdgeInsets.all(15),
            child: Form(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Verify Your ",
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                  Text(
                    "Phone Number",
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                  const SizedBox(height: 35),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(6, (index) {
                      return _buildOtpBox(
                        context,
                        focusNodes[index],
                        index < 5 ? focusNodes[index + 1] : null,
                      );
                    }),
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 10),
                        Text(
                          "Didn't you receive any code?",
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        TextButton(
                          onPressed: () => {},
                          child: Text(
                            "RESEND NEW CODE",
                            style: TextStyle(color: AppColors.gold),
                          ),
                        ),
                        const SizedBox(
                          height: 45,
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOtpBox(
      BuildContext context, FocusNode currentNode, FocusNode? nextNode) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: Container(
        padding: const EdgeInsets.only(bottom: 13, left: 3),
        width: 45,
        height: 45,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey),
        ),
        child: TextFormField(
          autofocus: true,
          focusNode: currentNode,
          maxLength: 1,
          keyboardType: TextInputType.number,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 18),
          decoration: const InputDecoration(
            counterText: "",
            border: InputBorder.none,
          ),
          onChanged: (value) {
            if (value.length == 1) {
              currentNode.unfocus(); // Unfocus the current node
              if (nextNode != null) {
                FocusScope.of(context)
                    .requestFocus(nextNode); // Move to the next node
              }
            }
          },
        ),
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
