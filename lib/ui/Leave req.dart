import 'package:flutter/material.dart';
import 'package:payment/services/Bloc.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';
import 'package:payment/services/dummybloc.dart';


class LeavePage extends StatefulWidget {

  @override
  _LeavePageState createState() => _LeavePageState();
}

class _LeavePageState extends State<LeavePage> {
  String _leaveType = 'One Day'; // Default leave type
  DateTime? _startDate;
  DateTime? _endDate;
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;
  TextEditingController _reasonController = TextEditingController();
  String? date;

  void _submitForm() {

    if(_endDate == null){
      _endDate=_startDate;
    }

    _leaveType=='One Day'? date = DateFormat('dd/MM/yyyy').format(_startDate!):_leaveType=='Multiple Days'? date = '${DateFormat('dd/MM/yyyy').format(_startDate!)} to ${DateFormat('dd/MM/yyyy').format(_endDate!)}':_leaveType == 'Few Hours' ? date = '${DateFormat('dd/MM/yyyy').format(_startDate!)} From ${_startTime!.format(context)} to ${_endTime!.format(context)}':'';
    print(date);
    var data = {
      'start_date':_startDate.toString(),
      'end_date':_endDate.toString(),
      'reason':_reasonController.text,
      'userid':userBloc.getUserObject().user,
      'duration':date,
    };
    leaveBloc.Leave_adddata(data);
    Get.back();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(''),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Text(
              'Type of Leave',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: _leaveType,
              onChanged: (value) {
                setState(() {
                  _leaveType = value!;
                });
              },
              items: <String>['One Day', 'Multiple Days', 'Few Hours']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            SizedBox(height: 16),
            if (_leaveType == 'One Day')
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Date',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  InkWell(
                    onTap: () async {
                      DateTime? selectedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(Duration(days: 365)),
                      );
                      setState(() {
                        _startDate = selectedDate;
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.calendar_today),
                          SizedBox(width: 8),
                          Text(
                            _startDate == null
                                ? 'Select a date'
                                : _startDate!.toString().split(' ')[0],
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 16),

                ],
              ),

            if (_leaveType == 'Few Hours')
              Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Date',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    InkWell(
                      onTap: () async {
                        DateTime? selectedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime.now().add(Duration(days: 365)),
                        );
                        setState(() {
                          _startDate = selectedDate;
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.calendar_today),
                            SizedBox(width: 8),
                            Text(
                              _startDate == null
                                  ? 'Select a date'
                                  : _startDate!.toString().split(' ')[0],
                              style: TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 16),

                    Text(
                      'Time',
                      style: TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () async {
                              TimeOfDay? selectedTime = await showTimePicker(
                                context: context,
                                initialTime: TimeOfDay.now(),
                              );
                              setState(() {
                                _startTime = selectedTime;
                              });
                            },
                            child: Container(
                              padding: EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.access_time),
                                  SizedBox(width: 8),
                                  Text(
                                    _startTime == null
                                        ? 'Select a time'
                                        : '${_startTime!.hour.toString()
                                        .padLeft(2, '0')}:${_startTime!.minute
                                        .toString().padLeft(2, '0')}',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: InkWell(
                            onTap: () async {
                              TimeOfDay? selectedTime = await showTimePicker(
                                context: context,
                                initialTime: TimeOfDay.now(),
                              );
                              setState(() {
                                _endTime = selectedTime;
                              });
                            },
                            child: Container(
                              padding: EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.access_time),
                                  SizedBox(width: 8),
                                  Text(
                                    _endTime == null
                                        ? 'Select a time'
                                        : '${_endTime!.hour.toString().padLeft(
                                        2, '0')}:${_endTime!.minute.toString()
                                        .padLeft(2, '0')}',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ]
              ),
            if (_leaveType == 'Multiple Days')
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Date Range',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () async {
                            DateTime? selectedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime.now(),
                              lastDate: DateTime.now().add(Duration(days: 365)),
                            );
                            setState(() {
                              _startDate = selectedDate;
                            });
                          },
                          child: Container(
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.calendar_today),
                                SizedBox(width: 8),
                                Text(
                                  _startDate == null
                                      ? 'Select a start date'
                                      : _startDate!.toString().split(' ')[0],
                                  style: TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: InkWell(
                          onTap: () async {
                            DateTime? selectedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime.now(),
                              lastDate: DateTime.now().add(Duration(days: 365)),
                            );
                            setState(() {
                              _endDate = selectedDate;
                            });
                          },
                          child: Container(
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.calendar_today),
                                SizedBox(width: 8),
                                Text(
                                  _endDate == null
                                      ? 'Select an end date'
                                      : _endDate!.toString().split(' ')[0],
                                  style: TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            SizedBox(height: 16),
            TextField(
              controller: _reasonController,
              onChanged: (value){
                _reasonController.text = value;
              },
              decoration: InputDecoration(
                hintText: 'Reason',
                border: OutlineInputBorder(),
              ),
              minLines: 4,
              maxLines: 4,
            ),
            SizedBox(height: 40),
            Center(
              child: ConstrainedBox(
                constraints:  BoxConstraints.tightFor(width: MediaQuery.of(context).size.width * 0.2, height:  MediaQuery.of(context).size.height * 0.1),
                child: ElevatedButton(
                  onPressed: _submitForm,
                  child: Text('Submit'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

