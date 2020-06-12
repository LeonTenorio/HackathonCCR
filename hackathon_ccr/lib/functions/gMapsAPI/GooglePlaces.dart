import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hackathon_ccr/functions/gMapsAPI/utils/pointsDistance.dart';
import 'package:hackathon_ccr/models/gMapsAPI/GooglePlaces.dart';
import 'package:hackathon_ccr/screens/MapScreen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

final List<String> tipos = ['restaurant', 'bar', 'car_repair'];

Future<void> getListaLocaisRota(MapScreenState page, List<LatLng> rota, int raio, double passo, String apiKey) async{
  LatLng proximoLocal = rota[0];
  double distancia = 0.0;
  int i=1;
  while(true){
    if(i==rota.length-1)
      break;
    distancia = distancia + distanceBetweenLatLngs(rota[i-1], rota[i]);
    if(distanceBetweenLatLngs(rota[i], proximoLocal)<passo){
      i++;
    }
    else{
      proximoLocal = rota[i];
      i++;
      for(int i=0;i<tipos.length;i++){
        PlacesModelRequest places = await getLatLngPlaces(proximoLocal, raio, tipos[i], apiKey, distancia + double.parse(raio.toString()));
        for(int j=0;j<places.placesModelRequest.length;j++){
          page.addPlace(places.placesModelRequest[j]);
        }
      }
    }
  }
  proximoLocal = rota.last;
  if(distanceBetweenLatLngs(rota[i], proximoLocal)>passo/2){
    for(int i=0;i<tipos.length;i++){
      PlacesModelRequest places = await getLatLngPlaces(proximoLocal, raio, tipos[i], apiKey, distancia);
      for(int j=0;j<places.placesModelRequest.length;j++){
        page.addPlace(places.placesModelRequest[j]);
      }
    }
  }
}

Future<PlacesModelRequest> getLatLngPlaces(LatLng latlng, int raio, String type, String apiKey, double distancia) async{
  String url = 'https://maps.googleapis.com/maps/api/place/nearbysearch/json?key='+apiKey+'&location='+latlng.latitude.toString()+','+latlng.longitude.toString()+'&type='+type+'&radius='+raio.toString()+'&fields=basic';
  var response = await http.get(url);
  PlacesModelRequest placesModelRequest = new PlacesModelRequest();
  BitmapDescriptor bitmapDescriptor;
  try{
    placesModelRequest = new PlacesModelRequest.fromJson(json.decode(response.body), type, distancia, bitmapDescriptor);
    print('Dados de locais obtidos '+placesModelRequest.placesModelRequest.length.toString());
  }
  catch(e){
    print('Erros na posicao: '+latlng.toString());
  }
  return placesModelRequest;
}

Future<LatLng> getLocationLatLng(String address, String apiKey) async{
  String url = 'https://maps.googleapis.com/maps/api/geocode/json?address='+address.replaceAll(' ', '+')+'&key='+apiKey+'&fields=basic';
  var response = await http.get(url);
  LatLng ret;
  try{
    var jsonResponde = json.decode(response.body);
    List<dynamic> results = jsonResponde['results'].cast<dynamic>();
    Map<String, dynamic> map = results[0]['geometry']['location'];
    ret = LatLng(map['lat'], map['lng']);
  }
  catch(e){
    print('erro no geoencoder');
    ret = null;
  }
  return ret;
}

Future<BitmapDescriptor> getMarkerIcon(String tipo) async{
  String local = 'assets/images/markers/';
  if(tipo=='restaurant' || tipo=='bakery')
    local = local + 'restaurant.bmp';
  else if(tipo=='bar')
    local = local + 'bar.bmp';
  BitmapDescriptor bitmapDescriptor = await BitmapDescriptor.fromAssetImage(ImageConfiguration(size: Size(12,12)), local);
  return bitmapDescriptor;
}