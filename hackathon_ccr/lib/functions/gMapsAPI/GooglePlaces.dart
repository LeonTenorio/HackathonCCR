import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hackathon_ccr/functions/gMapsAPI/utils/pointsDistance.dart';
import 'package:hackathon_ccr/models/gMapsAPI/GooglePlaces.dart';
import 'package:hackathon_ccr/screens/MapScreen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

final List<String> tipos = ['restaurant'];

Future<void> getListaLocaisRota(MapScreenState page, List<LatLng> rota, int raio, double passo, String apiKey) async{
  LatLng proximoLocal = rota[0];
  int i=0;
  while(true){
    if(i==rota.length-1)
      break;
    if(distanceBetweenLatLngs(rota[i], proximoLocal)<passo){
      i++;
    }
    else{
      proximoLocal = rota[i];
      i++;
      for(int i=0;i<tipos.length;i++){
        PlacesModelRequest places = await getLatLngPlaces(proximoLocal, raio, tipos[i], apiKey);
        for(int j=0;j<places.placesModelRequest.length;j++){
          page.addPlace(places.placesModelRequest[j]);
        }
      }
    }
  }
  proximoLocal = rota.last;
  if(distanceBetweenLatLngs(rota[i], proximoLocal)>passo/2){
    for(int i=0;i<tipos.length;i++){
      PlacesModelRequest places = await getLatLngPlaces(proximoLocal, raio, tipos[i], apiKey);
      for(int j=0;j<places.placesModelRequest.length;j++){
        page.addPlace(places.placesModelRequest[j]);
      }
    }
  }
}

Future<PlacesModelRequest> getLatLngPlaces(LatLng latlng, int raio, String type, String apiKey) async{
  String url = 'https://maps.googleapis.com/maps/api/place/nearbysearch/json?key='+apiKey+'&location='+latlng.latitude.toString()+','+latlng.longitude.toString()+'&type='+type+'&radius='+raio.toString()+'&fields=basic';
  var response = await http.get(url);
  PlacesModelRequest placesModelRequest = new PlacesModelRequest();
  try{
    placesModelRequest = new PlacesModelRequest.fromJson(json.decode(response.body));
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