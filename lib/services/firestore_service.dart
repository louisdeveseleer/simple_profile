import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class FirestoreService {
  FirestoreService._();
  static final instance = FirestoreService._();

  String getDocId() {
    print('FirestoreService-- read random Id');

    final reference = FirebaseFirestore.instance.collection('test').doc();
    return reference.id;
  }

  Future<Map<String, dynamic>> getDocument({
    @required String path,
  }) async {
    print('FirestoreService-- read $path');
    try {
      final reference = FirebaseFirestore.instance.doc(path);
      return reference.get().then((value) => value.data());
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<void> setData({
    @required String path,
    @required Map<String, dynamic> data,
    bool merge = false,
  }) async {
    print('FirestoreService-- write $path');
    try {
      final reference = FirebaseFirestore.instance.doc(path);
      await reference.set(data, SetOptions(merge: merge));
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<void> deleteData({@required String path}) async {
    print('FirestoreService-- delete $path');
    final reference = FirebaseFirestore.instance.doc(path);
    await reference.delete();
  }
}
