import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class AllPresensiController extends GetxController {
  DateTime? startD;
  DateTime endD = DateTime.now();
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<QuerySnapshot<Map<String, dynamic>>> getPresence() async {
    String uid = auth.currentUser!.uid;

    if (startD == null) {
      // GET SELURUH PRESENSI SAMPAI SAAT INI
      return await firestore
          .collection("pegawai")
          .doc(uid)
          .collection("presence")
          .where("date",
              isLessThan: endD.add(Duration(days: 1)).toIso8601String())
          .orderBy("date", descending: true)
          .get();
    } else {
      // GET  PRESENSI FILTER
      return await firestore
          .collection("pegawai")
          .doc(uid)
          .collection("presence")
          .where("date", isGreaterThan: startD!.toIso8601String())
          .where("date",
              isLessThan: endD.add(Duration(days: 1)).toIso8601String())
          .orderBy("date", descending: true)
          .get();
    }
  }

  void pickDate(DateTime pickStart, DateTime pickEnd) {
    startD = pickStart;
    endD = pickEnd;
    update();
    Get.back();
  }
}
