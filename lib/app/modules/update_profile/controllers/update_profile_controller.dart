import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class UpdateProfileController extends GetxController {
  RxBool isLoading = false.obs;

  TextEditingController nimC = TextEditingController();
  TextEditingController nameC = TextEditingController();
  TextEditingController jobC = TextEditingController();
  TextEditingController emailC = TextEditingController();

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  final ImagePicker _picker = ImagePicker();
  final storage = FirebaseStorage.instance;

  Future<void> updateProfile(String uid) async {
    if (nimC.text.isNotEmpty &&
        nameC.text.isNotEmpty &&
        jobC.text.isNotEmpty &&
        emailC.text.isNotEmpty) {
      isLoading.value = true;
      try {
        Map<String, dynamic> data = {
          "name": nameC.text,
          "job": jobC.text,
        };
        if (image != null) {
          File file = File(image!.path);
          String addPic = image!.name;
          // String ext = image!.name.split(".").last;

          await storage.ref('$uid/$addPic').putFile(file);
          String urlImage = await storage.ref('$uid/$addPic').getDownloadURL();
          // await storage.ref('$uid/profileImg.$ext').putFile(file);
          // String urlImage =
          //     await storage.ref('$uid/profileImg.$ext').getDownloadURL();

          data.addAll({"profileImg": urlImage});
        }
        await firestore.collection("pegawai").doc(uid).update(data);
        image = null;
        Get.snackbar("Berhasil", "Profil berhasil di update");
      } catch (e) {
        Get.snackbar("Terjadi Kesalahan", "Tidak dapat update profile");
      } finally {
        isLoading.value = false;
      }
    }
  }

  XFile? image;
  void pickImage() async {
    // Pick an image
    image = await _picker.pickImage(source: ImageSource.gallery);

    // Capture a photo
    // final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
    Get.snackbar("Berhasil", "Photo profil telah di tambah");
    update();
  }

  void deleteImage(String uid) async {
    try {
      await firestore.collection("pegawai").doc(uid).update(
        {"profileImg": FieldValue.delete()},
      );
      Get.snackbar("Berhasil", "Profil telah di hapus");
    } catch (e) {
      Get.snackbar("Terjadi Kesalahan", "Tidak dapat delete profile");
    } finally {
      update();
    }
  }
}
