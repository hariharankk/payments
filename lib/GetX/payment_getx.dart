import 'package:get/get.dart';



class PaymentController extends GetxController {

  var empidValue = ''.obs;
  var empnameValue = ''.obs;

  void empidValuechange(String rates)
  {
    empidValue.value = rates;
  }


  void empnameValuechange(String quantitys)
  {
    empnameValue.value = quantitys;
  }


}