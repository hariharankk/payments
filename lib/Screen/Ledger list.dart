import 'package:flutter/material.dart';
import 'package:payment/global.dart';
import 'package:payment/models/Payments.dart';

class ledgertile extends StatelessWidget {
  Payments payments;
  ledgertile({required this.payments});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width * 0.2;
    double width1 = MediaQuery.of(context).size.width * 0.0075;

    return  Container(
      height: MediaQuery.of(context).size.height * 0.15,
      decoration: ledgerbor,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Container(
              height: MediaQuery.of(context).size.height * 0.15,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Padding(
                        padding: EdgeInsets.all(width1),
                        child: Text(payments.time!,style: ledgertimestyle,)),

                    Padding(
                        padding: EdgeInsets.all(width1),
                        child: Center(child: Text(payments.category!+':- '+payments.notes!,style: ledgertextstyle,))),
                  ]
              ),
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height * 0.15,
            width: width,
            color: Colors.red,
            child: Center(child: payments.type_of_note=='Debit'?Text(payments.ammount.toString()!,style: ledgertextstyle,):Text('')),
          ),

          Container(
            height: MediaQuery.of(context).size.height * 0.15,
            width: width,
            //padding: EdgeInsets.fromLTRB(width, 0, width, 0),
            color: Colors.green,
            child: Center(child: payments.type_of_note=='Credit'?Text(payments.ammount.toString()!,style: ledgertextstyle,):Text('')),
          ),

        ],
      ),
    );
  }
}
