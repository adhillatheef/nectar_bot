import 'package:get/get.dart';
import '../../../routes/app_routes.dart'; // Ensure you have this file

class SplashController extends GetxController {

  void onAnimationComplete() {
    Get.offAllNamed(Routes.TICKET_LIST);
  }
}