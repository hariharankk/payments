import 'package:flutter/material.dart';
import 'package:payment/global.dart';


class custominkwell extends StatelessWidget {
  Widget? icon;
  String? text;
  custominkwell({
    this.icon,
    this.text
});

  @override
  Widget build(BuildContext context) {
    return                       InkWell(
      onTap: (){},
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
