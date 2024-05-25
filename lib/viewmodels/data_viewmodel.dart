import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DataViewModel with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<QuerySnapshot<Map<String, dynamic>>> get dataStream {
    return _firestore.collection('data').snapshots();
  }

  Future<void> addData(String value) async {
    await _firestore.collection('data').add({'value': value});
    notifyListeners();
  }

  Future<void> updateData(String id, String newValue) async {
    await _firestore.collection('data').doc(id).update({'value': newValue});
    notifyListeners();
  }

  Future<void> deleteData(String id) async {
    await _firestore.collection('data').doc(id).delete();
    notifyListeners();
  }
}
