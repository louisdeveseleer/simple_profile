import 'package:breakthrough_apps_challenge/app/profile/avatar_picker.dart';
import 'package:breakthrough_apps_challenge/app/profile/birthdate_picker.dart';
import 'package:breakthrough_apps_challenge/app/profile/my_text_field.dart';
import 'package:breakthrough_apps_challenge/app/profile/profile_section.dart';
import 'package:breakthrough_apps_challenge/models/user_profile.dart';
import 'package:breakthrough_apps_challenge/services/database_CRUD.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key key, @required this.uid}) : super(key: key);
  final String uid;

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _isInEditMode = false;
  UserProfile _userProfile;
  DatabaseCRUD _databaseCRUD;
  final TextStyle sectionStyle = TextStyle(color: Colors.grey[500]);

  void _toggleMode() {
    _isInEditMode = !_isInEditMode;
    if (!_isInEditMode) {
      _databaseCRUD.updateUserProfile(_userProfile);
    }
    setState(() {});
  }

  void _onChangedFirstName(String newValue) {
    _userProfile.firstName = newValue;
  }

  void _onChangedLastName(String newValue) {
    _userProfile.lastName = newValue;
  }

  void _onChangedBirthdate(DateTime newValue) {
    _userProfile.birthDate = newValue;
  }

  void _onChangedAvatarUrl(String newValue) {
    _userProfile.profilePicUrl = newValue;
  }

  @override
  void initState() {
    _databaseCRUD = DatabaseCRUD(uid: widget.uid);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.person),
        title: Text('Profile'),
      ),
      body: FutureBuilder(
        future: _databaseCRUD.getUserProfile(),
        builder: (context, AsyncSnapshot<UserProfile> snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            _userProfile = snapshot.data ?? UserProfile();
            return Stack(
              children: [
                SingleChildScrollView(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ProfileSection(
                        title: 'First name',
                        child: MyTextField(
                          enabled: _isInEditMode,
                          initialValue: _userProfile?.firstName,
                          onChanged: _onChangedFirstName,
                          hintText: 'First name',
                        ),
                      ),
                      SizedBox(
                        height: 24,
                      ),
                      ProfileSection(
                        title: 'Last name',
                        child: MyTextField(
                          enabled: _isInEditMode,
                          initialValue: _userProfile?.lastName,
                          onChanged: _onChangedLastName,
                          hintText: 'Last name',
                        ),
                      ),
                      SizedBox(
                        height: 24,
                      ),
                      ProfileSection(
                        title: 'Birth date',
                        child: BirthdatePicker(
                          enabled: _isInEditMode,
                          initialValue: _userProfile.birthDate,
                          onChanged: _onChangedBirthdate,
                        ),
                      ),
                      SizedBox(
                        height: 24,
                      ),
                      ProfileSection(
                        title: 'Avatar',
                        child: AvatarPicker(
                          enabled: _isInEditMode,
                          initialUrl: _userProfile.profilePicUrl,
                          onChanged: _onChangedAvatarUrl,
                          userId: _databaseCRUD.uid,
                        ),
                      ),
                      SizedBox(
                        height: 50,
                      ),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _toggleMode,
                        icon: Icon(_isInEditMode ? Icons.check : Icons.edit),
                        label: Text(_isInEditMode ? 'SAVE' : 'EDIT'),
                      ),
                    ),
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
