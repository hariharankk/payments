import 'package:get/get.dart';



class BalanceController extends GetxController {

  var data =0.obs;

  void change(int datas)
  {
    data.value = datas;
  }



}