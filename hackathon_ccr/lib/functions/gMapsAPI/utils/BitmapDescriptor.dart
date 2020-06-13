import 'dart:ui' as ui;
import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

Future<BitmapDescriptor> getBitmapDescriptorFromUrl(String url, int width) async{
  var request = await http.get(url);
  var bytes = request.bodyBytes;

  ui.Codec codec = await ui.instantiateImageCodec(bytes.buffer.asUint8List(), targetWidth: width);
  ui.FrameInfo fi = await codec.getNextFrame();

  var test = (await fi.image.toByteData(format: ui.ImageByteFormat.png)).buffer.asUint8List();
  return BitmapDescriptor.fromBytes(test);
}