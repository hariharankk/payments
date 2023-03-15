import 'package:get/get.dart';



class allowanceController extends GetxController {

  var date = "Select Date".obs;
  var paymenttext = "".obs;
  var notestext = "".obs;

  void change(String dates)
  {
    date.value = dates;
  }


}