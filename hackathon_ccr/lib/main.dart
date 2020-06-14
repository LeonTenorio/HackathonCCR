import 'package:flutter/material.dart';
import 'package:hackathon_ccr/functions/HexColor.dart';
import 'package:hackathon_ccr/models/User.dart';
import 'package:hackathon_ccr/screens/Login.dart';

final String id_usuario = "usuario_test";
User user;

final Color redColor = HexColor.fromHex("#9E260E");
final Color greyColor = HexColor.fromHex("#E9E8E3");
final Color yellowColor = HexColor.fromHex("#FDB827");

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
