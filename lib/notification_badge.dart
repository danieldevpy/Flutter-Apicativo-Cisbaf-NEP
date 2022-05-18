import 'package:flutter/material.dart';

class NotificationBadge extends StatelessWidget {
  // also take a total notification value
  final int totalNotification;
  const NotificationBadge({ Key? key, required this.totalNotification }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 30,
      height: 30,
      decoration: BoxDecoration(
        color: Colors.orange,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Padding(padding: EdgeInsets.all(8),
        child: Text("$totalNotification", style: TextStyle(color: Colors.white, fontSize: 14),),
        )));
  }
}