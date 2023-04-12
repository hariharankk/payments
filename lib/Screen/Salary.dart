import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:payment/widgets/salary Type.dart';
import 'package:payment/global.dart';
import 'package:payment/Screen/Salary History.dart';
import 'package:payment/widgets/Daily.dart';
import 'package:payment/widgets/monthly.dart';
import 'package:payment/widgets/weekly.dart';
import 'package:payment/widgets/Work basis.dart';
import 'package:payment/widgets/Hourly basis.dart';
import 'package:payment/GetX/payment_getx.dart';

class Salary extends StatelessWidget {
  //Salary({});

  final mycontroller = Get.put(PaymentController());

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
          appBar: AppBar(title: Obx(()=>Text(mycontroller.empnameValue.value)),
            centerTitle: true,
            bottom: TabBar(
              isScrollable: true,
              tabs: tabs,
              indicatorColor: Colors.white,
            ),
            leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  Get.back();
                }
            ),),
          body: TabBarView(
              physics: BouncingScrollPhysics(),
              children: [
            SingleChildScrollView(
              child: Container(
                margin: EdgeInsets.fromLTRB(8, 4 , 8, 4),
                child: Column(

                children: [
                SizedBox(height: 10,),

                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    IconButton(onPressed: (){
                     Get.back();
                  }, icon: Icon(Icons.arrow_back,color: Colors.blue,)),
                  SizedBox(width: 10,),
                  Text('Select type of salary payment',style: salarybox,),
                ],
          ),
                  SizedBox(height: 15,),
                  salarytype(title: 'Monthly', desc: 'Fixed salary paid monthly', onpress: (){
                    Get.to(() => monthlysalary());
                  }),

                  SizedBox(height: 10,),
                  salarytype(title: 'Per Hour Basis', desc: 'per hour payment System', onpress: (){
                    Get.to(() => hourlybasissalary());
                  }),

                  SizedBox(height: 10,),
                  salarytype(title: 'Daily', desc: 'Daily payment for number of days', onpress: (){
                    Get.to(() => dailysalary());
                  }),

                  SizedBox(height: 10,),
                  salarytype(title: 'Work Basis', desc: 'payment based on work basis', onpress: (){
                    Get.to(() => workbasissalary());
                  }),

                  SizedBox(height: 10,),
                  salarytype(title: 'weekly', desc: 'payment weekly once', onpress: (){
                    Get.to(() => weeklysalary());
                  }),

         ],
        ),
              ),
            ),

          History()

       ]
      ),
     ),
    );
  }
}
