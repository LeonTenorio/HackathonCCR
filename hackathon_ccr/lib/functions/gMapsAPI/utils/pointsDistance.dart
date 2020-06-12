import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:vector_math/vector_math.dart' as vector_math;
import 'dart:math' as math;

final earthRadius = 6371000;

double distanceBetweenLatLngs(LatLng first, LatLng second){
  double phi_1 = vector_math.radians(first.latitude);
  double phi_2 = vector_math.radians(second.latitude);
  double delta_phi = vector_math.radians(second.latitude-first.latitude);
  double delta_lambda = vector_math.radians(second.longitude - first.longitude);
  double a = math.pow(math.sin(delta_phi/2.0), 2) + math.cos(phi_1)*math.cos(phi_2)*(math.pow(math.sin(delta_lambda/2.0), 2));
  double c = math.atan2(math.sqrt(a), math.sqrt(1-a));
  return earthRadius*c;
}