import 'package:google_maps_flutter/google_maps_flutter.dart';

class PlaceModelRequest{
  String name;
  LatLng local;
  bool operacional;
  String endereco;
  String urlMaps;

  PlaceModelRequest.fromJson(Map<String, dynamic> json){
    name = json['name'];
    local = LatLng(json['geometry']['location']['lat'], json['geometry']['location']['lng']);
    if(json['business_status']=='OPERATIONAL')
      operacional = true;
    else
      operacional = false;
    endereco = json['vicinity'];
    try{
      if(json.containsKey('photos') && json['photos'].containsKey('html_attributions')){
        List<String> html_attributions = json['photos']['html_attributions'].cast<String>();
        List<String> url = html_attributions[0].split("\\\"");
        this.urlMaps = url[1];
      }
    }
    catch(e){

    }
  }
}

class PlacesModelRequest{
  List<PlaceModelRequest> placesModelRequest;

  PlacesModelRequest(){
    this.placesModelRequest = new List<PlaceModelRequest>();
  }

  PlacesModelRequest.fromJson(Map<String, dynamic> json){
    this.placesModelRequest = new List<PlaceModelRequest>();
    if(json.containsKey('results')){
      List<dynamic> results = json['results'].cast<dynamic>();
      print('quantidade de locais: '+results.length.toString());
      for(int i=0;i<results.length;i++){
        print('obtendo mais um local');
        this.placesModelRequest.add(PlaceModelRequest.fromJson(results[i]));
      }
    }
  }
}