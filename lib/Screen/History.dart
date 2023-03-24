import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:month_year_picker/month_year_picker.dart';
import 'package:get/get.dart';
import 'package:payment/GetX/history_getx.dart';

class History extends StatelessWidget {
   History({Key? key}) : super(key: key);


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
    return SingleChildScrollView(
      child: Container(

        child: Column(
          children: [
            Container(
              width: double.infinity,
              margin: EdgeInsets.all(15),
              child: Row(
                children: <Widget>[
                  Text('select month'),
                  
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
                      child: Row(
                        children: [
                          Obx(()=>
                              Text( mycontroller.date.value)),
                          Icon(Icons.arrow_drop_down)
                        ],
                      ),
                    ),
                  )
                  
                ],
              ),
            ),
            Container(
              width: double.infinity,
              margin: EdgeInsets.all(15),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Total Allowance'),
                  Text('amount'),
                ],
              ),
            ),
            Divider(
              color: Colors.grey,
            ),
            ListView.builder(itemBuilder: (BuildContext context, int index) {
              return historylist();
            },

            physics: NeverScrollableScrollPhysics(),
            itemCount: 10,
            shrinkWrap: true,
            )
          ],
        ),
      ),
    );
  }
}

class historylist extends StatelessWidget {
  const historylist({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: UniqueKey(),
      direction: DismissDirection.endToStart,
      onDismissed: (dissm){

      },
      background: Container(
        alignment: AlignmentDirectional.centerEnd,
        color: Colors.red,
        child: Icon(
          Icons.delete,
          color: Colors.black,
          size: 10,
        ),
      ),
      child: ListTile(
        title: Text('Date'),
        subtitle: Text('Notes'),
        trailing: Text('ammount'),
      ),
    );
  }
}
