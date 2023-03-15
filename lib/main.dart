import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:payment/global.dart';
import 'package:payment/widgets/custom icon.dart';
import 'package:payment/widgets/custom inkwell.dart';
import 'package:sizer/sizer.dart';
import 'package:payment/Screen/Ledger%20list.dart';
import 'package:payment/Screen/allowance.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:month_year_picker/month_year_picker.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Sizer(
        builder: (context, orientation, deviceType) {
          return GetMaterialApp(
        title: 'payments',
            localizationsDelegates: [
              GlobalWidgetsLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              MonthYearPickerLocalizations.delegate,
            ],
        home: payments(),
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
      );
    });
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
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text('Total pending/advance for March 2023', style:  outerheader),
                          SizedBox(width: 2,),
                          Text('2000', style: amountstyle),
                        ],
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.15,
                        height: MediaQuery.of(context).size.height * 0.15,
                        padding: EdgeInsets.all(20.0),
                        decoration: innerbox,
                           child: Center(child: Text('Report', style: innerstyle))),

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
                           text : 'Allowance',
                            onpress: (){
                             Get.to(() => allowance());
                            },
                            ),
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
                       height: MediaQuery.of(context).size.height * 0.1,
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

                    Container(
                      width: MediaQuery.of(context).size.width * 0.90,
                      padding: EdgeInsets.all(30),
                      margin: EdgeInsets.fromLTRB(0, 20, 0, 20),
                      child: Center(child: Text('Ledger',style: ledger,)),
                      decoration: ledgerbor,),

                    Row(
                      children: [
                        Text('Entries'),
                        SizedBox(width: MediaQuery.of(context).size.width*0.4,),
                        Text('you gave'),
                        SizedBox(width: MediaQuery.of(context).size.width*0.1,),
                        Text('you got'),
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
              )
            ],
          ),
        ),
      ),
    );
  }
}


