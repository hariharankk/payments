import 'package:flutter/material.dart';

class listtile extends StatelessWidget {
  listtile({required this.subtitle, required this.text , required this.icon });

  String text , subtitle;
  Icon icon;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: icon,
      title: Text(
        text,
        textScaleFactor: 1.5,
      ),
      subtitle: Text(subtitle),
    );
  }
}
