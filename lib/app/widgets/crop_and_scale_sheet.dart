import 'dart:typed_data';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_editor/image_editor.dart';

class CropAndScaleSheet extends StatefulWidget {
  CropAndScaleSheet({
    Key key,
    @required this.originalImage,
  }) : super(key: key);
  final File originalImage;

  @override
  _CropAndScaleSheetState createState() => _CropAndScaleSheetState();
}

class _CropAndScaleSheetState extends State<CropAndScaleSheet> {
  final GlobalKey<ExtendedImageEditorState> editorKey =
      GlobalKey<ExtendedImageEditorState>();
  bool isCropping = false;

  Future<Uint8List> cropImageDataWithNativeLibrary(
      {@required ExtendedImageEditorState state}) async {
    print('native library start cropping');

    final Rect cropRect = state.getCropRect();
    final EditActionDetails action = state.editAction;
    final Uint8List img = state.rawImageData;
    final ImageEditorOption option = ImageEditorOption();

    if (action.needCrop) {
      option.addOption(ClipOption.fromRect(cropRect));
    }
    option.addOption(ScaleOption(67, 67));

    final Uint8List result = await ImageEditor.editImage(
      image: img,
      imageEditorOption: option,
    );

    return result;
  }

  void _onValidate(BuildContext context) async {
    setState(() {
      isCropping = true;
    });
    final Uint8List modifiedImage = Uint8List.fromList(
        await cropImageDataWithNativeLibrary(state: editorKey.currentState));
    setState(() {
      isCropping = false;
    });
    Navigator.of(context).pop(modifiedImage);
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPopupSurface(
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(16),
              height: 300,
              width: double.infinity,
              child: ExtendedImage.file(
                widget.originalImage,
                extendedImageEditorKey: editorKey,
                cacheRawData: true,
                fit: BoxFit.contain,
                enableLoadState: true,
                loadStateChanged: (ExtendedImageState state) {
                  if (state.extendedImageLoadState == LoadState.loading) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  return null;
                },
                mode: ExtendedImageMode.editor,
                initEditorConfigHandler: (_) {
                  return EditorConfig(
                    maxScale: 8.0,
                    cropRectPadding: const EdgeInsets.all(20.0),
                    hitTestSize: 20.0,
                    initCropRectType: InitCropRectType.imageRect,
                    cropAspectRatio: CropAspectRatios.ratio1_1,
                  );
                },
              ),
            ),
            isCropping
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CircularProgressIndicator(),
                  )
                : ElevatedButton.icon(
                    onPressed: () => _onValidate(context),
                    icon: Icon(Icons.check),
                    label: Text('Validate'),
                  ),
          ],
        ),
      ),
    );
  }
}
