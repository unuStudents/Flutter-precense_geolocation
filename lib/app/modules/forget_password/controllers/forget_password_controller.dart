import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class ForgetPasswordController extends GetxController {
  RxBool isLoading = false.obs;
  TextEditingController emailC = TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;

  Future<void> sendEmail() async {
    if (emailC.text.isNotEmpty) {
      isLoading.value = true;
      try {
        await auth.sendPasswordResetEmail(email: emailC.text);
        Get.snackbar("Berhasil",
            "kami telah mengirim link reset password ke email Anda");
        Get.back();
      } catch (e) {
        Get.snackbar("Terjadi Kesalahan", "Tidak dapat mengirim email reset");
      } finally {
        isLoading.value = false;
      }
    } else {
      Get.snackbar("Perhatian", "Email harus di isi");
    }
  }
}
