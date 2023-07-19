import 'package:flutter/material.dart';
import 'package:upi_india/upi_india.dart';


class UpiPage extends StatefulWidget {
  @override
  _UpiPageState createState() => _UpiPageState();
}

class _UpiPageState extends State<UpiPage> {
  Future? _transaction;
  UpiIndia _upiIndia = UpiIndia();
  List<UpiApp>? apps;

  TextStyle header = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
  );

  TextStyle value = TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 14,
  );

  @override
  void initState() {
    _upiIndia.getAllUpiApps().then((value) {
      setState(() {
        apps = value;
      });
    }).catchError((e) {
      apps = [];
    });
    super.initState();
  }

  Future<void> initiateTransaction(UpiApp app, BuildContext context) async {
    String receiverName = '';
    String receiverUpiId = '';
    String transactionRefId = '';
    double amount = 0.0;

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Enter Payment Details'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                onChanged: (value) => receiverName = value,
                decoration: InputDecoration(
                  labelText: 'Receiver Name',
                ),
              ),
              TextField(
                onChanged: (value) => receiverUpiId = value,
                decoration: InputDecoration(
                  labelText: 'Receiver UPI ID',
                ),
              ),
              TextField(
                onChanged: (value) => transactionRefId = value,
                decoration: InputDecoration(
                  labelText: 'Transaction Reference ID',
                ),
              ),
              TextField(
                onChanged: (value) => amount = double.tryParse(value) ?? 0.0,
                decoration: InputDecoration(
                  labelText: 'Amount',
                ),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.of(context).pop();
                await _upiIndia.startTransaction(
                  app: app,
                  receiverName: receiverName,
                  receiverUpiId: receiverUpiId,
                  transactionRefId: transactionRefId,
                  amount: amount,
                );
              },
              child: Text('Pay'),
            ),
          ],
        );
      },
    );
  }

  Widget displayUpiApps() {
    if (apps == null)
      return Center(child: CircularProgressIndicator());
    else if (apps!.length == 0)
      return Center(
        child: Text(
          "No apps found to handle transaction.",
          style: header,
        ),
      );
    else
      return Align(
        alignment: Alignment.topCenter,
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Wrap(
            children: apps!.map<Widget>((UpiApp app) {
              return GestureDetector(
                onTap: () {
                  _transaction = initiateTransaction(app, context);
                  setState(() {});
                },
                child: Container(
                  height: 100,
                  width: 100,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Image.memory(
                        app.icon!,
                        height: 60,
                        width: 60,
                      ),
                      Text(app.name!),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      );
  }

  String _upiErrorHandler(dynamic error) {
    if (error is UpiIndiaAppNotInstalledException) {
      return 'Requested app not installed on device';
    } else if (error is UpiIndiaUserCancelledException) {
      return 'You cancelled the transaction';
    } else if (error is UpiIndiaNullResponseException) {
      return 'Requested app didn\'t return any response';
    } else if (error is UpiIndiaInvalidParametersException) {
      return 'Requested app cannot handle the transaction';
    } else {
      return 'An Unknown error has occurred';
    }
  }

  void _checkTxnStatus(String status) {
    switch (status) {
      case UpiPaymentStatus.SUCCESS:
        print('Transaction Successful');
        break;
      case UpiPaymentStatus.SUBMITTED:
        print('Transaction Submitted');
        break;
      case UpiPaymentStatus.FAILURE:
        print('Transaction Failed');
        break;
      default:
        print('Received an Unknown transaction status');
    }
  }

  Widget displayTransactionData(String title, String body) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "$title: ",
            style: header,
          ),
          Flexible(
            child: Text(
              body,
              style: value,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('UPI'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: displayUpiApps(),
          ),
          Expanded(
            child: FutureBuilder<dynamic>(
              future: _transaction,
              builder: (BuildContext context,
                  AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        _upiErrorHandler(snapshot.error),
                        style: header,
                      ),
                    );
                  }

                  UpiResponse? _upiResponse = snapshot.data;
                  if (_upiResponse != null) {
                    String txnId = _upiResponse.transactionId ?? 'N/A';
                    String resCode = _upiResponse.responseCode ?? 'N/A';
                    String txnRef = _upiResponse.transactionRefId ?? 'N/A';
                    String status = _upiResponse.status ?? 'N/A';
                    String approvalRef = _upiResponse.approvalRefNo ?? 'N/A';
                    _checkTxnStatus(status);

                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          displayTransactionData('Transaction Id', txnId),
                          displayTransactionData('Response Code', resCode),
                          displayTransactionData('Reference Id', txnRef),
                          displayTransactionData('Status', status.toUpperCase()),
                          displayTransactionData('Approval No', approvalRef),
                        ],
                      ),
                    );
                  } else {
                    return Center(child: Text('No transaction data'));
                  }
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
