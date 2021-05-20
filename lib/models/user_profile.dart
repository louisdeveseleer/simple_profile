import 'package:cloud_firestore/cloud_firestore.dart';

class UserProfile {
  String firstName;
  String lastName;
  DateTime birthDate;
  String profilePicUrl;

  UserProfile(
      {this.firstName, this.lastName, this.birthDate, this.profilePicUrl});

  static UserProfile fromMap(
    Map<String, dynamic> map,
  ) {
    if (map == null) {
      return null;
    }
    try {
      return UserProfile(
        firstName: map['firstName'],
        lastName: map['lastName'],
        birthDate: (map['birthDate'] as Timestamp)?.toDate(),
        profilePicUrl: map['profilePicUrl'],
      );
    } catch (e) {
      print(e);
      return null;
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'birthDate': birthDate,
      'profilePicUrl': profilePicUrl,
    };
  }
}
