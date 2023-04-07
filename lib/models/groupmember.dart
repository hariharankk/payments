 import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:payment/models/global.dart';

// ignore: must_be_immutable
class GroupMember extends Equatable {
  /// Member's First name

  /// Member's Username
  late String username;

  late String name;

  /// Member's Email Address
  late String emailaddress;

  late String role;
  /// Member's Phone Number
  late String phonenumber;


  bool selectedForAssignment = false;

  GroupMember.blank();
  GroupMember(
      {
      required this.emailaddress,
      required this.username,
      required this.phonenumber,
      }):role='',name='';
  GroupMember.withrole({
    required this.emailaddress,
    required this.username,
    required this.phonenumber,
    required this.role,
    required this.name
  });

  factory GroupMember.fromJson(Map<String, dynamic> parsedJson) {
    return GroupMember(
      username: parsedJson["username"],
      emailaddress: parsedJson["emailaddress"],
      phonenumber: parsedJson["phonenumber"],
    );
  }

  factory GroupMember.fromJsonwithrole(Map<String, dynamic> parsedJson) {
    return GroupMember.withrole(
      username: parsedJson["username"],
      emailaddress: parsedJson["emailaddress"],
      phonenumber: parsedJson["phonenumber"],
      role: parsedJson["role"],
      name: parsedJson["name"],
    );
  }

  @override
  List<Object> get props => [username];

  /// Get Group Member's Initials
  String initials(){
    return emailaddress.substring(0,1).toUpperCase()+emailaddress.substring(1,2).toUpperCase();}

  /// Create CircleAvatar
  CircleAvatar cAvatar({
    double radius = 16,
    Color color = Colors.blue,
    required double unitHeightValue,
  }) {
    return CircleAvatar(
      //backgroundImage: member.avatar,
      backgroundColor: color,
      child: selectedForAssignment
          ? Icon(Icons.check,
              size: radius * unitHeightValue + 8, color: Colors.white)
          : Text(
              this.initials(),
              style: TextStyle(
                fontFamily: "Segoe ui",
                fontWeight: FontWeight.bold,
                fontSize: radius * unitHeightValue*0.7,
                color: Colors.white,
              ),
            ),
      radius: radius * unitHeightValue,
    );
  }

  @override
  String toString() {
    return "Member: $name Assigned: $selectedForAssignment";
  }
}
