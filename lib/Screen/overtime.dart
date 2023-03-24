import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:payment/widgets/date picker.dart';
import 'package:get/get.dart';
import 'package:payment/widgets/rounded button.dart';
import 'package:payment/global.dart';
import 'package:payment/GetX/feautre_getx.dart';
import 'package:payment/Screen/payments_history.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:payment/GetX/spinner widget getx.dart';
import 'package:payment/models/Payments.dart';
import 'package:payment/services/firebase_service.dart';



class overtimescreen extends StatelessWidget {
  final mycontroller = Get.put(feautreController());
  final mycontroller1 = Get.put(spinnerController());



  //allowance({}) ;
  @override
  Widget build(BuildContext context) {
    return  DefaultTabController(
      length: 2,
      child: Scaffold(
          appBar: AppBar(title: Text('employee name'),
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
                SingleChildScrollView(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          child: Column(
                            children: <Widget>[
                              SizedBox(height: 20,),
                              roundedtextbutton(text: 'Overtime description',width: MediaQuery.of(context).size  .width *0.90),
                              Row(
                                children: <Widget>[
                                  SizedBox(width: 5,),
                                  DatePickerWidget(),
                                  roundedtextbutton1(text: 'Notes',width: MediaQuery.of(context).size  .width *0.65),
                                ],
                              ),
                              rateroundedtextbutton(text: 'Rate',width: MediaQuery.of(context).size  .width *0.9),
                              SizedBox(height: 20,),
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Column(
                                children: <Widget>[
                                  Text('Hours'),
                                  Obx(
                                    ()=> NumberPicker(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(16),
                                        border: Border.all(color: Colors.black26),
                                      ),
                                     // itemHeight: 15,
                                      //itemWidth: 15,
                                      value: mycontroller1.currentIntValue1.value,
                                      minValue: 0,
                                      maxValue: 23,
                                      step: 1,
                                      haptics: true,
                                      onChanged: (value) {
                                        mycontroller1.currentIntValue1change(value);
                                        },
                                      ),
                                  ),
                                   ]
                                  ),
                              SizedBox(width: 20,),
                              Column(
                                  children: <Widget>[
                                    Text('Minutes'),
                                    Obx(
                                      ()=> NumberPicker(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(16),
                                          border: Border.all(color: Colors.black26),
                                        ),
                                        value: mycontroller1.currentIntValue2.value,
                                        minValue: 0,
                                        maxValue: 59,
                                        step: 1,
                                        haptics: true,
                                        onChanged: (value) {
                                          mycontroller1.currentIntValue2change(value);
                                        },
                                      ),
                                    ),
                                  ]
                              ),
                              
                            ],
                          ),
                              SizedBox(height: 20,),
                              Container(
                                margin: EdgeInsets.all(10),
                                padding: EdgeInsets.all(10),
                                decoration: upperbox1,
                                child: Obx(()=>Center(child:  (Text('Total : Rs ${(mycontroller1.currentIntValue1.value + (mycontroller1.currentIntValue2.value/60))*mycontroller.rate.value}')),)),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 20,),
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
                                child: Center(child: Text('Add Payments')),
                              ),
                            ),

                      ]
                  ),
                ),
                History()
              ]
          )
      ),
    );
  }
}



