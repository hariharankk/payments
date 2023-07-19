import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:month_year_picker/month_year_picker.dart';
import 'package:get/get.dart';
import 'package:payment/GetX/history_getx.dart';
import 'package:payment/models/Payments.dart';
import 'package:payment/services/dummybloc.dart';
import 'package:payment/GetX/payment_getx.dart';

class History extends StatelessWidget {
   History({Key? key}) : super(key: key);


   final mycontroller = Get.put(HistoryController());
   final mycontroller1 = Get.find<PaymentController>();
   final paymentBloc = PaymentBloc();

   Future pickDate(BuildContext context) async {
     final _selected = await showMonthYearPicker(
       context: context,
       initialDate: DateTime.now(),
       firstDate: DateTime(2019),
       lastDate: DateTime(2024),

     );

     if (_selected != null){
       mycontroller.change(DateFormat("MMMM, yyyy").format(_selected));
       paymentBloc.payment_getdata(mycontroller.date.value, 'Allowance', mycontroller1.empidValue.value);

     }
   }


  @override
  Widget build(BuildContext context) {
    paymentBloc.payment_getdata(mycontroller.date.value, 'Allowance', mycontroller1.empidValue.value);
    return
      StreamBuilder(
        // Wrap our widget with a StreamBuilder
        stream: paymentBloc.paymentadmin, // pass our Stream getter here
        initialData: [], // provide an initial data
        builder: (context, AsyncSnapshot<dynamic> snapshot) {
      switch (snapshot.connectionState) {
        case ConnectionState.none:
          print("No data");
          break;
        case ConnectionState.active:
          print(snapshot.data);
          var data = snapshot.data != null ? snapshot.data![0]:[];
          return       SingleChildScrollView(
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
                  Text(snapshot.data != null?snapshot.data![1].toString():''),
                ],
              ),
            ),
            Divider(
              color: Colors.grey,
            ),
            ListView.builder(
              itemBuilder: (BuildContext context, int index) {
                return historylist('Allowance',data[index],paymentBloc,);
              },

              physics: NeverScrollableScrollPhysics(),
              itemCount: data.length,
              shrinkWrap: true,
            )
          ],
        ),
      ),
    );
        case ConnectionState.waiting:
          return Center(
              child: CircularProgressIndicator(color: Colors.blue));
      }
      return CircularProgressIndicator();
        },
      );
  }
}

class historylist extends StatelessWidget {
  historylist(this.Context,this.payments,this.paymentBloc);
  Payments payments;
  PaymentBloc paymentBloc;
  String Context;
  final mycontroller = Get.put(HistoryController());
  final mycontroller1 = Get.find<PaymentController>();

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: UniqueKey(),
      direction: DismissDirection.endToStart,
      onDismissed: (dissm){
        paymentBloc.deletepayment(payments.payment,mycontroller.date.value, Context, mycontroller1.empidValue.value);
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
        title: Text(payments.time!),
        subtitle: Text(payments.notes!,style: TextStyle(fontWeight: FontWeight.bold),),
        trailing: Text(payments.ammount!.toString()),
      ),
    );
  }
}