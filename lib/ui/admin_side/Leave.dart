import 'package:flutter/material.dart';
import 'package:payment/models/Leave.dart';
import 'package:payment/services/dummybloc.dart';
import 'package:get/get.dart';
//import 'package:sms/sms.dart';
import 'package:payment/services/firebase_service.dart';


class LeaveRequestWidget extends StatelessWidget {


  //void sendSms(String number, String messages) {
  //  SmsSender sender = new SmsSender();
  //  String address = number; // recipient's phone number
  //  String message = messages;
   // sender.sendSms(new SmsMessage(address, message));
  //}
  final apiProvider1 = apirepository();

  @override
  Widget build(BuildContext context) {
    leaveBloc.leave_getdata();
    return StreamBuilder(
      // Wrap our widget with a StreamBuilder
      stream: leaveBloc.getLeave, // pass our Stream getter here
      initialData: [], // provide an initial data
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
            print("No data");
            break;
          case ConnectionState.active:
            var _leaveRequests = snapshot.data != null ? snapshot.data : [];
            return Scaffold(
              body: ListView.builder(
                itemCount: _leaveRequests!.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(_leaveRequests![index].name),
                    subtitle: Text("${_leaveRequests![index].date}"),
                    trailing: ElevatedButton(
                      onPressed: () {
                        _showLeaveDetailsDialog(
                            context, _leaveRequests![index]);
                      },
                      child: Text("Details"),
                    ),
                  );
                },
              ),
            );
          case ConnectionState.waiting:
            return Center(child: CircularProgressIndicator(color: Colors.blue));
        }
        return CircularProgressIndicator();
      },
    );
  }

  void _showLeaveDetailsDialog(
      BuildContext context, LeaveRequest leaveRequest) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Leave Details"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Name: ${leaveRequest.name}"),
              SizedBox(height: 8),
              Text("Duration : ${leaveRequest.date}"),
              SizedBox(height: 8),
              Text("Reason: ${leaveRequest.reason}"),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                //sendSms(leaveRequest.phonenumber, '${leaveRequest.name}, your leave request has been accepted');
                apiProvider1.LeaveShifts_adddata(leaveRequest.startDate, leaveRequest.endDate, leaveRequest.userid);
                leaveBloc.Leavedelete(leaveRequest.leave_key);
                Get.back();
              },
              child: Text("Approve"),
            ),
            ElevatedButton(
              onPressed: () {
                //sendSms(leaveRequest.phonenumber, '${leaveRequest.name}, your leave request has been rejected');
                leaveBloc.Leavedelete(leaveRequest.leave_key);
                Get.back();
              },
              child: Text("Discard"),
            ),
          ],
        );
      },
    );
  }
}

