import 'package:flutter/material.dart';
import 'package:hackathon_ccr/models/Locais.dart';
import 'package:hackathon_ccr/models/User.dart';
import 'package:hackathon_ccr/screens/Login.dart';
import 'package:hackathon_ccr/screens/MapScreen.dart';

final String id_usuario = "usuario_test";
User user;

User test = User(
  telefone: 12988992458,
  nome: "Leon Tenório da Silva",
  imagem: "https://scontent.fsjk7-1.fna.fbcdn.net/v/t1.0-9/81898866_3586488861391918_2432618851674882048_o.jpg?_nc_cat=102&_nc_sid=09cbfe&_nc_oc=AQknssyTsUE6IfzaH1Wj-uTXM9cZGnX7GpX8rsjAftTSxFNaUeZnfpqhdBwxuiimuc4&_nc_ht=scontent.fsjk7-1.fna&oh=fcdd681f492a031dff160b14d65f680b&oe=5F0939D9",
  pontos: 250
);

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.red,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Login(),
    );
  }
}
