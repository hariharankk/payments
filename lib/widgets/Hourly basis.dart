import 'package:flutter/material.dart';
import 'package:payment/widgets/date picker.dart';
import 'package:get/get.dart';
import 'package:payment/widgets/rounded button.dart';
import 'package:payment/GetX/feautre_getx.dart';
import 'package:payment/global.dart';


class hourlybasissalary extends StatelessWidget {
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



