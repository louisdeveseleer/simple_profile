import 'dart:io';
import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';

class FirebaseStorageService {
  FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  Future<String> getDownloadUrl({
    @required String path,
  }) async {
    String downloadUrl;
    try {
      downloadUrl = await _firebaseStorage.ref(path).getDownloadURL();
    } catch (e) {
      print(e);
    }
    return downloadUrl;
  }

  Future<String> uploadUserProfilePicture({
    @required Uint8List image,
    @required userId,
  }) async {
    if (image == null) {
      return null;
    }
    String path = 'users/$userId/profilePic';
    Reference reference = _firebaseStorage.ref(path);
    UploadTask uploadTask;
    try {
      uploadTask = reference.putData(image);
    } catch (e) {
      print(e);
    }
    String fileUrl;
    await uploadTask.whenComplete(() async {
      await getDownloadUrl(path: path).then((value) => fileUrl = value);
    });
    return fileUrl;
  }
}
