import 'dart:ui' as ui;
import 'dart:typed_data';
import 'package:flutter/material.dart';

Future<Uint8List> resizeImage(Uint8List imageData, int newWidth, int newHeight) async {
  final ui.Image image = await decodeImageFromList(imageData);

  final double aspectRatio = image.width / image.height;
  final double newAspectRatio = newWidth / newHeight;

  final ui.Rect srcRect = newAspectRatio > aspectRatio
      ? ui.Rect.fromLTWH(0, (image.height - image.width / newAspectRatio) / 2, image.width.toDouble(),
          image.width / newAspectRatio)
      : ui.Rect.fromLTWH((image.width - image.height * newAspectRatio) / 2, 0, image.height * newAspectRatio,
          image.height.toDouble());

  final ui.Rect dstRect = ui.Rect.fromLTWH(0, 0, newWidth.toDouble(), newHeight.toDouble());

  final ui.PictureRecorder recorder = ui.PictureRecorder();
  final ui.Canvas canvas = ui.Canvas(recorder, dstRect);

  final ui.Paint paint = ui.Paint()..filterQuality = ui.FilterQuality.high;

  canvas.drawImageRect(image, srcRect, dstRect, paint);

  final ui.Picture picture = recorder.endRecording();
  final ui.Image resizedImage = await picture.toImage(newWidth, newHeight);
  final ByteData byteData =
      await resizedImage.toByteData(format: ui.ImageByteFormat.png) as ByteData;

  return byteData.buffer.asUint8List();
}
