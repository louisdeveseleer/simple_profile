import 'dart:io';
import 'dart:typed_data';
import 'package:breakthrough_apps_challenge/app/widgets/crop_and_scale_sheet.dart';
import 'package:breakthrough_apps_challenge/services/firebase_storage_service.dart';
import 'package:breakthrough_apps_challenge/app/top_level_providers.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart' as picker;
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AvatarPicker extends StatefulWidget {
  AvatarPicker({
    @required this.initialUrl,
    @required this.onChanged,
    @required this.enabled,
    @required this.userId,
  });
  final String initialUrl;
  final Function(String) onChanged;
  final bool enabled;
  final String userId;

  @override
  _AvatarPickerState createState() => _AvatarPickerState();
}

class _AvatarPickerState extends State<AvatarPicker> {
  FirebaseStorageService firebaseStorageService;
  String url;
  bool loading = false;

  void onTap() async {
    final pickedFile = await picker.ImagePicker().getImage(
      source: picker.ImageSource.gallery,
    );
    if (pickedFile != null) {
      setState(() {
        loading = true;
      });
      final File pickedImage = File(pickedFile.path);
      final Uint8List modifiedImage = await showCupertinoModalPopup(
          context: context,
          builder: (context) => CropAndScaleSheet(originalImage: pickedImage));
      if (modifiedImage != null) {
        url = await firebaseStorageService.uploadUserProfilePicture(
          image: modifiedImage,
          userId: widget.userId,
        );
        widget.onChanged(url);
      }
      setState(() {
        loading = false;
      });
    }
  }

  @override
  void initState() {
    url = widget.initialUrl;
    firebaseStorageService = context.read(storageServiceProvider);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.enabled ? onTap : null,
      child: CircleAvatar(
        radius: 30,
        child: loading
            ? CircularProgressIndicator()
            : url == null
                ? Icon(Icons.add)
                : null,
        foregroundImage: (loading || url == null) ? null : NetworkImage(url),
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      ),
    );
  }
}
