import 'package:get/get.dart';



class WeekController extends GetxController {

  var datestart = 'select date'.obs;
  var datesend = 'select date'.obs;


  void datestartchange(String dates)
  {
    datestart.value = dates;
    print(dates);
  }

  void datesendchange(String dates)
  {
    datesend.value = dates;
    print(dates);
  }


}