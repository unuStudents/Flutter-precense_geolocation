import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class UpdatePasswordController extends GetxController {
  RxBool isLoading = false.obs;

  TextEditingController sekarangC = TextEditingController();
  TextEditingController baruC = TextEditingController();
  TextEditingController konfirmC = TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;

  void updatePass() async {
    if (sekarangC.text.isNotEmpty &&
        baruC.text.isNotEmpty &&
        konfirmC.text.isNotEmpty) {
      if (baruC.text == konfirmC.text) {
        isLoading.value = true;
        try {
          String emailUser = auth.currentUser!.email!;

          await auth.signInWithEmailAndPassword(
              email: emailUser, password: sekarangC.text);

          await auth.currentUser!.updatePassword(baruC.text);

          Get.back();

          Get.snackbar("Berhasil", "Berhasil Update Password");
        } on FirebaseException catch (e) {
          if (e.code == "wrong-password") {
            Get.snackbar("Terjadi Kesalahan", "Password sekarang salah");
          } else {
            Get.snackbar("Terjadi Kesalahan", "${e.code.toLowerCase()}");
          }
        } catch (e) {
          Get.snackbar("Terjadi Kesalahan", "Tidak dapat update password");
        } finally {
          isLoading.value = false;
        }
      } else {
        Get.snackbar("Terjadi Kesalahan", "Konfirm password tidak cocok");
      }
    } else {
      Get.snackbar("Terjadi Kesalahan", "Harus di isi semua!");
    }
  }
}
