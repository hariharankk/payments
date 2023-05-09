import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart'
    show CalendarCarousel;
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/classes/event_list.dart';
import 'package:payment/services/dummybloc.dart';
import 'package:intl/intl.dart';
import 'package:payment/ui/Leave req.dart';
import 'package:payment/services/Bloc.dart';


class clientemployeeCalendar extends StatelessWidget{
  @override


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
    shiftBloc.Shift_getdata(userBloc.getUserObject().user);
    cHeight = MediaQuery.of(context).size.height;

    //click on the dates is not yet enabled


    return       StreamBuilder(
      stream: shiftBloc.getShift,//paymentBloc.paymentadmin, // pass our Stream getter here
      initialData: [], // provide an initial data
      builder: (context, AsyncSnapshot<dynamic> snapshot) {
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

            _calendarCarouselNoHeader = CalendarCarousel<Event>(
              height: cHeight! * 0.54,
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
              body: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    _calendarCarouselNoHeader!,
                    markerRepresent(Colors.red[400], "Morning Shift"),
                    markerRepresent(Colors.blue[200], "Night Shift"),
                    markerRepresent(Colors.purple, "Today"),
                    markerRepresent(Colors.green, "Holiday"),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          fixedSize: Size(150, 80),
                        ),
                        child: FittedBox(
                          child: Text(
                            "Apply for Leave",
                            style: TextStyle(fontSize: 40, color: Colors.white),
                          ),
                        ),
                        onPressed: () {
                          Get.to(()=>
                          LeavePage());
                        }
                    ), //leave request, select date, time , from , until , enter reason for leave


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
