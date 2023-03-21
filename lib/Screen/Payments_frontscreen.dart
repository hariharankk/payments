
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:payment/global.dart';
import 'package:payment/widgets/custom icon.dart';
import 'package:payment/widgets/custom inkwell.dart';
import 'package:payment/Screen/allowance.dart';
import 'package:month_year_picker/month_year_picker.dart';
import 'package:payment/Screen/Bonus_wage.dart';
import 'package:payment/Screen/Deductions.dart';
import 'package:payment/Screen/loans.dart';
import 'package:payment/Screen/Ledger.dart';
import 'package:payment/Screen/paymentscreen.dart';
import 'package:payment/Screen/Salary.dart';
import 'package:payment/Screen/overtime.dart';



class payments extends StatefulWidget {
  const payments({Key? key}) : super(key: key);

  @override
  State<payments> createState() => _paymentsState();
}

class _paymentsState extends State<payments> {


  Future pickDate(BuildContext context) async {
    final _selected = await showMonthYearPicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2019),
      lastDate: DateTime(2024),

    );

    if (_selected != null){
      print('hari');
    }
  }

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
            onPressed: (){

              pickDate(context);
            },
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
                            onpress: (){
                              Get.to(() => Salary());
                            },
                            text : 'Salary'),

                        custominkwell(
                            icon :customicon(icon: Icons.hourglass_bottom),
                            onpress: (){
                              Get.to(() => overtimescreen());
                            },
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
                            onpress: (){
                              Get.to(() => deduction());
                            },
                            text : 'Deductions'
                        ),
                        custominkwell(
                            icon :customicon(icon: Icons.monetization_on_sharp),
                            onpress: (){
                              Get.to(() => loan());
                            },
                            text : 'Loans'),
                        custominkwell(
                            icon :customicon(icon: Icons.card_giftcard),
                            onpress: (){
                              Get.to(() => bonus());
                            },
                            text : 'Bonus Wage'),
                      ],
                    ),
                    SizedBox(height: 20,),
                    GestureDetector(
                      onTap: (){
                        print('hari');
                        Get.to(() => paymentscreen());
                      },
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
              Ledger()

            ],
          ),
        ),
      ),
    );
  }
}
