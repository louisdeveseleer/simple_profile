import 'dart:io';
import 'package:breakthrough_apps_challenge/services/firebase_storage_service.dart';
import 'package:breakthrough_apps_challenge/app/top_level_providers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_crop/image_crop.dart';
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

  Future<File> cropAndScale(File originalImage) async {
    final cropKey = GlobalKey<CropState>();
    File modifiedImage;
    await showCupertinoModalPopup(
      context: context,
      builder: (context) => CupertinoPopupSurface(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(16),
              height: 300,
              child: Crop.file(
                originalImage,
                key: cropKey,
                aspectRatio: 1.0,
              ),
            ),
            ElevatedButton.icon(
              onPressed: () => Navigator.pop(context),
              icon: Icon(Icons.check),
              label: Text('Validate'),
            ),
          ],
        ),
      ),
    ).whenComplete(() async {
      final scale = cropKey.currentState.scale;
      final area = cropKey.currentState.area;
      if (area == null) {
        return;
      }
      var decodedImage =
          await decodeImageFromList(originalImage.readAsBytesSync());
      int width = decodedImage.width;
      modifiedImage = await ImageCrop.cropImage(
        file: originalImage,
        area: area,
        scale: 67 / (width * scale),
      );
    });
    return modifiedImage;
  }

  void onTap() async {
    final pickedFile = await picker.ImagePicker().getImage(
      source: picker.ImageSource.gallery,
    );
    if (pickedFile != null) {
      setState(() {
        loading = true;
      });
      final File pickedImage = File(pickedFile.path);
      final File modifiedImage = await cropAndScale(pickedImage);
      url = await firebaseStorageService.uploadUserProfilePicture(
        image: modifiedImage,
        userId: widget.userId,
      );
      widget.onChanged(url);
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
