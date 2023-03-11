import 'package:flutter/material.dart';


class customicon extends StatelessWidget {
  final IconData? icon;
  customicon({this.icon});

  @override
  Widget build(BuildContext context) {
    return Icon(
      icon,
      color: Colors.blue,
      size: 30,
    );
  }
}
