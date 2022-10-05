import 'package:get/get.dart';
import 'package:presensi/app/routes/app_pages.dart';

class PageIndexController extends GetxController {
  RxInt pageIndex = 1.obs;

  void changePage(int i) async {
    print('click index=$i');
    // pageIndex.value = i;
    switch (i) {
      case 0:
        pageIndex.value = i;
        Get.offAllNamed(Routes.HOME);
        break;
      case 2:
        pageIndex.value = i;
        Get.offAllNamed(Routes.PROFILE);
        break;
      default:
        Get.snackbar("Uji Coba SnackBar", "Ada di pae_index_controlloer");
    }
  }
}
