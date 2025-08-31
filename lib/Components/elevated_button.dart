import 'package:flutter/material.dart';
import 'package:trendz_customer/theming/app_colors.dart';

class CustomElevatedButton extends StatelessWidget {
  final String text;
  final IconData icon;
  final VoidCallback? onPressed;
  final Color backgroundColor;
  final Color textColor;
  final Color borderColor; // New property for border color
  final double elevation;
  final double paddingVertical;
  final double paddingHorizontal;
  final BorderRadiusGeometry borderRadius;
  final TextStyle? textstyle; // Make this nullable to allow default value

  // Constructor to accept properties
  const CustomElevatedButton({
    super.key,
    required this.text,
    required this.icon,
    required this.onPressed,
    this.backgroundColor = AppColors.gold, // Default button color
    this.textColor = AppColors.black, // Default text color
    this.borderColor = Colors.transparent, // Default border color
    this.elevation = 5.0, // Default elevation
    this.paddingVertical = 12.0, // Default vertical padding
    this.paddingHorizontal = 24.0, // Default horizontal padding
    this.borderRadius =
        const BorderRadius.all(Radius.circular(50)), // Default border radius
    this.textstyle, // Optional custom text style
  });

  @override
  Widget build(BuildContext context) {
    // Use the provided textstyle or fall back to the default bodyMedium style
    final TextStyle effectiveTextStyle = textstyle ??
        Theme.of(context).textTheme.bodyMedium!.copyWith(
              fontWeight: FontWeight.bold,
            );

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(
          horizontal: paddingHorizontal,
          vertical: paddingVertical,
        ),
        elevation: elevation,
        backgroundColor: backgroundColor,
        foregroundColor: textColor,
        shape: RoundedRectangleBorder(
          borderRadius: borderRadius,
          side: BorderSide(
            color: borderColor, // Use the borderColor property
            width: 1.5, // Customize the border width
          ),
        ),
        textStyle: effectiveTextStyle,
      ),
      onPressed: onPressed,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          Icon(icon),
          const SizedBox(width: 8),
          Text(text),
        ],
      ),
    );
  }
}
