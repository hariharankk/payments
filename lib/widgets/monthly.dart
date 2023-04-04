import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:payment/widgets/rounded button.dart';
import 'package:payment/GetX/feautre_getx.dart';
import 'package:payment/GetX/history_getx.dart';
import 'package:intl/intl.dart';
import 'package:payment/global.dart';
import 'package:month_year_picker/month_year_picker.dart';
import 'package:payment/models/Payments.dart';
import 'package:payment/services/firebase_service.dart';
import 'package:payment/GetX/payment_getx.dart';
import 'package:payment/services/dummybloc.dart';


class monthlysalary extends StatelessWidget {
  final mycontroller = Get.put(feautreController());
  final mycontroller1 = Get.find<PaymentController>();

  //allowance({}) ;
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(title: Text('employee name'),
        centerTitle: true,
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Get.back();
            }
        ),),
      body:
      Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              child: Column(
                children: <Widget>[
                  SizedBox(height: 20,),
                  roundedtextbutton(text: 'Monthly Salary',width: MediaQuery.of(context).size  .width *0.90),
                  Row(
                    children: <Widget>[
                      SizedBox(width: 5,),
                      calendar(),
                      roundedtextbutton1(text: 'Notes',width: MediaQuery.of(context).size  .width *0.65),
                    ],
                  ),

                ],
              ),
            ),

                GestureDetector(
                  onTap: ()async{
                    final apiProvider1 = apirepository();
                    Payments payments = Payments(
                        ammount: int.parse(mycontroller.paymenttext.value),
                        notes: 'Monthly Basis Salary :- '+mycontroller.notestext.value,
                        category: 'Salary',
                        type_of_note: 'Debit',
                        time: mycontroller.date.value,
                        username: mycontroller1.empidValue.value
                    );
                    Map<dynamic, dynamic> paymentsMap = payments.toMap();
                    apiProvider1.Payments_adddata(paymentsMap);
                    await Future<void>.delayed(const Duration(milliseconds: 100));
                    ledgerbloc.Ledger_getdata(DateFormat("MMMM, yyyy").format(DateTime.now()), payments.username!);
                    Get.back();
                  },
                  child: Container(
                    width: MediaQuery.of(context).size  .width *0.95,
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.0),
                      color: Colors.blue,
                    ),
                    margin: EdgeInsets.only(bottom: 20),
                    child: Center(child: Text('Add monthly Salary')),
                  ),
                ),
              ],
            ),
     );

  }
}

class calendar extends StatelessWidget {
  final mycontroller = Get.put(HistoryController());

  Future pickDate(BuildContext context) async {
    final _selected = await showMonthYearPicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2019),
      lastDate: DateTime(2024),

    );

    if (_selected != null){
      mycontroller.change(DateFormat("MMMM, yyyy").format(_selected));
    }
  }
  @override
  Widget build(BuildContext context) {
    return  Container(
      width: MediaQuery.of(context).size .width *0.15,
      child: Column(
          children: <Widget>[
            Text('select month',style: salarycal,),

            GestureDetector(
              onTap: (){
                pickDate(context);


              },
              child: Container(
                margin: EdgeInsets.all(10),
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.blue
                ),
                child: Center(
                  child:
                    Obx(()=> Text( mycontroller.date.value,style: salarycal,)),
                ),
              ),
            )

          ],
        ),
    );
  }
}




