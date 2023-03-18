import 'package:flutter/material.dart';

class salarytype extends StatelessWidget {
  String title;
  String desc;
  VoidCallback onpress;
  salarytype({required this.title, required this.desc, required this.onpress});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onpress,
      child: ListTile(
        shape: RoundedRectangleBorder( //<-- SEE HERE
          side: BorderSide(width: 2,color: Colors.blue),
          borderRadius: BorderRadius.circular(20),
        ),
        title: Text(title),
        subtitle: Text(desc),
        trailing: Icon(Icons.arrow_forward),
      ),
    );
  }
}
