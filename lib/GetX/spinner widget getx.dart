import 'package:get/get.dart';



class spinnerController extends GetxController {

  var currentIntValue1 = 0.obs;
  var currentIntValue2 = 0.obs;

  void currentIntValue1change(int rates)
  {
    currentIntValue1.value = rates;
  }


  void currentIntValue2change(int quantitys)
  {
    currentIntValue2.value = quantitys;
  }


}