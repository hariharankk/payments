import 'package:get/get.dart';



class feautreController extends GetxController {

  var date = "Select Date".obs;
  var paymenttext = "".obs;
  var notestext = "".obs;
  var rate = 0.0.obs;
  var quantity = 0.0.obs;

  void ratechange(double rates)
  {
    rate.value = rates;
  }

  void change(String dates)
  {
    date.value = dates;
  }

  void quantitychange(double quantitys)
  {
    quantity.value = quantitys;
  }


}