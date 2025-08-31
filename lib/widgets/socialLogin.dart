import 'package:flutter/material.dart';
import 'package:trendz_customer/theming/app_colors.dart';

class Sociallogin extends StatelessWidget {
  final String name;
  final String socialImagePath;
  final Function handleSocialLogin;
  const Sociallogin(
      {super.key,
      required this.name,
      required this.socialImagePath,
      required this.handleSocialLogin});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => handleSocialLogin,
      // showModalBottomSheet(
      //     context: context,
      //     // ignore: non_constant_identifier_names
      //     builder: (BuildContext) {
      //       return Container();
      //     })

      child: Container(
        padding: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
            border: Border.all(color: AppColors.gold),
            borderRadius: BorderRadius.circular(10)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            Image.asset(
              socialImagePath,
              width: 20,
            ),
            const SizedBox(
              width: 10,
            ),
            Text(
              name,
              style: Theme.of(context).textTheme.bodySmall,
            )
          ],
        ),
      ),
    );
  }
}
