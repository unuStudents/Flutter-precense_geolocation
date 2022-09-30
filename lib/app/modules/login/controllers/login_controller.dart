import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:presensi/app/routes/app_pages.dart';

class LoginController extends GetxController {
  TextEditingController emailC = TextEditingController();
  TextEditingController passC = TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;

  void login() async {
    if (emailC.text.isNotEmpty && passC.text.isNotEmpty) {
      try {
        UserCredential userCredential = await auth.signInWithEmailAndPassword(
            email: emailC.text, password: passC.text);

        if (userCredential.user != null) {
          if (userCredential.user!.emailVerified == true) {
            if (passC.text == "starlabs") {
              Get.offAllNamed(Routes.NEW_PASSWORD);
            } else {
              Get.offAllNamed(Routes.HOME);
            }
          } else {
            Get.defaultDialog(
                title: "Belum Terverifikasi",
                middleText: "Kmau belum verifikasi",
                actions: [
                  OutlinedButton(
                    onPressed: () => Get.back(),
                    child: Text("CANCEL"),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      try {
                        await userCredential.user!.sendEmailVerification();
                        Get.back();
                        Get.snackbar("Berhasil", "email telah di kirim, cek !");
                      } catch (e) {
                        Get.snackbar("Terjadi Kesalahan",
                            "Tidak dapat mengirim email verifikasi");
                      }
                    },
                    child: Text("KIRIM ULANG"),
                  ),
                ]);
          }
        }
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          print('No user found for that email.');
          Get.snackbar("Terjadi Kesalahan", "Email tidak terdaftar!");
        } else if (e.code == 'wrong-password') {
          print('Wrong password provided for that user.');
          Get.snackbar("Terjadi Kesalahan", "Password salah!");
        }
      } catch (e) {
        Get.snackbar("Terjadi Kesalahan", "Tidak dapat Login!");
      }
    } else {
      Get.snackbar("Terjadi Kesalahan", "Email dan Password wajib di isi!");
    }
  }
}
