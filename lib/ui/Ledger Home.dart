import 'package:flutter/material.dart';
import 'package:payment/global.dart';
import 'package:payment/models/Payments.dart';
import 'package:payment/GetX/Frontpage getx.dart';
import 'package:payment/services/dummybloc.dart';
import 'package:intl/intl.dart';
import 'package:month_year_picker/month_year_picker.dart';
import 'package:get/get.dart';
import 'package:payment/services/Bloc.dart';

class Ledger extends StatelessWidget {
  Ledger({Key? key}) : super(key: key);
  final mycontroller = Get.put(MainController());

  @override
  Widget build(BuildContext context) {
    ledgerbloc.Ledger_getdata(
        mycontroller.date.value, userBloc.getUserObject().user);
    return StreamBuilder(
      // Wrap our widget with a StreamBuilder
      stream: ledgerbloc.Ledgeradmin, // pass our Stream getter here
      initialData: [], // provide an initial data
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
            print("No data");
            break;
          case ConnectionState.active:
            print(snapshot.data);
            var data = (snapshot.data != null) ? snapshot.data![0] : [];
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
                              Text('you have got'),
                              Text(
                                snapshot.data != null
                                    ? snapshot.data![1].toString()
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
                              Text('you have to get'),
                              Text(
                                snapshot.data != null
                                    ? snapshot.data![2].toString()
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

  Future pickDate(BuildContext context) async {
    final _selected = await showMonthYearPicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2019),
      lastDate: DateTime(2024),
    );

    if (_selected != null) {
      mycontroller.change(DateFormat("MMMM, yyyy").format(_selected));
      ledgerbloc.Ledger_getdata(
          mycontroller.date.value, userBloc.getUserObject().user);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text('The Ledger Balance For '),
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
                  borderRadius: BorderRadius.circular(10), color: Colors.blue),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center ,
                children: [
                  Obx(() => Text(mycontroller.date.value)),
                  Icon(Icons.arrow_drop_down)
                ],
              ),
            ),
          ),
        )
      ],
    );
  }
}

class ledgertile extends StatelessWidget {
  Payments payments;

  ledgertile({required this.payments});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width * 0.2;
    double width1 = MediaQuery.of(context).size.width * 0.0075;

    return Container(
      height: MediaQuery.of(context).size.height * 0.15,
      decoration: ledgerbor,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Container(
              height: MediaQuery.of(context).size.height * 0.15,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Padding(
                        padding: EdgeInsets.all(width1),
                        child: Text(
                          payments.time!,
                          style: ledgertimestyle,
                        )),
                    Padding(
                        padding: EdgeInsets.all(width1),
                        child: Center(
                            child: Text(
                          payments.category! + ':- ' + payments.notes!,
                          style: ledgertextstyle,
                        ))),
                  ]),
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height * 0.15,
            width: width,
            color: Colors.red,
            child: Center(
                child: payments.type_of_note == 'Credit'
                    ? Text(
                        payments.ammount.toString()!,
                        style: ledgertextstyle,
                      )
                    : Text('')),
          ),
          Container(
            height: MediaQuery.of(context).size.height * 0.15,
            width: width,
            //padding: EdgeInsets.fromLTRB(width, 0, width, 0),
            color: Colors.green,
            child: Center(
                child: payments.type_of_note == 'Debit'
                    ? Text(
                        payments.ammount.toString()!,
                        style: ledgertextstyle,
                      )
                    : Text('')),
          ),
        ],
      ),
    );
  }
}
