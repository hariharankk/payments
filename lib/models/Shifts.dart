import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';

class Shift extends Equatable {

  Shift.blank();

  String? shift_key;
  String? shift_type;
  DateTime? date;
  String? userid;


  Shift({this.userid, this.date, this.shift_type, this.shift_key,});

  String get shift => shift_key!;

  Map<dynamic, dynamic> toMap() {
    var map = new Map<String , dynamic>();
    map['type_of_shift'] = shift_type;
    map['date'] = date;
    map['userid'] = userid;
    return map;

  }

  @override
  List<Object> get props => [shift];

  factory Shift.fromJson(Map<dynamic,dynamic> map) {
    return Shift(
        userid : map['userid'],
        shift_type : map['type_of_shift'],
        date : map['date'],
        shift_key : map['shift_key']
    );
  }

}