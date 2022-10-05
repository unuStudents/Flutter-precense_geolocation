// import 'package:firebase_auth/firebase_auth.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:presensi/app/controllers/page_index_controller.dart';
import 'package:presensi/app/routes/app_pages.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  final pageC = Get.find<PageIndexController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('HOME'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () => Get.toNamed(Routes.PROFILE),
            icon: Icon(Icons.person),
          )
        ],
      ),
      body: ListView(
        padding: EdgeInsets.all(20),
        children: [
          Row(
            children: [
              ClipOval(
                child: Container(
                  width: 75,
                  height: 75,
                  color: Colors.grey[200],
                  child: Center(child: Text("X")),
                  // child: Image.network(src),
                ),
              ),
              SizedBox(width: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Nanda",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Text("kalisabuk"),
                ],
              )
            ],
          ),
          SizedBox(height: 20),
          Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.amber,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Ketua",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                Text(
                  "1952011009",
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Text(
                  style: TextStyle(fontSize: 18),
                  "Nanda Khoirul Akmal",
                ),
              ],
            ),
          ),
          SizedBox(height: 10),
          Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.amber,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    Text("Masuk"),
                    Text("-"),
                  ],
                ),
                Container(
                  width: 2,
                  height: 40,
                  color: Colors.black,
                ),
                Column(
                  children: [
                    Text("Keluar"),
                    Text("-"),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          Divider(
            color: Colors.black,
            thickness: 2,
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Last 5 days",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              TextButton(
                onPressed: () {},
                child: Text("See More"),
              ),
            ],
          ),
          SizedBox(height: 10),
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: 5,
            itemBuilder: (context, index) {
              return Container(
                margin: EdgeInsets.only(bottom: 15),
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.amber,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Masuk",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "${DateFormat.yMMMEd().format(DateTime.now())}",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    Text(
                      "${DateFormat.jms().format(DateTime.now())}",
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Keluar",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "${DateFormat.yMMMEd().format(DateTime.now())}",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    Text(
                      "${DateFormat.jms().format(DateTime.now())}",
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      // floatingActionButton: Obx(
      //   () => FloatingActionButton(
      //     onPressed: () async {
      //       if (controller.isLoading.isFalse) {
      //         controller.isLoading.value = true;
      //         await FirebaseAuth.instance.signOut();
      //         controller.isLoading.value = false;
      //         Get.offAllNamed(Routes.LOGIN);
      //       }
      //     },
      //     child: controller.isLoading.isFalse
      //         ? Icon(Icons.logout)
      //         : CircularProgressIndicator(),
      //   ),
      // ),
      bottomNavigationBar: ConvexAppBar(
        items: [
          TabItem(icon: Icons.home, title: 'Home'),
          TabItem(icon: Icons.fingerprint, title: 'Absen'),
          TabItem(icon: Icons.people, title: 'Profile'),
        ],
        initialActiveIndex: pageC.pageIndex.value,
        onTap: (int i) => pageC.changePage(i),
      ),
    );
  }
}
