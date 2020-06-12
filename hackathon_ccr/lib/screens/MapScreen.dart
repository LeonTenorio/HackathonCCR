import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hackathon_ccr/functions/gMapsAPI/GooglePlaces.dart';
import 'package:hackathon_ccr/models/gMapsAPI/GooglePlaces.dart';
import 'package:google_map_polyline/google_map_polyline.dart';

final String googleMapsKey = 'AIzaSyDU04kKsdqzpJZHI_Z-Qkkj-y93W5gZJYo';

final int raioPesquisa = 3000;
final double passoPesquisa = 4500.0;

class MapScreen extends StatefulWidget {
  @override
  MapScreenState createState() => MapScreenState();
}

class MapScreenState extends State<MapScreen> {
  @override
  initState(){
    super.initState();
  }

  @override
  dispose(){
    super.dispose();
  }

  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  Map<PolylineId, Polyline> route = <PolylineId, Polyline>{};
  GoogleMapController mapController;

  GoogleMapPolyline googleMapPolyline = new GoogleMapPolyline(apiKey: googleMapsKey);

  addPlace(PlaceModelRequest place){
    MarkerId markerId = new MarkerId(place.name+place.endereco);
    Marker marker = new Marker(
      markerId: markerId,
      position: place.local,
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context){
            return PopUpMarker(mapPage: this, place: place,);
          }
        );
      }
    );
    markers[markerId] = marker;
    setState(() {

    });
  }

  clearPlaces(){
    this.markers = <MarkerId, Marker>{};
    setState(() {

    });
  }

  clearRoute(){
    this.route = <PolylineId, Polyline>{};
    setState(() {

    });
  }

  setRoute(LatLng destination, bool searchPlaces) async{
    Position origin = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    var polys = await googleMapPolyline.getCoordinatesWithLocation(origin: LatLng(origin.latitude, origin.longitude), destination: destination, mode: RouteMode.driving);
    PolylineId polylineId = PolylineId('Rota');
    Polyline polyline = Polyline(
        polylineId: polylineId,
        points: polys,
        width: 5,
        color: Colors.amber,
        onTap: (){

        }
    );
    setState(() {
      route[polylineId] = polyline;
    });
    if(searchPlaces){
      getListaLocaisRota(this, polys, raioPesquisa, passoPesquisa, googleMapsKey);
    }
  }

  final LatLng _center = const LatLng(-23.291933,-46.033804);

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mapa'),
        backgroundColor: Colors.deepOrange,
      ),
      body: Stack(
        children: [
          GoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                target: _center,
                zoom: 11.0,
              ),
              markers: Set<Marker>.of(markers.values),
              polylines: Set<Polyline>.of(route.values),
              mapToolbarEnabled: true
          ),
          Padding(
            padding: EdgeInsets.only(top: 10.0, right: 10.0),
            child: Align(
              alignment: Alignment.topRight,
              child: Card(
                color: Colors.white,
                child: Padding(
                  padding: EdgeInsets.all(2.0),
                  child: IconButton(
                    icon: Icon(Icons.directions_run),
                    color: Colors.deepOrange,
                    iconSize: 30.0,
                    onPressed: () async{
                      await showDialog(
                          context: context,
                          builder: (BuildContext context){
                            return PopUpDestination(mapPage: this,);
                          }
                      );
                    },
                  ),
                )
              ),
            ),
          )
        ],
      )
    );
  }
}

class PopUpMarker extends StatefulWidget {
  PlaceModelRequest place;
  MapScreenState mapPage;

  PopUpMarker({this.place, this.mapPage});
  @override
  _PopUpMarkerState createState() => _PopUpMarkerState();
}

class _PopUpMarkerState extends State<PopUpMarker> {
  @override
  initState(){
    super.initState();
  }

  @override
  dispose(){
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(this.widget.place.name),
      content: Container(
        height: MediaQuery.of(context).size.height*0.8,
        width: MediaQuery.of(context).size.width*0.7,
        child: ListView(
          shrinkWrap: true,
          children: [
            Text("COLOCAR ALGUMAS COISAS", style: TextStyle(fontSize: 16.0), textAlign: TextAlign.center,)
          ],
        ),
      ),
      actions: [
        FlatButton(
          child: Text("Fechar"),
          onPressed: (){
            Navigator.pop(context);
          },
        ),
        FlatButton(
          child: Text("IR"),
          onPressed: (){
            this.widget.mapPage.clearRoute();
            this.widget.mapPage.clearPlaces();
            this.widget.mapPage.setRoute(this.widget.place.local, false);
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}

class PopUpDestination extends StatefulWidget {
  MapScreenState mapPage;
  PopUpDestination({this.mapPage});
  @override
  _PopUpDestinationState createState() => _PopUpDestinationState();
}

class _PopUpDestinationState extends State<PopUpDestination> {
  @override
  initState(){
    super.initState();
  }

  @override
  dispose(){
    super.dispose();
  }

  TextEditingController endereco = new TextEditingController();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    if(this.isLoading){
      return AlertDialog(
        title: Text("Insira seu destino"),
        content: Container(
          height: MediaQuery.of(context).size.height*0.8,
          width: MediaQuery.of(context).size.width*0.7,
          child: Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
              )
          )
        ),
        actions: [

        ],
      );
    }
    else{
      return AlertDialog(
        title: Text("Insira seu destino"),
        content: Container(
          height: MediaQuery.of(context).size.height*0.3,
          width: MediaQuery.of(context).size.width*0.8,
          child: ListView(
            shrinkWrap: true,
            children: [
              Material(
                child: TextFormField(
                  controller: this.endereco,
                  style: TextStyle(fontFamily: 'Roboto', fontSize: 18.0),
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.fromLTRB(20.0, 16.0, 20.0, 16.0),
                    hintText: "Endereço de destino",
                    filled: true,
                    fillColor: const Color(0xFFF0F0F0),
                    hintStyle: TextStyle(
                        color: const Color(0xFFa6a6a6),
                        fontSize: 18.0
                    ),
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: const Color(0xFFe6e6e6), width: 0.5),
                        borderRadius: BorderRadius.circular(10.0)
                    ),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: const Color(0xFFe6e6e6), width: 0.5),
                        borderRadius: BorderRadius.circular(8.0)
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: [
          FlatButton(
            child: Text("Cancelar"),
            onPressed: (){
              Navigator.pop(context);
            },
          ),
          FlatButton(
            child: Text("IR"),
            onPressed: () async{
              if(this.endereco.text.length>0){
                setState(() {
                  this.isLoading = true;
                });
                LatLng destino = await getLocationLatLng(this.endereco.text, googleMapsKey);
                if(destino==null){
                  setState(() {
                    this.isLoading = false;
                    this.endereco = new TextEditingController();
                  });
                }
                else{
                  this.widget.mapPage.clearPlaces();
                  this.widget.mapPage.clearRoute();
                  this.widget.mapPage.setRoute(destino, true);
                  Navigator.pop(context);
                }
              }
            },
          )
        ],
      );
    }
  }
}
