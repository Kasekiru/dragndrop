import 'dart:convert';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fab_circular_menu/fab_circular_menu.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/event_model.dart';

class MyHome extends StatefulWidget {
  const MyHome({Key? key}) : super(key: key);

  @override
  State<MyHome> createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {
  List<EventModel> details = [];
  @override
  void initState() {
    readData();
    super.initState();
  }

  Future readData() async {
    await Firebase.initializeApp();
    FirebaseFirestore db = await FirebaseFirestore.instance;
    var data = await db.collection('event_detail').get();
    setState(() {
      details = data.docs.map((e) => EventModel.fromDocSnapshot(e)).toList();
    });
  }

  addRand() async {
    FirebaseFirestore db = await FirebaseFirestore.instance;
    EventModel insertData = EventModel(
        judul: getRandString(5),
        keterangan: getRandString(30),
        tanggal: getRandString(10),
        is_like: Random().nextBool(),
        pembicara: getRandString(20));
    await db.collection('event_detail').add(insertData.toMap());
    setState(() {
      details.add(insertData);
    });
  }

  String getRandString(int len) {
    var random = Random.secure();
    var values = List<int>.generate(len, (index) => random.nextInt(255));
    return base64UrlEncode(values);
  }

  deleteLast(String documentId) async {
    FirebaseFirestore db = await FirebaseFirestore.instance;
    await db.collection('event_detail').doc(documentId).delete();
    setState(() {
      details.removeLast();
    });
  }

  updateEvent(int pos) async {
    FirebaseFirestore db = await FirebaseFirestore.instance;
    await db
        .collection("event_detail")
        .doc(details[pos].id)
        .update({"is_like": !details[pos].is_like});
    setState(() {
      details[pos].is_like = !details[pos].is_like;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cloud Firestore"),
      ),
      body: ListView.builder(
          itemCount: details.length,
          itemBuilder: (context, position) {
            return GestureDetector(
              onTap: () {
                updateEvent(position);
              },
              child: CheckboxListTile(
                // isThreeLine: false,
                title: Text(
                    "${details[position].keterangan}\nHari : ${details[position].tanggal}\nPembicara : ${details[position].pembicara}"),
                value: details[position].is_like,
                onChanged: (bool? value) {},
              ),
            );
          }),
      floatingActionButton: FabCircularMenu(children: [
        IconButton(
          onPressed: () {
            addRand();
          },
          icon: const Icon(Icons.add),
        ),
        IconButton(
          onPressed: () {
            if (details.last.id != null) {
              deleteLast(details.last.id!);
            }
          },
          icon: const Icon(Icons.minimize),
        ),
      ]),
    );
  }
}
