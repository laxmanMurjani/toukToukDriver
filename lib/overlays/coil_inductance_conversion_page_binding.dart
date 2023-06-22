import 'package:get/get.dart';
import 'package:mozlit_driver/controller/home_controller.dart';


class CoilInductanceConversionPageBinding extends Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies

    Get.lazyPut<HomeController>(() => HomeController());
  }

}