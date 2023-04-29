import 'dart:typed_data';
import 'package:flutter/services.dart';

Future<Uint8List> loadImageDataFromAsset(String assetName) async {
  final ByteData assetData = await rootBundle.load(assetName);
  return assetData.buffer.asUint8List();
}
