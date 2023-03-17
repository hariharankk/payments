import 'package:flutter/material.dart';
import 'package:payment/global.dart';
import 'package:payment/Screen/Ledger%20list.dart';

class Ledger extends StatelessWidget {
  Ledger({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return              Container(
      width: MediaQuery.of(context).size.width * 0.90,
      padding: EdgeInsets.all(20),
      decoration: mainbox,

      child: Column(
        children: <Widget>[

          Container(
            width: MediaQuery.of(context).size.width * 0.90,
            height: MediaQuery.of(context).size.height * 0.2,
            margin: EdgeInsets.fromLTRB(0, 20, 0, 20),
            child:
            Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                    child: Center(child: Text('Ledger',style: ledger,))),
                Container(
                  height: MediaQuery.of(context).size.height * 0.2,
                  width: MediaQuery.of(context).size.width * 0.2,
                  color: Colors.green,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text('you will get'),
                      Text('2000',style: ledgerheaderstyle,)
                    ],
                  ),
                ),

                Container(
                  height: MediaQuery.of(context).size.height * 0.2,
                  width: MediaQuery.of(context).size.width * 0.2,
                  color: Colors.red,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text('you will give'),
                      Text('2000',style: ledgerheaderstyle,)
                    ],
                  ),
                ),

              ],
            ),
            decoration: ledgerbor,),

          Row(

            children: [
              Expanded(child: Center(child: Text('Entries'))),

              Container(
                width: MediaQuery.of(context).size.width * 0.2,
                child: Center(child: Text('you gave')),
              ),

              Container(
                  width: MediaQuery.of(context).size.width * 0.2,
                  child: Center(child: Text('you got'))
              ),
            ],
          ),
          SizedBox(height: 5,),
          ListView.separated(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (BuildContext context, int index) {
                return ledgertile();
              },
              separatorBuilder: (BuildContext context, int index) => const SizedBox(height: 10,child: ColoredBox(color: Colors.transparent),),
              itemCount: 5
          )


        ],
      ),
    );
  }
}
