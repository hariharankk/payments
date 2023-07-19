import 'package:flutter/material.dart';
import 'package:payment/GetX/feautre_getx.dart';
import 'package:get/get.dart';
import 'package:payment/services/validate.dart';

class roundedtextbutton extends StatelessWidget {
  String text;
  double width;
  roundedtextbutton({required this.text,required this.width});
  final mycontroller = Get.find<feautreController>();
  String? Payment;
  late double unitHeightValue, unitWidthValue;
  Validate validate = new Validate();


  @override
  Widget build(BuildContext context) {
    unitHeightValue = MediaQuery.of(context).size.height * 0.001;
    unitWidthValue = MediaQuery.of(context).size  .width * 0.001;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child:
          Container(
            padding: const EdgeInsets.only(top: 10),
            child: TextFormField(
              autovalidateMode: AutovalidateMode.onUserInteraction,
               validator: validate.validateInteger,
               style: TextStyle(
                  fontWeight: FontWeight.bold,

                  color: Colors.black54,
                  fontSize: 20 * unitHeightValue),
              controller: mycontroller.paymnetController,

              textAlign: TextAlign.center,
              keyboardType: TextInputType.name,
              onChanged: (payment) {
                 print(payment);
                mycontroller.paymenttext = payment.obs ;
                },
              decoration: InputDecoration(
                constraints: BoxConstraints.tightFor(
                  width: width,
                ),
                labelText: text,
                isDense: true,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10)),

                errorBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.redAccent,
                    width: 2.0,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.blue,
                    width: 2.0,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.black54,
                    width: 2.0,
                  ),
                ),

            ),
          ),
      ),
    );
  }
}


class roundedtextbutton1 extends StatelessWidget {
  String text;
  double width;
  roundedtextbutton1({required this.text,required this.width});
  final mycontroller = Get.find<feautreController>();
  String? Payment;
  late double unitHeightValue, unitWidthValue;


  @override
  Widget build(BuildContext context) {
    unitHeightValue = MediaQuery.of(context).size.height * 0.001;
    unitWidthValue = MediaQuery.of(context).size  .width * 0.001;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child:
      Container(
        padding: const EdgeInsets.only(top: 10),
        child: TextField(
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black54,
              fontSize: 20 * unitHeightValue),
          controller: mycontroller.noteController,

          textAlign: TextAlign.center,
          keyboardType: TextInputType.name,
          onChanged: (payment) {
            mycontroller.notestext = payment.obs;
          },
          decoration: InputDecoration(
            constraints: BoxConstraints.tightFor(
              width: width,
            ),
            labelText: text,
            isDense: true,
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10)),

            errorBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.redAccent,
                width: 2.0,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.blue,
                width: 2.0,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.black54,
                width: 2.0,
              ),
            ),

          ),
        ),
      ),
    );
  }
}


class rateroundedtextbutton extends StatelessWidget {
  String text;
  double width;
  rateroundedtextbutton({required this.text,required this.width});
  TextEditingController cont = new TextEditingController();
  final mycontroller = Get.find<feautreController>();
  String? Payment;
  late double unitHeightValue, unitWidthValue;
  Validate validate = new Validate();

  @override
  Widget build(BuildContext context) {
    unitHeightValue = MediaQuery.of(context).size.height * 0.001;
    unitWidthValue = MediaQuery.of(context).size  .width * 0.001;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      child:
      Container(
        padding: const EdgeInsets.only(top: 10),
        child: TextFormField(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: validate.validateInteger,
          style: TextStyle(
              fontWeight: FontWeight.bold,

              color: Colors.black54,
              fontSize: 20 * unitHeightValue),
          controller: text=='Rate' ? mycontroller.rateController : mycontroller.quantityController,

          textAlign: TextAlign.center,
          keyboardType: TextInputType.name,
          onChanged: (payment) {
            text=='Rate'? mycontroller.ratechange(double.parse(payment)) :mycontroller.quantitychange(double.parse(payment));

            },
          decoration: InputDecoration(
            constraints: BoxConstraints.tightFor(
              width: width,
            ),
            labelText: text,
            isDense: true,
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10)),

            errorBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.redAccent,
                width: 2.0,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.blue,
                width: 2.0,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.black54,
                width: 2.0,
              ),
            ),

          ),
        ),
      ),
    );
  }
}

