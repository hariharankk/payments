import 'package:flutter/material.dart';
import 'package:payment/widgets/date picker.dart';
import 'package:get/get.dart';
import 'package:payment/widgets/rounded button.dart';
import 'package:payment/GetX/feautre_getx.dart';
import 'package:payment/models/Payments.dart';
import 'package:payment/services/firebase_service.dart';



class dailysalary extends StatelessWidget {
  final mycontroller = Get.put(feautreController());

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
                            roundedtextbutton(text: 'Daily Wage',width: MediaQuery.of(context).size  .width *0.90),
                            Row(
                              children: <Widget>[
                                SizedBox(width: 5,),
                                DatePickerWidget(),
                                roundedtextbutton1(text: 'Notes',width: MediaQuery.of(context).size  .width *0.65),
                              ],
                            ),
                          ],
                        ),
                      ),

                          GestureDetector(
                            onTap: (){
                              final apiProvider1 = apirepository();
                              Payments payments = Payments(
                                  ammount: int.parse(mycontroller.paymenttext.value),
                                  notes: mycontroller.notestext.value,
                                  category: 'Allowance',
                                  type_of_note: '',
                                  username: ''
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
                        ],
                ),
      );

  }
}



