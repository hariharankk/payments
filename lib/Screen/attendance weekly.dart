import 'package:payment/models/history.dart';
import 'package:flutter/material.dart';
import 'package:table_sticky_headers/table_sticky_headers.dart';
import 'package:payment/loc/mymap.dart';
import 'package:get/get.dart';
import 'package:rxdart/rxdart.dart';
import 'package:payment/services/firebase_service.dart';
import 'package:intl/intl.dart';

class AttendanceHistoryweek extends StatefulWidget {
  final String userId;

  AttendanceHistoryweek(
      { required this.userId});

  @override
  _AttendanceHistoryweekState createState() => _AttendanceHistoryweekState();
}

class _AttendanceHistoryweekState extends State<AttendanceHistoryweek> {
  late List<List<String>> data;
  final PublishSubject<dynamic> _historyGetter = PublishSubject<dynamic>();
  List<String> columnNames = ['Check In Time', 'Check Out Time', 'Hours Spent'];
  late List<String> rowNames;
  DateTime selectedStartDate = DateTime.now();
  DateTime selectedEndDate = DateTime.now();

  @override
  void initState() {
    columnNames = ['Check In Time', 'Check Out Time', 'Hours Spent'];
    super.initState();
      fetchDataAndAddToStream(); // Call the new method here

  }

  Future<void> fetchDataAndAddToStream() async {
    final apiProvider1 = apirepository();
    var fetchedData = await apiProvider1.history_getdataweekly(
        widget.userId,       DateFormat('dd/MM/yyyy').format(selectedEndDate),
        // change from widget.enddate
        DateFormat('dd/MM/yyyy').format(
            selectedStartDate),);
    print("Fetched Data: $fetchedData"); // Debug print statement
    _historyGetter.sink.add(fetchedData);
  }

  void dispose() {
    _historyGetter.close();
    print('dispose page one');
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context,
      {required bool isStartDate}) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isStartDate ? selectedStartDate : selectedEndDate,
      firstDate: DateTime(2015, 8),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        if (isStartDate) {
          selectedStartDate = picked;
        } else {
          selectedEndDate = picked;
        }
      });
      if (selectedStartDate.isBefore(selectedEndDate)) {
        final apiProvider1 = apirepository();
      var fetchedData = await apiProvider1.history_getdataweekly(
        widget.userId,
        DateFormat('dd/MM/yyyy').format(selectedEndDate),
        // change from widget.enddate
        DateFormat('dd/MM/yyyy').format(
            selectedStartDate), // change from widget.startdate
      );
      print("Fetched Data: $fetchedData"); // Debug print statement
      _historyGetter.sink.add(fetchedData);
    }
    }
  }

  Widget _buildWeekPicker() {
    return Column(
      children: <Widget>[
        SizedBox(height: 10), // for spacing
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: Colors.deepPurple,
            onPrimary: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
          ),
          onPressed: () => _selectDate(context, isStartDate: true),
          child: Text(selectedStartDate == null
              ? 'Select start date'
              : '${selectedStartDate!.day}-${selectedStartDate!
              .month}-${selectedStartDate!.year}'),
        ),
        SizedBox(height: 10),
        Center(
          child: Text('To'),
        ),
        SizedBox(height: 10), // for spacing
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: Colors.deepPurple,
            onPrimary: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
          ),
          onPressed: () => _selectDate(context, isStartDate: false),
          child: Text(selectedEndDate == null
              ? 'Select end date'
              : '${selectedEndDate!.day}-${selectedEndDate!
              .month}-${selectedEndDate!.year}'),
        ),
      ],
    );
  }

  /// Make a 2-d array of the data
  _makeData(List<dynamic> snapshots) {
    var temp = <List<String>>[]; // Changed to growable list
    var rows = <String>[]; // Changed to growable list

    int i = 0;
    for (var snapshot in snapshots) {
      List<String> row = _makeDataItem(snapshot);
      rows.add(row[0]);
      temp.add([]); // Changed to growable list
      temp[i].add(row[1]);
      temp[i].add(row[2]);
      temp[i].add(row[3]);
      ++i;
    }
    rowNames = rows;

    return temp;
  }

  //// Extract Data from snapshot and convert it into a LIST
  List<String> _makeDataItem(Map<dynamic, dynamic> data) {
    final history = History.fromMap(data);

    DateTime checkIn = DateTime.parse(history.checkIn!);
    DateTime? checkOut;
    if (history.checkOut != "-") checkOut = DateTime.parse(history.checkOut!);
    String hrs = history.hrsSpent!;

    String date = checkIn.day.toString() +
        "/" +
        checkIn.month.toString() +
        "/" +
        checkIn.year.toString();
    String inTime = checkIn.hour.toString() + ":" + checkIn.minute.toString();
    String outTime = history.checkOut == "-"
        ? "-"
        : checkOut!.hour.toString() + ":" + checkOut.minute.toString();

    List<String> dateData = [];
    dateData.add(date);
    dateData.add(inTime);
    dateData.add(outTime);
    dateData.add(hrs);
    return dateData;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
      AppBar(title: Text("Attendance History"),),
      body: Column(
        children: [
          SizedBox(
            height: 10,
          ),
          Padding(
              padding: EdgeInsets.all(20),
              child: Text(
                'Search attendance using the filters below',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              )),
          SizedBox(
            height: 10,
          ),

          _buildWeekPicker(),

          SizedBox(
            height: 10,
          ),

          Expanded(
            child: StreamBuilder(
              stream: _historyGetter, //history_soc.getResponse,
              builder: (context, AsyncSnapshot<dynamic> snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: Text('Has no Data'));
                }

                data = _makeData(snapshot.data!);

                return StickyHeadersTable(
                  columnsLength: 3,
                  rowsLength: snapshot.data!.length,
                  columnsTitleBuilder: (i) =>
                      TableCell.stickyRow(
                        columnNames[i],
                        onTap: () {},
                        textStyle: TextStyle(fontSize: 18.0),
                      ),
                  rowsTitleBuilder: (i) =>
                      TableCell.stickyColumn(
                        rowNames[i],
                        onTap: () {},
                        textStyle: TextStyle(fontSize: 18.0),
                      ),
                  contentCellBuilder: (i, j) =>
                      TableCell.content(
                        data[j][i],
                        onTap: () {},
                        textStyle: TextStyle(fontSize: 16.0),
                      ),
                  legendCell: TableCell.legend(
                    'Date',
                    onTap: () {},
                    textStyle: TextStyle(fontSize: 20.0),
                  ),
                  cellFit: BoxFit.cover,
                  cellDimensions: CellDimensions(
                    contentCellHeight: 74.0,
                    contentCellWidth: 100.0,
                    stickyLegendHeight: 72.0,
                    stickyLegendWidth: 104.0,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

/// Class for Defining decoration in [Sticky Table Headers ]
class TableCell extends StatelessWidget {
  TableCell.content(this.text, {
    required this.textStyle,
    this.cellDimensions = const CellDimensions(
      contentCellHeight: 74.0,
      contentCellWidth: 100.0,
      stickyLegendHeight: 72.0,
      stickyLegendWidth: 104.0,
    ),
    this.colorBg = Colors.white,
    required this.onTap

  })
      : cellWidth = cellDimensions.contentCellWidth,
        cellHeight = cellDimensions.contentCellHeight,
        _colorHorizontalBorder = Colors.amber,
        _colorVerticalBorder = Colors.black38,
        _textAlign = TextAlign.center,
        _padding = EdgeInsets.zero;

  TableCell.legend(this.text, {
    required this.textStyle,
    this.cellDimensions = const CellDimensions(
      contentCellHeight: 74.0,
      contentCellWidth: 100.0,
      stickyLegendHeight: 72.0,
      stickyLegendWidth: 104.0,
    ),
    this.colorBg = Colors.amber,
    required this.onTap,
  })
      : cellWidth = cellDimensions.stickyLegendWidth,
        cellHeight = cellDimensions.stickyLegendHeight,
        _colorHorizontalBorder = Colors.white,
        _colorVerticalBorder = Colors.amber,
        _textAlign = TextAlign.start,
        _padding = EdgeInsets.zero;

  TableCell.stickyRow(this.text, {
    required this.textStyle,
    this.cellDimensions = const CellDimensions(
      contentCellHeight: 74.0,
      contentCellWidth: 100.0,
      stickyLegendHeight: 72.0,
      stickyLegendWidth: 104.0,
    ),
    this.colorBg = Colors.amber,
    required this.onTap,
  })
      : cellWidth = cellDimensions.contentCellWidth,
        cellHeight = cellDimensions.stickyLegendHeight,
        _colorHorizontalBorder = Colors.white,
        _colorVerticalBorder = Colors.amber,
        _textAlign = TextAlign.center,
        _padding = EdgeInsets.all(10.0);

  TableCell.stickyColumn(this.text, {
    required this.textStyle,
    this.cellDimensions = const CellDimensions(
      contentCellHeight: 74.0,
      contentCellWidth: 100.0,
      stickyLegendHeight: 72.0,
      stickyLegendWidth: 104.0,
    ),
    this.colorBg = Colors.white,
    required this.onTap,
  })
      : cellWidth = cellDimensions.stickyLegendWidth,
        cellHeight = cellDimensions.contentCellHeight,
        _colorHorizontalBorder = Colors.amber,
        _colorVerticalBorder = Colors.black38,
        _textAlign = TextAlign.start,
        _padding = EdgeInsets.zero;

  final CellDimensions cellDimensions;

  final String text;
  final onTap;

  final double cellWidth;
  final double cellHeight;

  final Color colorBg;
  final Color _colorHorizontalBorder;
  final Color _colorVerticalBorder;

  final TextAlign _textAlign;
  final EdgeInsets _padding;

  final TextStyle textStyle;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: cellWidth,
        height: cellHeight,
        padding: _padding,
        child: Column(
          children: <Widget>[
            Expanded(
              child: Container(
                width: 80.0,
                alignment: Alignment.center,
                child: Text(
                  text,
                  style: textStyle,
                  maxLines: 2,
                  textAlign: _textAlign,
                ),
              ),
            ),
            Container(
              width: double.infinity,
              height: 1.1,
              color: _colorVerticalBorder,
            ),
          ],
        ),
        decoration: BoxDecoration(
            border: Border(
              left: BorderSide(color: _colorHorizontalBorder),
              right: BorderSide(color: _colorHorizontalBorder),
            ),
            color: colorBg),
      ),
    );
  }
}
