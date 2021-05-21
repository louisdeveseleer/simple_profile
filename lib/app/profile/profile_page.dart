import 'package:breakthrough_apps_challenge/app/profile/profile_page_content.dart';
import 'package:breakthrough_apps_challenge/app/top_level_providers.dart';
import 'package:breakthrough_apps_challenge/models/user_profile.dart';
import 'package:breakthrough_apps_challenge/services/database_CRUD.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({Key key}) : super(key: key);

  void _updateUserProfile(DatabaseCRUD databaseCRUD, UserProfile userProfile) {
    databaseCRUD.updateUserProfile(userProfile);
  }

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    DatabaseCRUD databaseCRUD = watch(databaseProvider);
    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.person),
        title: Text('Profile'),
      ),
      body: databaseCRUD == null
          ? loadingWidget
          : FutureBuilder(
              future: databaseCRUD.getUserProfile(),
              builder: (context, AsyncSnapshot<UserProfile> snapshot) {
                if (snapshot.connectionState != ConnectionState.done) {
                  return loadingWidget();
                } else {
                  UserProfile userProfile = snapshot.data ?? UserProfile();
                  return ProfilePageContent(
                    uid: databaseCRUD.uid,
                    initialProfile: userProfile,
                    updateUserProfile: (newValue) =>
                        _updateUserProfile(databaseCRUD, newValue),
                  );
                }
              },
            ),
    );
  }

  Widget loadingWidget() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }
}
