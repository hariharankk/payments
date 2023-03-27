import 'package:flutter/material.dart';
import 'package:payment/widgets/date picker.dart';
import 'package:get/get.dart';
import 'package:payment/widgets/rounded button.dart';
import 'package:payment/GetX/feautre_getx.dart';
import 'package:payment/global.dart';
import 'package:payment/models/Payments.dart';
import 'package:payment/services/firebase_service.dart';
import 'package:payment/GetX/payment_getx.dart';


class hourlybasissalary extends StatelessWidget {
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
                roundedtextbutton(text: 'Hour Description',width: MediaQuery.of(context).size  .width *0.90),
                Row(
                  children: [
                    rateroundedtextbutton(text: 'Rate',width: MediaQuery.of(context).size  .width *0.45),
                    rateroundedtextbutton(text: 'Time',width: MediaQuery.of(context).size  .width *0.45),
                  ],
                ),
                Row(
                  children: <Widget>[
                    SizedBox(width: 5,),
                    DatePickerWidget(),
                    roundedtextbutton(text: 'Notes',width: MediaQuery.of(context).size  .width *0.65),
                  ],
                ),
                SizedBox(width: 5,),
                Container(
                  margin: EdgeInsets.all(10),
                  padding: EdgeInsets.all(10),
                  decoration: upperbox1,
                  child: Obx(()=>Center(child:  (Text('Total : Rs ${mycontroller.rate.value * mycontroller.quantity.value}')),)),
                ),
              ],
            ),
          ),

          GestureDetector(
            onTap: (){
              final apiProvider1 = apirepository();
              Payments payments = Payments(
                  ammount: (mycontroller.rate.value * mycontroller.quantity.value).toInt(),
                  notes: 'Horuly Basis Salary:- '+ mycontroller.notestext.value,
                  category: 'Salary',
                  type_of_note: 'Debit',
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
              child: Center(child: Text('Add Hourly wage')),
            ),
          ),
        ],
      ),
    );

  }
}



