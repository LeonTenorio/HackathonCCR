import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hackathon_ccr/screens/MapScreen.dart';
import 'package:hackathon_ccr/screens/ProfileScreen.dart';

class NavigationMenu extends StatefulWidget {
  @override
  _NavigationMenuState createState() => _NavigationMenuState();
}

class _NavigationMenuState extends State<NavigationMenu> {
  int _selectedIndex = 0;

  void _onItemTapped(int index){
    setState(() {
      _selectedIndex = index;
    });
  }

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
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
    List<Widget> _widgetOptions;
    var _widgets;
    _widgets = const<BottomNavigationBarItem>[
      BottomNavigationBarItem(
        icon: Icon(Icons.map),
        title: Text('Mapa', style: TextStyle(color: Colors.white),),
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.person),
        title: Text('Perfil', style: TextStyle(color: Colors.white)),
      ),
    ];

    _widgetOptions = <Widget>[
      MapScreen(),
      ProfileScreen(),
    ];
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        unselectedItemColor: Colors.white,
        backgroundColor: Colors.black,
        type: BottomNavigationBarType.fixed,
        items: _widgets,
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.deepOrange,
        onTap: _onItemTapped,
      ),
    );
  }
}