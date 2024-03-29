import 'package:flutter/material.dart';
import 'package:payment/global.dart';
import 'package:payment/Screen/Ledger%20list.dart';
import 'package:payment/GetX/Frontpage getx.dart';
import 'package:payment/services/dummybloc.dart';
import 'package:intl/intl.dart';
import 'package:month_year_picker/month_year_picker.dart';
import 'package:get/get.dart';
import 'package:payment/GetX/payment_getx.dart';
import 'package:payment/GetX/Balance_getx.dart';

class Ledger extends StatelessWidget {
  Ledger({Key? key}) : super(key: key);
  final mycontroller = Get.put(MainController());
  final mycontroller1 = Get.find<PaymentController>();
  final mycontroller2 = Get.find<BalanceController>();


  @override
  Widget build(BuildContext context) {
    print('rebuilding the ledger');
    ledgerbloc.Ledger_getdata(
        mycontroller.date.value, mycontroller1.empidValue.value);
    return StreamBuilder(
      // Wrap our widget with a StreamBuilder
      stream: ledgerbloc.Ledgeradmin, // pass our Stream getter here
      initialData: [], // provide an initial data
      builder: (context, AsyncSnapshot<dynamic> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
            print("No data");
            break;
          case ConnectionState.active:
            print(snapshot.data);
            var data = (snapshot.data != null) ? snapshot.data![0] : [];
            WidgetsBinding.instance.addPostFrameCallback((_) {
              mycontroller2
                  .change(snapshot.data != null ? snapshot.data![3] : 0);
            });

            return Container(
              width: MediaQuery.of(context).size.width * 0.90,
              padding: EdgeInsets.all(20),
              decoration: mainbox,
              child: Column(
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width * 0.90,
                    height: MediaQuery.of(context).size.height * 0.2,
                    margin: EdgeInsets.fromLTRB(0, 20, 0, 20),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Expanded(child: month_button()),
                        Container(
                          height: MediaQuery.of(context).size.height * 0.2,
                          width: MediaQuery.of(context).size.width * 0.2,
                          color: Colors.red,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text('you have to pay', style: TextStyle(fontSize: 8),),
                              Text(
                                snapshot.data != null
                                    ? snapshot.data![2].toString()
                                    : '',
                                style: ledgerheaderstyle,
                              )
                            ],
                          ),
                        ),
                        Container(
                          height: MediaQuery.of(context).size.height * 0.2,
                          width: MediaQuery.of(context).size.width * 0.2,
                          color: Colors.green,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text('you have paid', style: TextStyle(fontSize: 8),),
                              Text(
                                snapshot.data != null
                                    ? snapshot.data![1].toString()
                                    : '',
                                style: ledgerheaderstyle,
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                    decoration: ledgerbor,
                  ),
                  Row(
                    children: [
                      Expanded(child: Center(child: Text('Entries'))),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.2,
                        child: Center(child: Text('Debit')),
                      ),
                      Container(
                          width: MediaQuery.of(context).size.width * 0.2,
                          child: Center(child: Text('Credit'))),
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  ListView.separated(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (BuildContext context, int index) {
                      return ledgertile(payments: data[index]);
                    },
                    separatorBuilder: (BuildContext context, int index) =>
                        const SizedBox(
                      height: 10,
                      child: ColoredBox(color: Colors.transparent),
                    ),
                    itemCount: data.length,
                  )
                ],
              ),
            );
          case ConnectionState.waiting:
            return Center(child: CircularProgressIndicator(color: Colors.blue));
        }
        return CircularProgressIndicator();
      },
    );
  }
}

class month_button extends StatelessWidget {
  final mycontroller = Get.find<MainController>();
  final mycontroller1 = Get.find<PaymentController>();
  final RxBool isAllSelected = false.obs;

  Future pickDate(BuildContext context) async {
      final _selected = await showMonthYearPicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2019),
        lastDate: DateTime(2024),
      );

      if (_selected != null) {
        print('selected day format ledger $_selected');
        mycontroller.change(DateFormat("MMMM, yyyy").format(_selected));
        ledgerbloc.Ledger_getdata(
            mycontroller.date.value, mycontroller1.empidValue.value);
      }
    }

   Future GetdataAll()async{
     mycontroller.change("All");
     ledgerbloc.Ledger_getdata(
         mycontroller.date.value, mycontroller1.empidValue.value);
   }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          'The Ledger Balance For ',
          style: TextStyle(fontSize: 10),
        ),
        GestureDetector(
          onTap: () {
            pickDate(context);
          },
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minWidth: 50,
              maxWidth: 150,
              minHeight: 50,
              maxHeight: 150,
            ),
            child: Container(
              margin: EdgeInsets.all(10),
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.blue,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Obx(() => Text(
                    mycontroller.date.value,
                    style: TextStyle(fontSize: 10),
                  )),
                  Icon(Icons.arrow_drop_down, size: 10),
                ],
              ),
            ),
          ),
        ),
        Obx(
              () => CheckboxListTile(
            title: Text("All"),
            value: isAllSelected.value,
            onChanged: (newValue) {
              isAllSelected.value = newValue ?? false;
              GetdataAll();
            },
            controlAffinity: ListTileControlAffinity.leading,
          ),
        ),
      ],
    );
  }
}

/*class month_button extends StatelessWidget {
  final mycontroller = Get.find<MainController>();
  final mycontroller1 = Get.find<PaymentController>();

  Future pickDate(BuildContext context) async {
    final _selected = await showMonthYearPicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2019),
      lastDate: DateTime(2024),
    );

    if (_selected != null) {
      print('selected day format ledger ${_selected}');
      mycontroller.change(DateFormat("MMMM, yyyy").format(_selected));
      ledgerbloc.Ledger_getdata(
          mycontroller.date.value, mycontroller1.empidValue.value);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text('The Ledger Balance For ', style: TextStyle(fontSize: 10),),
        GestureDetector(
            onTap: () {
              pickDate(context);
            },
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minWidth: 50,
                maxWidth: 150,
                minHeight: 50,
                maxHeight: 150,
              ),
              child: Container(
                margin: EdgeInsets.all(10),
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.blue),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center ,
                  children: [
                    Obx(() => Text(mycontroller.date.value, style: TextStyle(fontSize: 10),)),
                    Icon(Icons.arrow_drop_down,size: 10,)
                  ],
                ),
              ),
            )
        )
      ],
    );
  }
}*/
