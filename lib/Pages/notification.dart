import 'package:flutter/material.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  List<Map<String, dynamic>> Notifications = [];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Theme.of(context).focusColor,
          borderRadius: BorderRadius.circular(12)),
      height: MediaQuery.of(context).size.height,
      child: Notifications.isEmpty
          ? Center(
              child: Text(
                "Nothing to show here!",
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            )
          : ListView.builder(
              itemCount: Notifications.length,
              itemBuilder: (context, index) {
                return Text(
                  "Hello",
                  style: Theme.of(context).textTheme.bodyMedium,
                );
              }),
    );
  }
}
