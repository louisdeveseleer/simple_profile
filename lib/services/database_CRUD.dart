import 'package:breakthrough_apps_challenge/models/user_profile.dart';
import 'package:breakthrough_apps_challenge/services/firestore_service.dart';
import 'package:flutter/foundation.dart';

class DatabaseCRUD {
  DatabaseCRUD({@required this.uid})
      : assert(uid != null, 'Cannot create FirestoreDatabase with null uid');
  final String uid;

  final _service = FirestoreService.instance;

  final String userCollection = 'users';

  Future<UserProfile> getUserProfile() async {
    try {
      Map<String, dynamic> doc =
          await _service.getDocument(path: '$userCollection/$uid');
      return UserProfile.fromMap(doc);
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<void> updateUserProfile(UserProfile userProfile) async {
    var data = userProfile.toMap();
    data.removeWhere((key, value) => value == null);
    return await _service.setData(
      path: '$userCollection/$uid',
      data: userProfile.toMap(),
      merge: true,
    );
  }
}
