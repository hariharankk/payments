import 'package:flutter/material.dart';

class roundedtextbutton extends StatelessWidget {
  String text;
  double width;
  roundedtextbutton({required this.text,required this.width});
  TextEditingController cont = new TextEditingController();
  String? Payment;
  late double unitHeightValue, unitWidthValue;


  @override
  Widget build(BuildContext context) {
    unitHeightValue = MediaQuery.of(context).size.height * 0.001;
    unitWidthValue = MediaQuery.of(context).size  .width * 0.001;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Stack(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.only(top: 10),
            child: TextFormField(
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black54,
                  fontSize: 20 * unitHeightValue),
              controller: cont,
              textAlign: TextAlign.center,
              keyboardType: TextInputType.name,
              onChanged: (payment) => Payment,
              decoration: InputDecoration(
                constraints: BoxConstraints.tightFor(
                  width: width,
                ),
                isDense: true,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  text,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
