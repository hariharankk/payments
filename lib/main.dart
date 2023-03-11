import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:payment/global.dart';
import 'package:payment/widgets/custom icon.dart';
import 'package:payment/widgets/custom inkwell.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'payments',
      home: payments(),
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
    );
  }
}

class payments extends StatefulWidget {
  const payments({Key? key}) : super(key: key);

  @override
  State<payments> createState() => _paymentsState();
}

class _paymentsState extends State<payments> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Employee name'),
          leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Get.back();
               }
              ),
          actions: [
          IconButton(
              onPressed: (){},
              icon: Icon(Icons.calendar_month),
          ),
          SizedBox(width: 20.0,)
         ],
          ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
          padding: EdgeInsets.only(top: 30),
          child: Column(
            children: <Widget>[
              GestureDetector(
                onTap: (){},
                child: Center(
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.90,
                    height: MediaQuery.of(context).size.height * 0.2,
                    decoration: upperbox,
                    child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children:<Widget>[
                      Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text('Total pending/advance for March 2023', style: outerheader),
                          Text('2000', style: amountstyle),
                        ],
                      ),
                      Container(
                        padding: EdgeInsets.all(20.0),
                        decoration: innerbox,
                        child: Text('Report ->', style: innerstyle
                        )
                      ),

                    ]
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20.0,),
              Container(
                width: MediaQuery.of(context).size.width * 0.90,
                height: MediaQuery.of(context).size.height * 0.5,
                padding: EdgeInsets.all(20),
                decoration: mainbox,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                   Row(
                     mainAxisAlignment: MainAxisAlignment.spaceAround,
                     crossAxisAlignment: CrossAxisAlignment.center,
                     mainAxisSize: MainAxisSize.max,
                     children: <Widget>[

                       custominkwell(
                            icon :customicon(icon: Icons.handyman_sharp),
                            text : 'Salary'),

                       custominkwell(
                           icon :customicon(icon: Icons.hourglass_bottom),
                           text : 'Overtime Pay'),

                       custominkwell(
                           icon :customicon(icon: Icons.electric_scooter_outlined),
                           text : 'Allowance'),
                     ],
                   ),
                   SizedBox(height: 20,),
                   Row(
                     mainAxisAlignment: MainAxisAlignment.spaceAround,
                     crossAxisAlignment: CrossAxisAlignment.center,
                     mainAxisSize: MainAxisSize.max,
                     children: <Widget>[
                       custominkwell(
                           icon :customicon(icon: Icons.healing_sharp),
                           text : 'Deductions'),
                       custominkwell(
                           icon :customicon(icon: Icons.monetization_on_sharp),
                           text : 'Loans'),
                       custominkwell(
                           icon :customicon(icon: Icons.card_giftcard),
                           text : 'Bonus Wage'),
                     ],
                   ),
                   SizedBox(height: 20,),
                   GestureDetector(
                     onTap: (){},
                     child: Container(
                       width: MediaQuery.of(context).size.width * 0.90,
                       padding: EdgeInsets.all(20),
                       decoration: paymentbor,
                       child: Center(
                           child: Text('+ Make Payments',style: payment,)
                         ),
                     ),
                   ),

                  ],
                ),
              ),
              SizedBox(height: 20,),
              Container(
                width: MediaQuery.of(context).size.width * 0.90,
                padding: EdgeInsets.all(20),
                decoration: mainbox,

                child: Column(
                  children: <Widget>[
                    Divider(color: Colors.black,),
                    SizedBox(height: 10,),
                    Text('Ledger',style: ledger,),
                    SizedBox(height: 10,),
                    Divider(color: Colors.black,),
                    ListView.separated(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (BuildContext context, int index) {
                          return Container(
                            height: MediaQuery.of(context).size.height * 0.05,decoration: mainbox,child: Text('hari'),);
                        },
                        separatorBuilder: (BuildContext context, int index) => const SizedBox(height: 20,child: ColoredBox(color: Colors.grey),),
                        itemCount: 5
                    )


                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
