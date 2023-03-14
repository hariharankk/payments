import 'package:flutter/material.dart';
import 'package:payment/global.dart';
import 'package:sizer/sizer.dart';

class custominkwell extends StatelessWidget {
  Widget? icon;
  String? text;
  VoidCallback? onpress;
  custominkwell({
    this.icon,
    this.text,
    this.onpress
});

  @override
  Widget build(BuildContext context) {
    return                       InkWell(
      onTap: onpress,
      child: Column(
        children: <Widget>[
          icon!,
          SizedBox(height: 10,),
          Text(text!,style: iconunder,)
        ],
      ),
    );
  }
}
