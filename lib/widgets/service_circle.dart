import 'package:flutter/material.dart';

class ServiceCircle extends StatelessWidget {
  final String servicename;
  const ServiceCircle({super.key, required this.servicename});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.pink,
              width: 2,
            ),
            shape: BoxShape.circle,
          ),
          child: Container(
              margin: EdgeInsets.all(1),
              decoration:
                  BoxDecoration(shape: BoxShape.circle, color: Colors.green),
              child: Image.asset(
                "assets/images/profile.png",
                fit: BoxFit.cover,
              )),
        ),
        SizedBox(height: 5),
        Text(
          servicename,
          style: TextStyle(fontSize: 10),
        ),
      ],
    );
  }
}
