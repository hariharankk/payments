import 'package:equatable/equatable.dart';

class Payments extends Equatable {

  Payments.blank();

  String? payments_key;
  String? notes;
  String? category;
  int? ammount;
  DateTime? time;
  String? username;
  String? type_of_note;

  Payments({this.ammount, this.category, this.notes, this.payments_key, this.time, this.username, this.type_of_note });

  Payments.map(dynamic obj) {
    payments_key = obj['payments_key'];
    notes = obj['notes'];
    ammount = obj['ammount'];
    category = obj['category'];
    time = obj['time'];
    username = obj['userid'];
    type_of_note = obj['type_of_note'];

  }

  String get payment => payments_key!;

  Map<dynamic, dynamic> toMap() {
    var map = new Map<String , dynamic>();
    map['payments_key'] = payments_key;
    map['notes'] = notes;
    map['category'] = category;
    map['ammount'] = ammount;
    map['time'] = time;
    map['userid'] = username;
    map['type_of_note'] = type_of_note;
    return map;

  }

  @override
  List<Object> get props => [payment];

  Payments.fromMap(Map<dynamic,dynamic> map) {
    this.ammount = map['ammount'];
    this.notes = map['notes'];
    this.category = map['category'];
    this.payments_key = map['payments_key'];
    this.time = map['time'];
    this.username = map['userid'];
    this.type_of_note = map['type_of_note'];
  }

}