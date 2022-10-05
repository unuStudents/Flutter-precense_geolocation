import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddPegawaiController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool isLoadingAddPegawai = false.obs;
  TextEditingController nimC = TextEditingController();
  TextEditingController nameC = TextEditingController();
  TextEditingController jobC = TextEditingController();
  TextEditingController emailC = TextEditingController();
  TextEditingController passAdminC = TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> prosesAddPegawai() async {
    if (passAdminC.text.isNotEmpty) {
      isLoadingAddPegawai.value = true;

      try {
        String emailAdmin = auth.currentUser!.email!;

        UserCredential userCredentialAdmin =
            await auth.signInWithEmailAndPassword(
          email: emailAdmin,
          password: passAdminC.text,
        );
        UserCredential pegawaiCredential =
            await auth.createUserWithEmailAndPassword(
          email: emailC.text,
          password: "starlabs",
        );

        if (pegawaiCredential.user != null) {
          String uid = pegawaiCredential.user!.uid;

          firestore.collection("pegawai").doc(uid).set({
            "nip": nimC.text,
            "name": nameC.text,
            "job": jobC.text,
            "email": emailC.text,
            "uid": uid,
            "role": "Anggota",
            "createdAt": DateTime.now().toIso8601String()
          });

          await pegawaiCredential.user!.sendEmailVerification();

          await auth.signOut();

          UserCredential userCredentialAdmin =
              await auth.signInWithEmailAndPassword(
            email: emailAdmin,
            password: passAdminC.text,
          );

          Get.back(); //tutup dialog
          Get.back(); //back to home
          Get.snackbar("Berhasil", "Berhasil menambah pegawai");
        }
        isLoadingAddPegawai.value = false;
      } on FirebaseAuthException catch (e) {
        isLoadingAddPegawai.value = false;
        if (e.code == 'weak-password') {
          Get.snackbar("Terjadi Kesalahan !", "Password terlalu");
        } else if (e.code == 'email-already-in-use') {
          Get.snackbar("Terjadi Kesalahan !", "Email ini udah di gunakan");
        } else if (e.code == 'wrong-password') {
          Get.snackbar(
              "Terjadi Kesalahan !", "Admin tidak dapat login, password salah");
        } else {
          Get.snackbar("Terjadi Kesalahan !", "${e.code}");
        }
      } catch (e) {
        isLoadingAddPegawai.value = false;
        Get.snackbar("Terjadi Kesalahan !", "Tidak dapat menambahkan pegawai");
      }
    } else {
      isLoading.value = false;
      Get.snackbar("Terjadi kesalahan", "Password wajib di isi");
    }
  }

  Future<void> addPegawai() async {
    if (nimC.text.isNotEmpty &&
        nameC.text.isNotEmpty &&
        jobC.text.isNotEmpty &&
        emailC.text.isNotEmpty) {
      isLoading.value = true;
      Get.defaultDialog(
        title: "Validasi Admin",
        content: Column(
          children: [
            Text("Masukan password untuk validasi admin"),
            SizedBox(height: 10),
            TextField(
              controller: passAdminC,
              autocorrect: false,
              obscureText: true,
              decoration: InputDecoration(
                  labelText: "Password", border: OutlineInputBorder()),
            )
          ],
        ),
        actions: [
          OutlinedButton(
              onPressed: () {
                isLoading.value = false;
                Get.back();
              },
              child: Text("CANCEL")),
          Obx(
            () => ElevatedButton(
              onPressed: () async {
                if (isLoadingAddPegawai.isFalse) {
                  await prosesAddPegawai();
                }
                isLoading.value = false;
              },
              child: Text(
                  isLoadingAddPegawai.isFalse ? "ADD PEGAWAI" : "LOADING..."),
            ),
          ),
        ],
      );
    } else {
      Get.snackbar(
          "Terjadi Kesalahan !", "NIM, Nama, Job, atau Email harus sesuai !");
    }
  }
}
