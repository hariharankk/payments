import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:payment/widgets/date picker.dart';
import 'package:get/get.dart';
import 'package:payment/widgets/rounded button.dart';
import 'package:payment/global.dart';

class allowance extends StatelessWidget {
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
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                        child: Column(
                          children: <Widget>[
                            SizedBox(height: 20,),
                            roundedtextbutton(text: 'Payment Amount',width: MediaQuery.of(context).size  .width *0.90,),
                            Row(
                              children: <Widget>[
                                SizedBox(width: 5,),
                                DatePickerWidget(),
                                roundedtextbutton(text: 'Notes',width: MediaQuery.of(context).size  .width *0.65),
                             ],
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
                          child: Center(child: Text('Pay Allowance')),
                        ),
                     ),
                   ]
                 ),
                Container()
              ]
            )
          ),
    );
   }
}
