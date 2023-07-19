import 'package:flutter/material.dart';
import 'package:payment/widgets/date picker.dart';
import 'package:get/get.dart';
import 'package:payment/widgets/rounded button.dart';
import 'package:payment/GetX/feautre_getx.dart';
import 'package:payment/models/Payments.dart';
import 'package:payment/services/firebase_service.dart';
import 'package:payment/GetX/payment_getx.dart';
import 'package:payment/services/dummybloc.dart';
import 'package:intl/intl.dart';
import 'package:payment/Screen/Attendance.dart';


class dailysalary extends StatelessWidget {
  final mycontroller = Get.put(feautreController());
  final mycontroller1 = Get.find<PaymentController>();

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
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          child: Column(
                            children: <Widget>[
                              SizedBox(height:20),
                              Text('Please select the date first'),
                              SizedBox(height:15),
                              DatePickerWidget(),
                              SizedBox(height: 20,),
                              roundedtextbutton(text: 'Daily Wage',width: MediaQuery.of(context).size  .width *0.90),
                              roundedtextbutton1(text: 'Notes',width: MediaQuery.of(context).size  .width *0.65),
                            ],
                          ),
                        ),
                        SizedBox(height: 10,),
                          GestureDetector(
                          onTap: ()async{
                            Get.to(()=> AttendanceHistoryday(userId: mycontroller1.empidValue.value,));
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

                        Obx(
                          ()=> mycontroller.date.value == 'Select Date'? Container() :
                          GestureDetector(
                                onTap: ()async{
                                  final apiProvider1 = apirepository();
                                  Payments payments = Payments(
                                      ammount: int.parse(mycontroller.paymenttext.value),
                                      notes: 'Daily Basis Salary :- '+mycontroller.notestext.value,
                                      category: 'Salary',
                                      type_of_note: 'Debit',
                                      time: mycontroller.date.value,
                                      username: mycontroller1.empidValue.value
                                  );
                                  Map<dynamic, dynamic> paymentsMap = payments.toMap();
                                  apiProvider1.Payments_adddata(paymentsMap);
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
                                  child: Center(child: Text('Add Daily wage')),
                                ),
                              ),
                        ),
                          ],
                  ),
                ),
      );

  }
}



