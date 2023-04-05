import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart'
    show CalendarCarousel;
import 'package:intl/intl.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/classes/event_list.dart';
import 'package:payment/services/dummybloc.dart';



class employeeCalendar extends StatelessWidget{
  @override
  String userid;
  employeeCalendar({required this.userid});

  List NightDates = [
  ];

  List LeaveDates = [
  ];


  List MorningDates = [
  ];

  static Widget _presentIcon(String day) => CircleAvatar(
    backgroundColor: Colors.blue[200],
    child: Text(
      day,
      style: TextStyle(
        color: Colors.black,
      ),
    ),
  );

  static Widget _LeaveIcon(String day) => CircleAvatar(
    backgroundColor: Colors.green[200],
    child: Text(
      day,
      style: TextStyle(
        color: Colors.black,
      ),
    ),
  );

  static Widget _MorningIcon(String day) => CircleAvatar(
    backgroundColor: Colors.red[400],
    child: Text(
      day,
      style: TextStyle(
        color: Colors.black,
      ),
    ),
  );


  CalendarCarousel? _calendarCarouselNoHeader;

  double? cHeight;

  @override
  Widget build(BuildContext context) {
    shiftBloc.Shift_getdata(userid);
    cHeight = MediaQuery.of(context).size.height;

    return StreamBuilder(
      stream: shiftBloc.getShift,//paymentBloc.paymentadmin, // pass our Stream getter here
      initialData: [], // provide an initial data
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
            print("No data");
            break;
          case ConnectionState.active:
            EventList<Event> _markedDateMap = new EventList<Event>(
              events: {},
            );
            MorningDates = snapshot.data != null ? snapshot.data![1]:[];
            NightDates = snapshot.data != null ? snapshot.data![0]:[];
            LeaveDates = snapshot.data != null ? snapshot.data![2]:[];

            for (int i = 0; i < NightDates.length; i++) {
              var dummy = NightDates[i];
              _markedDateMap.add(
                DateFormat('dd/MM/yyyy').parse(dummy['date']),
                new Event(
                  date:  DateFormat('dd/MM/yyyy').parse(dummy['date']),
                  title: dummy['type_of_shift'],
                  icon: _presentIcon(
                    DateFormat('dd/MM/yyyy').parse(dummy['date']).day.toString(),
                  ),
                ),
              );
            }

            for (int i = 0; i < LeaveDates.length; i++) {
              var dummy = LeaveDates[i];
              _markedDateMap.add(
                DateFormat('dd/MM/yyyy').parse(dummy['date']),
                new Event(
                  date: DateFormat('dd/MM/yyyy').parse(dummy['date']),
                  title: dummy['type_of_shift'],
                  icon: _LeaveIcon(
                    DateFormat('dd/MM/yyyy').parse(dummy['date']).day.toString(),
                  ),
                ),
              );
            }

            //code for making morning dates and shift
            for (int i = 0; i < MorningDates.length; i++) {
              var dummy = MorningDates[i];
              _markedDateMap.add(
                DateFormat('dd/MM/yyyy').parse(dummy['date']),
                new Event(
                  date: DateFormat('dd/MM/yyyy').parse(dummy['date']),
                  title: dummy['type_of_shift'],
                  icon: _MorningIcon(
                    DateFormat('dd/MM/yyyy').parse(dummy['date']).day.toString(),
                  ),
                ),
              );
            }

            //click on the dates is not yet enabled
            _calendarCarouselNoHeader = CalendarCarousel<Event>(
              height: cHeight! * 0.54,
              onDayPressed: (data,data1){
                showModalBottomSheet(
                    context: context,
                    builder: (context) =>  ShiftPicker()).then((value){
                  shiftBloc.addShift(data, value, userid);
                });
              },
              weekendTextStyle: TextStyle(
                color: Colors.green,
              ),
              todayButtonColor: Colors.purple,
              markedDatesMap: _markedDateMap,
              markedDateShowIcon: true,
              markedDateIconMaxShown: 1,
              markedDateMoreShowTotal: null,
              markedDateIconBuilder: (event) {
                return event.icon;
              },
            );

            return       Scaffold(
              appBar: new AppBar(
                title: new Text("Employee Calendar"),
                centerTitle: true,
              ),
              body: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    _calendarCarouselNoHeader!,
                    markerRepresent(Colors.red[400], "Morning Shift"),
                    markerRepresent(Colors.blue[200], "Night Shift"),
                    markerRepresent(Colors.purple, "Today"),
                    markerRepresent(Colors.green, "Holiday"),
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

  //encircle the dates according to colour legend
  Widget markerRepresent(Color? color, String data) {
    return new ListTile(
      leading: new CircleAvatar(
        backgroundColor: color,
        radius: cHeight! * 0.010,
      ),
      title: new Text(
        data,
      ),
    );
  }
}

class ShiftPicker extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300.0,
      color: Colors.white,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 16.0),
            child: Text(
              'Select Shift',
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
          ),
          Divider(),
          Expanded(
            child: ListView(
              children: [
                _buildShiftRow(context,  'Morning Shift','9AM - 9PM', Colors.red),
                _buildShiftRow(context, 'Night Shift','9PM - 9AM', Colors.blue),
                _buildShiftRow(context, 'Leave', 'absent',Colors.green),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShiftRow(BuildContext context, String title,String subtitle, Color color) {


    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
          child: Text(
            title,
            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
          ),
        ),
        ListTile(
          title: Text(subtitle),
          leading: Icon(Icons.circle, color: color),
          onTap: () {
           Get.back(result: title);
          },
        ),

        Divider(),
      ],
    );
  }
}
