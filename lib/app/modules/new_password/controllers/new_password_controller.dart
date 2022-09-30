import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:presensi/app/routes/app_pages.dart';

class NewPasswordController extends GetxController {
  FirebaseAuth auth = FirebaseAuth.instance;

  TextEditingController newPass = TextEditingController();

  void newPassword() async {
    if (newPass.text.isNotEmpty) {
      if (newPass.text != "starlabs") {
        try {
          String email = auth.currentUser!.email!;

          await auth.currentUser!.updatePassword(newPass.text);

          await auth.signOut();

          auth.signInWithEmailAndPassword(email: email, password: newPass.text);

          Get.offAllNamed(Routes.HOME);
        } on FirebaseAuthException catch (e) {
          if (e.code == 'weak-password') {
            Get.snackbar("Terjadi Kesalahan", "Password terlalu lemah");
          }
        } catch (e) {
          Get.snackbar("Terjadi Kesalahan",
              "Tidak dapat membuat password baru. Hubungi Admin");
        }
      } else {
        Get.snackbar("Terjadi Kesalahn", "Password harus ganti !");
      }
    } else {
      Get.snackbar("Terjadi Kesalahn", "Password Baru wajid di isi");
    }
  }
}
