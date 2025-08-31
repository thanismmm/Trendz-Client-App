import 'package:flutter/material.dart';
import 'package:trendz_customer/theming/app_colors.dart';

class FormInput extends StatelessWidget {
  final String inputName;
  final String placeHolder;
  final Widget icon;
  const FormInput(
      {super.key,
      required this.inputName,
      required this.placeHolder,
      required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Theme.of(context).cardColor,
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20, top: 15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                inputName,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(
                height: 4,
              ),
              TextFormField(
                  style: Theme.of(context).textTheme.bodySmall,
                  decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(vertical: 16),
                      hintText: placeHolder,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      prefixIcon: icon)),
            ],
          ),
        ));
  }
}
