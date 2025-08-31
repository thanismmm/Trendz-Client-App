import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomNavigation extends StatelessWidget {
  final Widget navigationIcon; // Keep it as a Widget to allow flexibility
  final String navigationtitle;
  final String? navigationsubtitle;
  final VoidCallback navigate;

  const CustomNavigation(
      {super.key,
      required this.navigationtitle,
      this.navigationsubtitle,
      required this.navigationIcon,
      required this.navigate});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => navigate(), // Add parentheses to execute the function
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      navigationIcon,
                      const SizedBox(
                        width: 10,
                      ),
                      navigationsubtitle != null &&
                              navigationsubtitle!.isNotEmpty
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  navigationtitle,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(fontSize: 15),
                                ),
                                Text(
                                  navigationsubtitle!,
                                  style: Theme.of(context).textTheme.labelSmall,
                                ),
                              ],
                            )
                          : Text(
                              navigationtitle,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
