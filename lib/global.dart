import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

TextStyle iconunder = TextStyle(color: Colors.black, fontSize: 10.sp);

TextStyle payment = TextStyle(fontWeight: FontWeight.bold,fontSize: 8.sp,color: Colors.white);

TextStyle ledger = TextStyle(fontWeight: FontWeight.bold,fontSize: 8.sp,color: Colors.black);

TextStyle innerstyle = TextStyle(color: Colors.white, fontSize: 7.sp);

TextStyle ledgertextstyle = TextStyle(color: Colors.black,fontSize: 5.sp,fontWeight: FontWeight.bold);

TextStyle ledgertimestyle = TextStyle(color: Colors.grey,fontSize: 6.sp,);

TextStyle amountstyle = TextStyle(color: Colors.white,fontSize: 12.sp,fontWeight: FontWeight.bold);

TextStyle ledgerheaderstyle = TextStyle(fontWeight: FontWeight.bold);

TextStyle outerheader = TextStyle(color: Colors.white,fontSize: 10.sp,);

Decoration paymentbor = BoxDecoration(borderRadius: BorderRadius.circular(20.0),color: Colors.blue);

Decoration ledgerbor = BoxDecoration(borderRadius: BorderRadius.circular(10.0),border: Border.all(color: Colors.black, style: BorderStyle.solid, width: 3.0,), color: Colors.transparent,);

Decoration mainbox = BoxDecoration(borderRadius: BorderRadius.circular(30.0),color: Colors.white);

Decoration upperbox =  BoxDecoration(borderRadius: BorderRadius.circular(20.0), color: Colors.yellowAccent[700],);

Decoration upperbox1 =  BoxDecoration(borderRadius: BorderRadius.circular(5.0), color: Colors.yellowAccent[700],);

Decoration innerbox = BoxDecoration(borderRadius: BorderRadius.circular(20.0),color: Colors.blue);

List<Widget> tabs= [Text('Add Allowance'),Text('Show History')];

List<Widget> employeetabs = [Text('Attendance'),Text('Payments'),Text('Shifts')];

List<Widget> approvaltabs = [Text('Picture'),Text('Leave request')];

TextStyle salarybox = TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 8.sp);

TextStyle salarycal = TextStyle(color: Colors.black, fontSize: 5.sp);