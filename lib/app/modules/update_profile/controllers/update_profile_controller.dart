import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import 'package:image_picker/image_picker.dart';

class UpdateProfileController extends GetxController {
  RxBool isLoading = false.obs;

  TextEditingController nimC = TextEditingController();
  TextEditingController nameC = TextEditingController();
  TextEditingController emailC = TextEditingController();

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  final ImagePicker _picker = ImagePicker();

  Future<void> updateProfile(String uid) async {
    if (nimC.text.isNotEmpty &&
        nameC.text.isNotEmpty &&
        emailC.text.isNotEmpty) {
      isLoading.value = true;
      try {
        await firestore
            .collection("pegawai")
            .doc(uid)
            .update({"name": nameC.text});
        Get.snackbar("Berhasil", "Nama berhasil di update");
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
    update();
  }
}
