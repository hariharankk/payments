import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:payment/widgets/Buttonheader.dart';
import 'package:payment/GetX/allowance_getx.dart';
import 'package:get/get.dart';


class DatePickerWidget extends StatelessWidget{
  final mycontroller = Get.find<allowanceController>();


  @override
  Widget build(BuildContext context) => ButtonHeaderWidget(
    title: 'Date of payment',
    onClicked: () => pickDate(context),
  );

  Future pickDate(BuildContext context) async {
    final initialDate = DateTime.now();
    final newDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(DateTime.now().year - 5),
      lastDate: DateTime(DateTime.now().year + 5),
    );

    if (newDate != null) {
      mycontroller.change( DateFormat('MM/dd/yyyy').format(newDate));
    }


  }
}