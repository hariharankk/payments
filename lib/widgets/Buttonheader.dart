import 'package:flutter/material.dart';
import 'package:payment/GetX/allowance_getx.dart';
import 'package:get/get.dart';

class ButtonHeaderWidget extends StatelessWidget {
  final String title;
  final VoidCallback onClicked;

  const ButtonHeaderWidget({

    required this.title,
    required this.onClicked,
  });

  @override
  Widget build(BuildContext context) => HeaderWidget(
    title: title,
    child: ButtonWidget(
      onClicked: onClicked,
    ),
  );
}

class ButtonWidget extends StatelessWidget {
  final VoidCallback onClicked;
  //final Icon icon;

   ButtonWidget({
    //required this.icon,
    required this.onClicked,
  });
  final mycontroller = Get.find<allowanceController>();
  @override
  Widget build(BuildContext context) => ElevatedButton(
    style: ElevatedButton.styleFrom(
      shape: RoundedRectangleBorder(
        side: BorderSide(color:Colors.blue,width:1.4),
        borderRadius: BorderRadius.circular(10),
      ),
      fixedSize: Size(180,60),
      primary: Color.fromARGB(255, 255, 255, 255),
    ),
    child: Obx(

      ()=> FittedBox(
        child: Text(
            mycontroller.date.value,
            style: TextStyle(fontSize: 10, color: Color.fromARGB(255, 5, 116, 176)),
          ),

      ),
    ),
    onPressed: onClicked,
  );
}

class HeaderWidget extends StatelessWidget {
  final String title;
  final Widget child;
  // final Icon icon;

  const HeaderWidget({
    required this.title,
    required this.child,
    // @required this.icon,
  });

  @override
  Widget build(BuildContext context) => Container(
    margin: EdgeInsets.only(left: 10),
    width: MediaQuery.of(context).size .width *0.15,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Icon(Icons.icon),
        Padding(
          padding: EdgeInsets.only(left: 5),
          child: Text(
            title,style: TextStyle(fontSize: 10)
          ),
        ),
        SizedBox(height: 5,),
        child,
      ],
    ),
  );
}