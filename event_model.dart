import 'package:cloud_firestore/cloud_firestore.dart';

class EventModel {
  EventModel({
    this.id,
    required this.judul,
    required this.keterangan,
    required this.tanggal,
    required this.is_like,
    required this.pembicara,
  });

  String? id;
  String judul;
  String keterangan;
  String tanggal;
  bool is_like;
  String pembicara;

  Map<String, dynamic> toMap() {
    return {
      'judul': judul,
      'keterangan': keterangan,
      'is_like': is_like,
      'pembicara': pembicara,
      'tanggal': tanggal
    };
  }

  EventModel.fromDocSnapshot(DocumentSnapshot<Map<String, dynamic>> doc)
      : id = doc.id,
        judul = doc.data()?['judul'],
        keterangan = doc.data()?['keterangan'],
        pembicara = doc.data()?['pembicara'],
        is_like = doc.data()?['is_like'],
        tanggal = doc.data()?['tanggal'];
}
