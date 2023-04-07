import 'package:flutter/material.dart';
import 'package:payment/models/global.dart';

class  box extends StatelessWidget {
  final int index;
  final double height;
  final double width;
  box({required this.index, required this.height, required this.width});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10.0),
      child:
        Container(
          height: height,
          width: width,
          padding: EdgeInsets.only(left: height/100, right: width/100),
          child: Center(
              child: Text(priorityText[index],
                style: TextStyle(
                color: Colors.white,
                fontSize: height*0.3,
                )),
              ),
          decoration: BoxDecoration(
            color: priorityColor[index],
            borderRadius: BorderRadius.circular(8.0),
            border: Border.all(width: 3, color: Colors.black),
          ),
        ),
      );
  }
}

