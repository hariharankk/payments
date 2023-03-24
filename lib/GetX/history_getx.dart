import 'package:get/get.dart';
import 'package:intl/intl.dart';


class HistoryController extends GetxController {

  var date = DateFormat("MMMM, yyyy").format(DateTime.now()).obs;

  void change(String dates)
  {
    date.value = dates;
    print(dates);
  }


}