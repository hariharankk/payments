import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:payment/widgets/date picker.dart';
import 'package:get/get.dart';
import 'package:payment/widgets/rounded button.dart';
import 'package:payment/global.dart';
import 'package:payment/GetX/feautre_getx.dart';
import 'package:payment/Screen/payments_history.dart';
import 'package:payment/models/Payments.dart';
import 'package:payment/services/firebase_service.dart';
import 'package:payment/GetX/payment_getx.dart';
import 'package:payment/services/dummybloc.dart';
import 'package:intl/intl.dart';



class paymentscreen extends StatelessWidget {
  final mycontroller = Get.put(feautreController());
  final mycontroller1 = Get.find<PaymentController>();

  //allowance({}) ;
  @override
  Widget build(BuildContext context) {
    return  DefaultTabController(
      length: 2,
      child: Scaffold(
          appBar: AppBar(title: Obx(()=>Text(mycontroller1.empnameValue.value)),
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
              dragStartBehavior: DragStartBehavior.start,
              children: [
                Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        child: Column(
                          children: <Widget>[
                            SizedBox(height: 20,),
                            roundedtextbutton(text: 'Payment amount',width: MediaQuery.of(context).size  .width *0.90),
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
                            onTap: ()async{
                              final apiProvider1 = apirepository();
                              Payments payments = Payments(
                                  ammount: int.parse(mycontroller.paymenttext.value),
                                  notes: mycontroller.notestext.value,
                                  category: 'Payment',
                                  time: mycontroller.date.value,
                                  type_of_note: 'Credit',
                                  username: mycontroller1.empidValue.value
                              );
                              Map<dynamic, dynamic> paymentsMap = payments.toMap();
                              apiProvider1.Payments_adddata(paymentsMap);
                              await Future<void>.delayed(const Duration(milliseconds: 200));
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
                              child: Center(child: Text('Add Payments')),
                            ),
                          ),
                        ],
                      ),

                History()
              ]
          )
      ),
    );
  }
}



