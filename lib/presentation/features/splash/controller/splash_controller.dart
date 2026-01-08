import 'package:get/get.dart';
import '../../../routes/app_routes.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    _startSplashSequence();
  }

  void _startSplashSequence() async {
    await Future.delayed(const Duration(seconds: 3));
    Get.offAllNamed(Routes.TICKET_LIST);
  }
}