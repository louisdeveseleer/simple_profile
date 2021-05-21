import 'package:breakthrough_apps_challenge/app/profile/avatar_picker.dart';
import 'package:breakthrough_apps_challenge/app/profile/birthdate_picker.dart';
import 'package:breakthrough_apps_challenge/app/profile/my_text_field.dart';
import 'package:breakthrough_apps_challenge/app/profile/profile_section.dart';
import 'package:breakthrough_apps_challenge/models/user_profile.dart';
import 'package:flutter/material.dart';

class ProfilePageContent extends StatefulWidget {
  const ProfilePageContent({
    Key key,
    @required this.uid,
    @required this.updateUserProfile,
    @required this.initialProfile,
  }) : super(key: key);
  final String uid;
  final Function(UserProfile) updateUserProfile;
  final UserProfile initialProfile;

  @override
  _ProfilePageContentState createState() => _ProfilePageContentState();
}

class _ProfilePageContentState extends State<ProfilePageContent> {
  bool isInEditMode = false;
  UserProfile userProfile;
  final TextStyle sectionStyle = TextStyle(color: Colors.grey[500]);

  void toggleMode() {
    isInEditMode = !isInEditMode;
    if (!isInEditMode) {
      widget.updateUserProfile(userProfile);
    }
    setState(() {});
  }

  void onChangedFirstName(String newValue) {
    userProfile.firstName = newValue;
  }

  void onChangedLastName(String newValue) {
    userProfile.lastName = newValue;
  }

  void onChangedBirthdate(DateTime newValue) {
    userProfile.birthDate = newValue;
  }

  void onChangedAvatarUrl(String newValue) {
    userProfile.profilePicUrl = newValue;
  }

  @override
  void initState() {
    userProfile = widget.initialProfile;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: [
          SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ProfileSection(
                  title: 'First name',
                  child: MyTextField(
                    enabled: isInEditMode,
                    initialValue: userProfile.firstName,
                    onChanged: onChangedFirstName,
                    hintText: 'First name',
                  ),
                ),
                SizedBox(
                  height: 24,
                ),
                ProfileSection(
                  title: 'Last name',
                  child: MyTextField(
                    enabled: isInEditMode,
                    initialValue: userProfile.lastName,
                    onChanged: onChangedLastName,
                    hintText: 'Last name',
                  ),
                ),
                SizedBox(
                  height: 24,
                ),
                ProfileSection(
                  title: 'Birth date',
                  child: BirthdatePicker(
                    enabled: isInEditMode,
                    initialValue: userProfile.birthDate,
                    onChanged: onChangedBirthdate,
                  ),
                ),
                SizedBox(
                  height: 24,
                ),
                ProfileSection(
                  title: 'Avatar',
                  child: AvatarPicker(
                    enabled: isInEditMode,
                    initialUrl: userProfile.profilePicUrl,
                    onChanged: onChangedAvatarUrl,
                    userId: widget.uid,
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
                  onPressed: toggleMode,
                  icon: Icon(isInEditMode ? Icons.check : Icons.edit),
                  label: Text(isInEditMode ? 'SAVE' : 'EDIT'),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
