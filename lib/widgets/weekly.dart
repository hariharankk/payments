import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:payment/widgets/rounded button.dart';
import 'package:payment/GetX/feautre_getx.dart';
import 'package:intl/intl.dart';
import 'package:payment/widgets/Buttonheader.dart';
import 'package:payment/GetX/weekly_getx.dart';
import 'package:payment/models/Payments.dart';
import 'package:payment/services/firebase_service.dart';
import 'package:payment/GetX/payment_getx.dart';
import 'package:payment/services/dummybloc.dart';
import 'package:payment/Screen/attendance weekly.dart';
import 'package:payment/services/validate.dart';

class weeklysalary extends StatelessWidget {
  final mycontroller = Get.put(feautreController());
  final mycontroller1 = Get.find<PaymentController>();
  final mycontroller2 = Get.put(WeekController());

  //allowance({}) ;
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(title: Obx(()=>Text(mycontroller1.empnameValue.value)),
        centerTitle: true,
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Get.back();
            }
        ),),
      body:
      SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  SizedBox(height: 20,),
                  roundedtextbutton(text: 'Weekly Salary',width: MediaQuery.of(context).size  .width *0.90),
                  SizedBox(height: 5,),
                  roundedtextbutton1(text: 'Notes',width: MediaQuery.of(context).size  .width *0.9),
                  SizedBox(height: 5,),
                  DateRangePickerWidget()

                ],
              ),
            ),
            SizedBox(height: 10,),
            GestureDetector(
              onTap: ()async{
                Get.to(()=> AttendanceHistoryweek(userId: mycontroller1.empidValue.value,startdate: mycontroller2.datestart.value,enddate: mycontroller2.datesend.value,));
              },
              child: Container(
                width: MediaQuery.of(context).size  .width *0.95,
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0),
                  color: Colors.blue,
                ),
                margin: EdgeInsets.only(bottom: 20),
                child: Center(child: Text('Check Attendance')),
              ),
            ),

            SizedBox(height: 10,),

            GestureDetector(
              onTap: ()async{
                final apiProvider1 = apirepository();
                Payments payments = Payments(
                    ammount: int.parse(mycontroller.paymenttext.value),
                    notes: 'Weekly Basis Salary :- '+mycontroller.notestext.value,
                    category: 'Salary',
                    time: mycontroller.date.value,
                    type_of_note: 'Debit',
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
                child: Center(child: Text('Add Weekly Salary')),
              ),
            ),
          ],
        ),
      ),
    );

  }
}



class DateRangePickerWidget extends StatelessWidget {
  final mycontroller = Get.find<WeekController>();

  @override
  Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
    child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
        weeklystartbutton(
              onClicked: () => pickDateRange(context),
            ),
          Icon(Icons.arrow_forward, color: Colors.blue),
          weeklyendbutton(
              onClicked: () => pickDateRange(context),
            ),

        ],
    ),
  );

  Future pickDateRange(BuildContext context) async {
    final initialDateRange = DateTimeRange(
      start: DateTime.now(),
      end: DateTime.now().add(Duration(hours: 24 * 3)),
    );
    final newDateRange = await showDateRangePicker(
      context: context,
      firstDate: DateTime(DateTime.now().year - 5),
      lastDate: DateTime(DateTime.now().year + 5),
      initialDateRange: initialDateRange,
    );

    if (newDateRange != null) {
      mycontroller.datesendchange(DateFormat('MM/dd/yyyy').format(newDateRange.end));
      mycontroller.datestartchange(DateFormat('MM/dd/yyyy').format(newDateRange.start));

    };

  }
}