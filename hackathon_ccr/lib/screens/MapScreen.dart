import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hackathon_ccr/functions/Locais.dart';
import 'package:hackathon_ccr/functions/gMapsAPI/GooglePlaces.dart';
import 'package:hackathon_ccr/functions/gMapsAPI/utils/BitmapDescriptor.dart';
import 'package:hackathon_ccr/models/Locais.dart';
import 'package:hackathon_ccr/models/gMapsAPI/GooglePlaces.dart';
import 'package:google_map_polyline/google_map_polyline.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:hackathon_ccr/screens/ChatBotScreen.dart';
import 'package:hackathon_ccr/widgets/Animation.dart';
import 'package:hackathon_ccr/widgets/starsWidget.dart';

import '../main.dart';

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
    loadLocais();
  }

  @override
  dispose(){
    super.dispose();
  }

  loadLocais() async{
    this.locaisCredenciados = await getLocaisCredenciados();
    rebuildLocaisCredenciados();
  }

  addLocalCredenciado(LocalCredenciado local) async{
    if(!mounted)
      return;
    this.locaisCredenciados.add(local);
    MarkerId markerId = new MarkerId(local.nome);
    BitmapDescriptor descriptor = await getBitmapDescriptorFromUrl(local.icon, 85);
    Marker marker = new Marker(
        markerId: markerId,
        position: local.lat_lng,
        icon: descriptor,
        onTap: () {
          showDialog(
              context: context,
              builder: (BuildContext context){
                return PopUpLocalCadastrado(mapPage: this, local: local,);
              }
          );
        }
    );
    markers[markerId] = marker;
    if(mounted){
      setState(() {

      });
    }
  }

  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  Map<PolylineId, Polyline> route = <PolylineId, Polyline>{};
  Map<String, List<PlaceModelRequest>> tiposPlaces = <String, List<PlaceModelRequest>>{};
  List<LocalCredenciado> locaisCredenciados = new List<LocalCredenciado>();

  String tipoVisualizando = "";

  GoogleMapController mapController;

  GoogleMapPolyline googleMapPolyline = new GoogleMapPolyline(apiKey: googleMapsKey);

  addPlace(PlaceModelRequest place){
    if(!mounted)
      return;
    if(!this.tiposPlaces.containsKey(place.tipo)){
      this.tiposPlaces[place.tipo] = new List<PlaceModelRequest>();
    }
    if(!this.tiposPlaces[place.tipo].contains(place)){
      this.tiposPlaces[place.tipo].add(place);
    }
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
    if(mounted){
      setState(() {

      });
    }
  }

  rebuildLocaisCredenciados() async{
    for(int i=0;i<this.locaisCredenciados.length;i++){
      await this.addLocalCredenciado(this.locaisCredenciados[i]);
    }
  }

  clearPlaces(){
    this.markers = <MarkerId, Marker>{};
    setState(() {

    });
    rebuildLocaisCredenciados();
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
        color: laranja,
        onTap: (){

        }
    );
    setState(() {
      route[polylineId] = polyline;
    });
    if(searchPlaces){
      await getListaLocaisRota(this, polys, raioPesquisa, passoPesquisa, googleMapsKey);
    }
  }

  final LatLng _center = const LatLng(-23.291933,-46.033804);

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    if((this.tipoVisualizando=='' || this.tipoVisualizando==null) && this.tiposPlaces.keys.toList().length>0)
      this.tipoVisualizando = this.tiposPlaces.keys.toList()[0];
    return Scaffold(
      backgroundColor: greyColor,
      body:
        this.tiposPlaces.keys.toList().length>0?
        Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: ListView(
            shrinkWrap: true,
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height*0.5,
                child: Stack(
                  children: [
                    Container(
                      child: GoogleMap(
                          onMapCreated: _onMapCreated,
                          initialCameraPosition: CameraPosition(
                            target: _center,
                            zoom: 13.0,
                          ),
                          myLocationButtonEnabled: false,
                          myLocationEnabled: true,
                          markers: Set<Marker>.of(markers.values),
                          polylines: Set<Polyline>.of(route.values),
                          mapToolbarEnabled: false,
                          gestureRecognizers: Set()
                            ..add(
                                Factory<PanGestureRecognizer>(() => PanGestureRecognizer()))
                            ..add(
                              Factory<VerticalDragGestureRecognizer>(
                                      () => VerticalDragGestureRecognizer()),
                            )
                            ..add(
                              Factory<HorizontalDragGestureRecognizer>(
                                      () => HorizontalDragGestureRecognizer()),
                            )
                            ..add(
                              Factory<ScaleGestureRecognizer>(
                                      () => ScaleGestureRecognizer()),
                            ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 35.0, right: 10.0),
                      child: Align(
                        alignment: Alignment.topRight,
                        child: Card(
                            color: Colors.white,
                            child: Padding(
                              padding: EdgeInsets.all(2.0),
                              child: IconButton(
                                icon: Icon(Icons.directions_run),
                                color: redColor,
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
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 35.0, left: 10.0),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Card(
                            color: Colors.white,
                            child: Padding(
                              padding: EdgeInsets.all(2.0),
                              child: IconButton(
                                icon: Icon(Icons.insert_emoticon),
                                color: redColor,
                                iconSize: 30.0,
                                onPressed: () async{
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => ChatBox()));
                                },
                              ),
                            )
                        ),
                      ),
                    )
                  ],
                ),
              ),
              ListView(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                children: [
                  Container(
                    height: 75.0,
                    child: Padding(
                        padding: EdgeInsets.all(5.0),
                        child: ListView.separated(
                          shrinkWrap: true,
                          itemCount: this.tiposPlaces.keys.toList().length,
                          separatorBuilder: (BuildContext context, int index) {
                            return SizedBox(width: 10.0);
                          },
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (BuildContext context, int index){
                            String local = 'assets/images/';
                            String tipo = this.tiposPlaces.keys.toList()[index];
                            Color selectTypeColor = greyColor;
                            if(this.tiposPlaces.keys.toList()[index]==this.tipoVisualizando)
                              selectTypeColor = redColor;
                            if(tipo=='restaurant')
                              local = local + 'restaurant.png';
                            else if(tipo=='bar')
                              local = local + 'bar.png';
                            else if(tipo=='car_repair')
                              local = local + 'car_repair.png';
                            else if(tipo=='health')
                              local = local + 'health.png';
                            return GestureDetector(
                              child: Container(
                                height: 50.0,
                                width: 50.0,
                                child: Card(
                                    color: selectTypeColor,
                                    child: Center(
                                      child: Padding(
                                        padding: EdgeInsets.all(3.0),
                                        child: Image.asset(local, fit: BoxFit.contain, ),
                                      )
                                    )
                                ),
                              ),
                              onTap: (){
                                setState(() {
                                  this.tipoVisualizando = this.tiposPlaces.keys.toList()[index];
                                });
                              },
                            );
                          },
                        )
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(5.0),
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: this.tiposPlaces[this.tipoVisualizando].length,
                      itemBuilder: (BuildContext context, int index){
                        PlaceModelRequest place = this.tiposPlaces[this.tipoVisualizando][index];
                        String distanceText = "Distância menor que "+(place.distance/1000).ceil().toString()+" quilômetros";
                        if(place.distance<raioPesquisa)
                          distanceText = "Nas proximidades";
                        return GestureDetector(
                          onTap: (){
                            showDialog(
                              context: context,
                              builder: (BuildContext context){
                                return PopUpMarker(mapPage: this, place: this.tiposPlaces[this.tipoVisualizando][index],);
                              }
                            );
                          },
                          child: Card(
                            color: greyColor,
                            child: Padding(
                                padding: EdgeInsets.only(top: 5.0, bottom: 5.0, right: 10.0, left: 10.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(place.name, style: TextStyle(fontSize: 16.0, color: redColor, fontFamily: 'Roboto',), textAlign: TextAlign.left,),
                                    SizedBox(height: 2.0,),
                                    Text(place.endereco, style: TextStyle(fontSize: 14.0, fontFamily: 'OpenSans',), textAlign: TextAlign.left,),
                                    SizedBox(height: 2.0,),
                                    Text(distanceText, style: TextStyle(fontSize: 14.0, fontFamily: 'OpenSans',),)
                                  ],
                                )
                            ),
                          ),
                        );
                      },
                    ),
                  )
                ],
              ),
            ],
          ),
        )
        :Stack(
          children: [
            GoogleMap(
              onTap: (value){
                print(value);
              },
                onMapCreated: _onMapCreated,
                initialCameraPosition: CameraPosition(
                  target: _center,
                  zoom: 13.0,
                ),
                myLocationButtonEnabled: false,
                myLocationEnabled: true,
                markers: Set<Marker>.of(markers.values),
                polylines: Set<Polyline>.of(route.values),
                mapToolbarEnabled: false,
            ),
            Padding(
              padding: EdgeInsets.only(top: 35.0, right: 10.0),
              child: Align(
                alignment: Alignment.topRight,
                child: Card(
                    color: Colors.white,
                    child: Padding(
                      padding: EdgeInsets.all(2.0),
                      child: IconButton(
                        icon: Icon(Icons.directions_run),
                        color: redColor,
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
            ),
            Padding(
              padding: EdgeInsets.only(top: 35.0, left: 10.0),
              child: Align(
                alignment: Alignment.topLeft,
                child: Card(
                    color: Colors.white,
                    child: Padding(
                      padding: EdgeInsets.all(2.0),
                      child: IconButton(
                        icon: Icon(Icons.insert_emoticon),
                        color: yellowColor,
                        iconSize: 30.0,
                        onPressed: () async{
                          Navigator.push(context, MaterialPageRoute(builder: (context) => ChatBox()));
                        },
                      ),
                    )
                ),
              ),
            )
          ],
        ),
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
      backgroundColor: greyColor,
      title: Text(this.widget.place.name, style: TextStyle(fontFamily: "Roboto"),),
      content: Container(
        height: MediaQuery.of(context).size.height*0.3,
        width: MediaQuery.of(context).size.width*0.8,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(this.widget.place.name, style: TextStyle(fontSize: 16.0, color: redColor, fontFamily: "OpenSans"), textAlign: TextAlign.left,),
            SizedBox(height: 2.0,),
            Text(this.widget.place.endereco, style: TextStyle(fontSize: 14.0, fontFamily: "OpenSans"), textAlign: TextAlign.left,),
            SizedBox(height: 2.0,),
            Text("Distância de "+this.widget.place.distance.toInt().toString()+" quilômetros", style: TextStyle(fontSize: 14.0, fontFamily: "OpenSans"),)
          ],
        )
      ),
      actions: [
        FlatButton(
          child: Text("Fechar", style: TextStyle(color: redColor, fontFamily: "OpenSans"),),
          onPressed: (){
            Navigator.pop(context);
          },
        ),
        FlatButton(
          child: Text("IR", style: TextStyle(color: redColor, fontFamily: "OpenSans"),),
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
        backgroundColor: greyColor,
        title: Text("Insira seu destino", style: TextStyle(fontFamily: "Roboto"),),
        content: Container(
          height: MediaQuery.of(context).size.height*0.3,
          width: MediaQuery.of(context).size.width*0.8,
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
        backgroundColor: greyColor,
        title: Text("Insira seu destino", style: TextStyle(fontFamily: "Roboto"),),
        content: Container(
          height: MediaQuery.of(context).size.height*0.3,
          width: MediaQuery.of(context).size.width*0.8,
          child: ListView(
            shrinkWrap: true,
            children: [
              TextFormField(
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
            ],
          ),
        ),
        actions: [
          FlatButton(
            child: Text("Cancelar", style: TextStyle(color: redColor, fontFamily: "OpenSans"),),
            onPressed: (){
              Navigator.pop(context);
            },
          ),
          FlatButton(
            child: Text("IR", style: TextStyle(color: redColor, fontFamily: "OpenSans"),),
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

class PopUpLocalCadastrado extends StatefulWidget {
  MapScreenState mapPage;
  LocalCredenciado local;
  PopUpLocalCadastrado({this.mapPage, this.local});
  @override
  _PopUpLocalCadastradoState createState() => _PopUpLocalCadastradoState();
}
class _PopUpLocalCadastradoState extends State<PopUpLocalCadastrado> {
  @override
  initState(){
    super.initState();
    loadAvaliacoes();
    //testando();
  }

  @override
  dispose(){
    super.dispose();
  }

  testando() async{
    this.widget.local.createVantagem(
        'https://s2.glbimg.com/iSims57rytRmuf8K3r6lymnLUGs=/0x0:2592x1728/1008x0/smart/filters:strip_icc()/i.s3.glbimg.com/v1/AUTH_59edd422c0c84a879bd37670ae4f538a/internal_photos/bs/2017/A/i/IPzdK3S8KrxIr3QfZPxw/ccr-spvias-foto-1.jpg',
        150,
        "Pedágio gratuíto. Isso mesmo, 150 pontos e você poderá passar gratuitamente nesse pedágio independentemente da quantidade de eixos. Essa promoção está limitada a 100 caminhoneiros, então corra, ou melhor ande dentros dos limites de velocidade e assim que possível cola comigo chapa.",
        DateTime.now().add(Duration(days: 30)),
        100);
  }

  bool isLoading = true;
  bool avaliando = false;
  bool vantagens = false;
  List<Avaliacao> avaliacoes = new List<Avaliacao>();
  List<Vantagens> vantagensLocal = new List<Vantagens>();

  TextEditingController avaliacao = new TextEditingController();
  StarSelectDisplay starSelectDisplay;

  Widget animacao = new Container();

  loadAvaliacoes() async{
    this.avaliacoes = await this.widget.local.getAvaliacoes();
    setState(() {
      isLoading = false;
    });
  }

  irAvaliar(){
    this.animacao = new Container();
    setState(() {
      avaliando = true;
      avaliacao = new TextEditingController();
      starSelectDisplay = StarSelectDisplay(value: 3,);
    });
  }

  terminarAvaliacao() async{
    if(this.avaliacao.text.length>0){
      setState(() {
        this.avaliando = false;
        this.isLoading = true;
        this.animacao = Align(
          alignment: Alignment.bottomCenter,
          child: new AnimatedContainerApp(width: 70.0, height: 70.0, child: Image.asset("assets/images/wow.gif"),),
        );
      });
      await this.widget.local.createAvaliacao(this.avaliacao.text, this.starSelectDisplay.value, id_usuario);
      loadAvaliacoes();
    }
  }

  verVantagens() async{
    setState(() {
      isLoading = true;
    });
    this.vantagensLocal = await this.widget.local.getVantagens();
    setState(() {
      isLoading = false;
      vantagens = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if(this.isLoading){
      return AlertDialog(
        backgroundColor: greyColor,
        title: Text(this.widget.local.nome, style: TextStyle(fontFamily: "Roboto"),),
        content: Container(
          height: MediaQuery.of(context).size.height*0.3,
          width: MediaQuery.of(context).size.width*0.8,
          child: Stack(
            children: [
              Container(
                  height: MediaQuery.of(context).size.height*0.3,
                  width: MediaQuery.of(context).size.width*0.8,
                  child: Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                      )
                  )
              ),
              this.animacao
            ],
          ),
        ),
        actions: [

        ],
      );
    }
    else{
      if(this.avaliando){
        return WillPopScope(
          onWillPop: () async{
            setState(() {
              this.avaliando = false;
            });
            return false;
          },
          child: AlertDialog(
            backgroundColor: greyColor,
            title: Text(this.widget.local.nome, style: TextStyle(fontFamily: "Roboto"),),
            content: Container(
              height: MediaQuery.of(context).size.height*0.7,
              width: MediaQuery.of(context).size.width*0.9,
              child: Stack(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height*0.7,
                    width: MediaQuery.of(context).size.width*0.9,
                    child: ListView(
                      shrinkWrap: true,
                      children: [
                        Container(
                          height: MediaQuery.of(context).size.height*0.3,
                          child: Padding(
                            padding: EdgeInsets.all(5.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Image.network(this.widget.local.icon, width: 75.0, height: 75.0,),
                                Container(
                                  width: MediaQuery.of(context).size.width*0.7-110.0,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(this.widget.local.nome, style: TextStyle(fontSize: 16.0, color: redColor, fontFamily: 'Roboto',),),
                                      SizedBox(height: 2.0,),
                                      Text(this.widget.local.endereco, style: TextStyle(fontSize: 14.0, fontFamily: 'OpenSans',),),
                                      SizedBox(height: 2.0,),
                                      Text(this.widget.local.telefone, style: TextStyle(fontSize: 14.0, fontFamily: 'OpenSans',),),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(3.0),
                          child: Card(
                            color: greyColor,
                            child: Padding(
                              padding: EdgeInsets.all(5.0),
                              child: Column(
                                children: [
                                  starSelectDisplay,
                                  SizedBox(height: 10.0,),
                                  TextFormField(
                                    controller: this.avaliacao,
                                    style: TextStyle(fontFamily: 'Roboto', fontSize: 18.0),
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.fromLTRB(20.0, 16.0, 20.0, 16.0),
                                      hintText: "Comentário",
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
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 5.0,),
                        Align(
                          alignment: Alignment.topCenter,
                          child: FlatButton(
                            color: laranja,
                            child: Text("Avaliar", style: TextStyle(fontFamily: "OpenSans"),),
                            onPressed: (){
                              terminarAvaliacao();
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                  animacao
                ],
              ),
            ),
            actions: [
              FlatButton(
                child: Text("Cancelar", style: TextStyle(color: redColor, fontFamily: "OpenSans"),),
                onPressed: (){
                  Navigator.pop(context);
                },
              ),
              FlatButton(
                child: Text("IR", style: TextStyle(color: redColor, fontFamily: "OpenSans"),),
                onPressed: () async{
                  print("aqui");
                  this.widget.mapPage.setRoute(this.widget.local.lat_lng, false);
                },
              )
            ],
          ),
        );
      }
      else if(this.vantagens){
        return WillPopScope(
          onWillPop: () async{
            setState(() {
              this.vantagens = false;
            });
            return false;
          },
          child: AlertDialog(
            backgroundColor: greyColor,
            title: Text(this.widget.local.nome, style: TextStyle(fontFamily: "Roboto"),),
            content: Container(
              height: MediaQuery.of(context).size.height*0.7,
              width: MediaQuery.of(context).size.width*0.9,
              child: Stack(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height*0.7,
                    width: MediaQuery.of(context).size.width*0.9,
                    child: ListView(
                      shrinkWrap: true,
                      children: [
                        Container(
                          height: MediaQuery.of(context).size.height*0.3,
                          child: Padding(
                            padding: EdgeInsets.all(5.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Image.network(this.widget.local.icon, width: 75.0, height: 75.0,),
                                Container(
                                  width: MediaQuery.of(context).size.width*0.7-110.0,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(this.widget.local.nome, style: TextStyle(fontSize: 16.0, color: redColor, fontFamily: 'Roboto',),),
                                      SizedBox(height: 2.0,),
                                      Text(this.widget.local.endereco, style: TextStyle(fontSize: 14.0, fontFamily: 'OpenSans',),),
                                      SizedBox(height: 2.0,),
                                      Text(this.widget.local.telefone, style: TextStyle(fontSize: 14.0, fontFamily: 'OpenSans',),),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        ListView.builder(
                          itemCount: this.vantagensLocal.length,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (BuildContext context, int index){
                            return Padding(
                              padding: EdgeInsets.all(3.0),
                              child: Card(
                                color: greyColor,
                                child: Padding(
                                  padding: EdgeInsets.all(5.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Image.network(this.vantagensLocal[index].imagem, fit: BoxFit.contain, height: 150.0,),
                                      SizedBox(height: 2.0,),
                                      Text(this.vantagensLocal[index].descricao, style: TextStyle(fontSize: 14.0, fontFamily: 'OpenSans',), textAlign: TextAlign.start,),
                                      SizedBox(height: 7.0,),
                                      Text("STEPS: "+this.vantagensLocal[index].pontos.toString(), style: TextStyle(fontSize: 14.0, fontFamily: 'OpenSans',),)
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        )
                      ],
                    ),
                  ),
                  animacao
                ],
              ),
            ),
            actions: [
              FlatButton(
                child: Text("Cancelar", style: TextStyle(color: redColor, fontFamily: "OpenSans"),),
                onPressed: (){
                  Navigator.pop(context);
                },
              ),
              FlatButton(
                child: Text("IR", style: TextStyle(color: redColor, fontFamily: "OpenSans"),),
                onPressed: () async{
                  this.widget.mapPage.setRoute(this.widget.local.lat_lng, false);
                },
              )
            ],
          ),
        );
      }
      else{
        return AlertDialog(
          backgroundColor: greyColor,
          title: Text(this.widget.local.nome, style: TextStyle(fontFamily: "Roboto"),),
          content: Container(
            height: MediaQuery.of(context).size.height*0.7,
            width: MediaQuery.of(context).size.width*0.9,
            child: ListView(
              shrinkWrap: true,
              children: [
                Container(
                  height: MediaQuery.of(context).size.height*0.3,
                  child: Padding(
                    padding: EdgeInsets.all(5.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Image.network(this.widget.local.icon, width: 75.0, height: 75.0,),
                        Container(
                          width: MediaQuery.of(context).size.width*0.7-110.0,
                          child: ListView(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            children: [
                              Text(this.widget.local.nome, style: TextStyle(fontSize: 16.0, color: redColor, fontFamily: 'Roboto',),),
                              SizedBox(height: 2.0,),
                              Text(this.widget.local.endereco, style: TextStyle(fontSize: 14.0, fontFamily: 'OpenSans',),),
                              SizedBox(height: 2.0,),
                              Text(this.widget.local.telefone, style: TextStyle(fontSize: 14.0, fontFamily: 'OpenSans',),),
                              Center(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    FlatButton(
                                      color: laranja,
                                      onPressed: (){
                                        irAvaliar();
                                      },
                                      child: Text("Avaliar"),
                                    ),
                                    FlatButton(
                                      color: laranja,
                                      onPressed: (){
                                        verVantagens();
                                      },
                                      child: Text("Vantagens"),
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                ListView.builder(
                  itemCount: this.avaliacoes.length,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (BuildContext context, int index){
                    return Padding(
                      padding: EdgeInsets.all(3.0),
                      child: Card(
                        color: greyColor,
                        child: Padding(
                          padding: EdgeInsets.all(5.0),
                          child: Column(
                            children: [
                              StarDisplay(value: this.avaliacoes[index].nota,),
                              SizedBox(height: 2.0,),
                              Text(this.avaliacoes[index].comentario, style: TextStyle(fontSize: 14.0, fontFamily: 'OpenSans',), textAlign: TextAlign.start,)
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                )
              ],
            ),
          ),
          actions: [
            FlatButton(
              child: Text("Cancelar", style: TextStyle(color: redColor),),
              onPressed: (){
                Navigator.pop(context);
              },
            ),
            FlatButton(
              child: Text("IR", style: TextStyle(color: redColor),),
              onPressed: () async{
                this.widget.mapPage.setRoute(this.widget.local.lat_lng, false);
              },
            )
          ],
        );
      }
    }
  }
}
