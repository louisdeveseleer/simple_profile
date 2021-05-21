import 'dart:io';

import 'package:breakthrough_apps_challenge/services/firebase_storage_service.dart';
import 'package:breakthrough_apps_challenge/app/top_level_providers.dart';
import 'package:flutter/material.dart';
import 'package:image_editor/image_editor.dart' as editor;
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
    final decodedImage =
        await decodeImageFromList(originalImage.readAsBytesSync());
    final int width = decodedImage.width;
    final int height = decodedImage.height;

    editor.ImageEditorOption imageEditorOption = editor.ImageEditorOption();
    bool isPortrait = true;
    if (width > height) {
      isPortrait = false;
    }

    imageEditorOption.addOption(editor.ClipOption(
      x: isPortrait ? 0 : (width - height) / 2,
      y: isPortrait ? (height - width) / 2 : 0,
      width: isPortrait ? width : height,
      height: isPortrait ? width : height,
    ));

    imageEditorOption.addOption(editor.ScaleOption(67, 67));
    return await editor.ImageEditor.editFileImageAndGetFile(
      file: originalImage,
      imageEditorOption: imageEditorOption,
    );
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
