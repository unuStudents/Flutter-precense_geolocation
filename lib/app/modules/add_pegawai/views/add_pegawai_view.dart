import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/add_pegawai_controller.dart';

class AddPegawaiView extends GetView<AddPegawaiController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('ADD PEGAWAI'),
          centerTitle: true,
        ),
        body: ListView(
          padding: EdgeInsets.all(20),
          children: [
            TextField(
              autocorrect: false,
              controller: controller.nimC,
              decoration: InputDecoration(
                labelText: "NIM",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              autocorrect: false,
              controller: controller.nameC,
              decoration: InputDecoration(
                labelText: "Nama",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              autocorrect: false,
              controller: controller.emailC,
              decoration: InputDecoration(
                labelText: "Email",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 30),
            ElevatedButton(
                onPressed: () {
                  controller.addPegawai();
                },
                child: Text("ADD PEGAWAI"))
          ],
        ));
  }
}
