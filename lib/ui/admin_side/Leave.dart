import 'package:flutter/material.dart';
import 'package:payment/models/Leave.dart';
import 'package:payment/services/dummybloc.dart';
import 'package:payment/models/approval.dart';

class LeaveRequestWidget extends StatelessWidget {
  final Approval approval;
  LeaveRequestWidget({required this.approval});


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
            print(snapshot.data);
            var _leaveRequests = snapshot.data != null ? snapshot.data : [];
            return Scaffold(
              appBar: AppBar(
                title: Text("Leave Requests"),
              ),
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
              Text("Name: ${approval.empName}"),
              SizedBox(height: 8),
              Text("Duration : ${leaveRequest.date}"),
              SizedBox(height: 8),
              Text("Reason: ${leaveRequest.reason}"),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                leaveBloc.Leavedelete(leaveRequest.leave_key);
              },
              child: Text("Approve"),
            ),
            ElevatedButton(
              onPressed: () {
                leaveBloc.Leavedelete(leaveRequest.leave_key);
              },
              child: Text("Discard"),
            ),
          ],
        );
      },
    );
  }
}
