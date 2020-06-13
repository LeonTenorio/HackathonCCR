import 'package:flutter/material.dart';
import 'package:hackathon_ccr/screens/ChatBotScreen.dart';
import 'package:hackathon_ccr/screens/MapScreen.dart';

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
      home: ChatBox(),
    );
  }
}
