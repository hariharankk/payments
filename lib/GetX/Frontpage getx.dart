import 'package:get/get.dart';
import 'package:intl/intl.dart';


class MainController extends GetxController {

  var date = DateFormat("MMMM, yyyy").format(DateTime.now()).obs;

  void change(String dates)
  {
    date.value = dates;
    print('baadu the date is ${dates}');
  }



}