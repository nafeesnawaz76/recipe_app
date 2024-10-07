import 'package:get/get.dart';

class SpinkitLoading extends GetxController {
  var isLoading = false.obs; // Observable boolean

  // Function to toggle the loading state
  void toggleLoading() {
    isLoading.toggle();
  }
}
