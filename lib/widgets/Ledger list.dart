import 'package:flutter/material.dart';
import 'package:payment/global.dart';

class ledgertile extends StatelessWidget {
  const ledgertile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width * 0.07;
    double width1 = MediaQuery.of(context).size.width * 0.009;

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
                        child: Text('date',style: ledgertimestyle,)),

                    Padding(
                        padding: EdgeInsets.all(width1),
                        child: Center(child: Text('detail',style: ledgertextstyle,))),
                  ]
              ),
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height * 0.15,
            padding: EdgeInsets.fromLTRB(width, 0, width, 0),
            color: Colors.red,
            child: Center(child: Text('for',style: ledgertextstyle,)),
          ),

          Container(
            height: MediaQuery.of(context).size.height * 0.15,
            padding: EdgeInsets.fromLTRB(width, 0, width, 0),
            color: Colors.green,
            child: Center(child: Text('for',style: ledgertextstyle,)),
          ),

        ],
      ),
    );
  }
}
