import 'package:flutter/material.dart';

class ButtonHeaderWidget extends StatelessWidget {
  final String title;
  final String text;
  final VoidCallback onClicked;

  const ButtonHeaderWidget({

    required this.title,
    required this.text,
    required this.onClicked,
  });

  @override
  Widget build(BuildContext context) => HeaderWidget(
    title: title,
    child: ButtonWidget(
      text: text,
      onClicked: onClicked,
    ),
  );
}

class ButtonWidget extends StatelessWidget {
  final String text;
  final VoidCallback onClicked;
  //final Icon icon;

  const ButtonWidget({
    required this.text,
    //required this.icon,
    required this.onClicked,
  });

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
    child: FittedBox(
      child: Text(
        text,
        style: TextStyle(fontSize: 20, color: Color.fromARGB(255, 5, 116, 176)),
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
            title,
          ),
        ),
        SizedBox(height: 5,),
        child,
      ],
    ),
  );
}