import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddPegawaiController extends GetxController {
  TextEditingController nimC = TextEditingController();
  TextEditingController nameC = TextEditingController();
  TextEditingController emailC = TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  void addPegawai() async {
    if (nimC.text.isNotEmpty &&
        nameC.text.isNotEmpty &&
        emailC.text.isNotEmpty) {
      Get.defaultDialog(
          title: "Validasi Admin",
          content: Column(
            children: [
              Text("Masukan password untuk validasi admin"),
              TextField(
                autocorrect: false,
                obscureText: true,
                decoration: InputDecoration(
                    labelText: "Password", border: OutlineInputBorder()),
              )
            ],
          ),
          actions: [
            OutlinedButton(onPressed: () => Get.back(), child: Text("CANCEL")),
            ElevatedButton(onPressed: () {}, child: Text("ADD PEGAWAI")),
          ]);
      // try {
      //   UserCredential userCredential =
      //       await auth.createUserWithEmailAndPassword(
      //     email: emailC.text,
      //     password: "starlabs",
      //   );

      //   if (userCredential.user != null) {
      //     String uid = userCredential.user!.uid;

      //     firestore.collection("pegawai").doc(uid).set({
      //       "nip": nimC.text,
      //       "name": nameC.text,
      //       "email": emailC.text,
      //       "uid": uid,
      //       "createdAt": DateTime.now().toIso8601String()
      //     });

      //     await userCredential.user!.sendEmailVerification();

      //     await auth.signOut();

      //     // await auth.signInWithEmailAndPassword(email: c, password: password)
      //   }
      //   print(userCredential);
      // } on FirebaseAuthException catch (e) {
      //   if (e.code == 'weak-password') {
      //     Get.snackbar("Terjadi Kesalahan !", "Password terlalu");
      //   } else if (e.code == 'email-already-in-use') {
      //     Get.snackbar("Terjadi Kesalahan !", "Email ini udah di gunakan");
      //   }
      // } catch (e) {
      //   print(e);
      //   Get.snackbar("Terjadi Kesalahan !", "Tidak dapat menambahkan pegawai");
      // }
    } else {
      Get.snackbar(
          "Terjadi Kesalahan !", "NIM, Nama, atau Email harus sesuai !");
    }
  }
}
