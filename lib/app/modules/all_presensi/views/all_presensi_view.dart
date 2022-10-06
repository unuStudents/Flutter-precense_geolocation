import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:presensi/app/routes/app_pages.dart';

import '../controllers/all_presensi_controller.dart';

class AllPresensiView extends GetView<AllPresensiController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SEMUA PRESENSI'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: TextField(
              autocorrect: false,
              readOnly: false,
              // controller: controller.nameC,
              decoration: InputDecoration(
                labelText: "Search bar",
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: controller.streamAllPresence(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.data?.docs.length == 0 ||
                      snapshot.data == null) {
                    return SizedBox(
                      height: 100,
                      child: Center(
                        child: Text(
                            "Belum ada histori absen sejak 5 hari yang lalu"),
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: EdgeInsets.all(15),
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      Map<String, dynamic> data =
                          snapshot.data!.docs.reversed.toList()[index].data();
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Material(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.amber,
                          child: InkWell(
                            onTap: () => Get.toNamed(Routes.DETAIL_PRESENSI,
                                arguments: data),
                            borderRadius: BorderRadius.circular(10),
                            child: Container(
                              // margin: EdgeInsets.only(bottom: 15),
                              padding: EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                // color: Colors.amber,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Masuk",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        "${DateFormat.yMMMEd().format(DateTime.parse(data['date']))}",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    data['masuk']!['date'] == null
                                        ? "- - -"
                                        : "${DateFormat.jms().format(DateTime.parse(data['masuk']?['date']))}",
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Keluar",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      // Text(
                                      //   "${DateFormat.yMMMEd().format(DateTime.now())}",
                                      //   style: TextStyle(
                                      //       fontWeight: FontWeight.bold),
                                      // ),
                                    ],
                                  ),
                                  Text(
                                    data['keluar']?['date'] == null
                                        ? "- - -"
                                        : "${DateFormat.jms().format(DateTime.parse(data['keluar']?['date']))}",
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }),
          ),
        ],
      ),
    );
  }
}
