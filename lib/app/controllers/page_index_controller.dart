import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:presensi/app/routes/app_pages.dart';

import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class PageIndexController extends GetxController {
  RxInt pageIndex = 1.obs;
  RxBool isSnackBar = false.obs;

  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  // FirebaseStorage firestore = FirebaseStorage.instance;

  void changePage(int i) async {
    // print('click index=$i');
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
        Map<String, dynamic> dataResponse = await _determinePosition();
        if (dataResponse["error"] != true) {
          isSnackBar.value = false;
          Position position = dataResponse["Position"];

          List<Placemark> placemarks = await placemarkFromCoordinates(
              position.latitude, position.longitude);

          String address =
              "${placemarks[0].street}, ${placemarks[0].subLocality}, ${placemarks[0].locality}";

          await updatePosition(position, address);

          // CEK JANGKAUAN
          // Geolocator.distanceBetween(startLatitude, startLongitude, endLatitude, endLongitude)
          double jarak = Geolocator.distanceBetween(
              -7.6252321, 109.1134052, position.latitude, position.longitude);

          // PRESENSI
          await presensi(position, address, jarak);

          // if (isSnackBar.isFalse) {
          //   Get.snackbar("Sukses", "Kamu telah mengisi daftar hadir");
          // }
        } else {
          Get.snackbar("Terjadi Kesalahan", dataResponse["Msg"]);
        }
    }
  }

  Future<void> presensi(Position position, String address, double jarak) async {
    String uid = await auth.currentUser!.uid;

    CollectionReference<Map<String, dynamic>> colPresen =
        await firestore.collection("pegawai").doc(uid).collection("presence");

    QuerySnapshot<Map<String, dynamic>> snapPresen = await colPresen.get();

    DateTime now = DateTime.now();
    String todayDocID = DateFormat.yMd().format(now).replaceAll("/", "-");
    String statusArea = "Luar Area";

    if (jarak <= 200) {
      statusArea = "Dalam Area";
    }

    if (snapPresen.docs.length == 0) {
      await Get.defaultDialog(
        title: "Apakah kamu yakin ?",
        middleText:
            "Apakah kamu yakin akan mengisi daftar hadir (MASUK) sekarang ?",
        actions: [
          OutlinedButton(
            onPressed: () => Get.back(),
            child: Text("CANCEL"),
          ),
          ElevatedButton(
            onPressed: () async {
              // Ketika belum pernah absen
              await colPresen.doc(todayDocID).set({
                "date": now.toIso8601String(),
                "masuk": {
                  "date": now.toIso8601String(),
                  "lat": position.latitude,
                  "long": position.longitude,
                  "address": address,
                  "status": statusArea,
                  "jarak": jarak,
                }
              });
              Get.back();
              Get.snackbar("Sukses",
                  "Kamu telah mengisi daftar Masuk untuk pertama kali");
            },
            child: Text("YES"),
          )
        ],
      );
    } else {
      // Ketika ssudah pernah absen --> cek hari ini udah absen belum?
      DocumentSnapshot<Map<String, dynamic>> todayDocument =
          await colPresen.doc(todayDocID).get();

      if (todayDocument.exists == true) {
        // Tinggal absen keluar / sudah 2 2 nya
        Map<String, dynamic>? dataPresenToday = todayDocument.data();
        if (dataPresenToday?["keluar"] != null) {
          // Sudah absen
          // isSnackBar.value = true;
          Get.snackbar("Sudah woi !", "Lu udah absen weh, besok lagi");
        } else {
          await Get.defaultDialog(
            title: "Apakah kamu yakin ?",
            middleText:
                "Apakah kamu yakin akan mengisi daftar hadir (KELUAR) sekarang ?",
            actions: [
              OutlinedButton(
                  onPressed: () => Get.back(), child: Text("CANCEL")),
              ElevatedButton(
                onPressed: () async {
                  // Belum
                  await colPresen.doc(todayDocID).update({
                    "keluar": {
                      "date": now.toIso8601String(),
                      "lat": position.latitude,
                      "long": position.longitude,
                      "address": address,
                      "status": statusArea,
                      "jarak": jarak,
                    }
                  });
                  Get.back();
                  Get.snackbar("Sukses", "Kamu telah mengisi daftar Keluar");
                },
                child: Text("YES"),
              )
            ],
          );
        }
      } else {
        await Get.defaultDialog(
          title: "Apakah kamu yakin ?",
          middleText:
              "Apakah kamu yakin akan mengisi daftar hadir (MASUK) sekarang ?",
          actions: [
            OutlinedButton(onPressed: () => Get.back(), child: Text("CANCEL")),
            ElevatedButton(
              onPressed: () async {
                // Ketika belum pernah absen
                await colPresen.doc(todayDocID).set({
                  "date": now.toIso8601String(),
                  "masuk": {
                    "date": now.toIso8601String(),
                    "lat": position.latitude,
                    "long": position.longitude,
                    "address": address,
                    "status": statusArea,
                    "jarak": jarak,
                  }
                });
                Get.back();
                Get.snackbar(
                    "Sukses", "Kamu telah mengisi daftar Masuk hari ini");
              },
              child: Text("YES"),
            )
          ],
        );
        // Absen masuk

      }
    }
  }

  Future<void> updatePosition(Position position, String address) async {
    String uid = await auth.currentUser!.uid;

    await firestore.collection("pegawai").doc(uid).update({
      "position": {"lat": position.latitude, "long": position.longitude},
      "address": address
    });
  }

  /// Determine the current position of the device.
  ///
  /// When the location services are not enabled or permissions
  /// are denied the `Future` will return an error.
  // Future<Position> _determinePosition() async {
  Future<Map<String, dynamic>> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      // return Future.error('Location services are disabled.');
      return {
        "Msg": "Hidupkan Lokasi",
        "error": true,
      };
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        // return Future.error('Location permissions are denied');
        return {
          "Msg": "Ijin GPS di tolak",
          "error": true,
        };
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return {
        "Msg": "Aktifkan lokasi !",
        "error": true,
      };
      // return Future.error(
      //     'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    return {
      "Position": position,
      "Msg": "Sukses dapatkan posisi",
      "error": false,
    };
  }
}
