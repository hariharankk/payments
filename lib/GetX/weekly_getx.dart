import 'package:get/get.dart';



class WeekController extends GetxController {

  var datestart = 'Select Date'.obs;
  var datesend = 'Select Date'.obs;


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