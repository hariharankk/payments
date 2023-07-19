import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
// ignore: must_be_immutable
//
class loc extends Equatable {
  late String? location_key;
  String userid;
  String longi;
  String lat;
  String time;


  loc(
      {
        this.location_key,
        required this.userid,
        required this.longi,
        required this.lat,
        required this.time,
      });

  factory loc.fromJson(Map<String, dynamic> parsedJson) {
    return loc(
      location_key: parsedJson['location_key'],
      userid: parsedJson['userid'],
      longi: parsedJson['longi'],
      lat: parsedJson['lat'],
      time:  DateFormat.jm().format(DateFormat('yyyy-MM-dd HH:mm:ss').parse(DateFormat('yyyy-MM-dd HH:mm:ss').format(DateFormat('EEE, dd MMM yyyy HH:mm:ss Z').parse(parsedJson['time'])),))
    );
  }

  Map<dynamic, dynamic> toMap(){
    var map = new Map<String, dynamic>();
    map['userid']=this.userid;
    map['longi'] = this.longi;
    map['lat'] = this.lat;
    map['time'] = this.time;
    return map;
  }

  @override
  List<Object> get props => [location_key!];

  @override
  String toString() {
    return "location Key: $location_key";
  }
}