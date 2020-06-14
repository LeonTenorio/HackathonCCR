import 'package:flutter/material.dart';

class AnimatedContainerApp extends StatefulWidget {
  double width;
  double height;
  Widget child;
  AnimatedContainerApp({this.width, this.height, this.child});
  @override
  _AnimatedContainerAppState createState() => _AnimatedContainerAppState();
}

class _AnimatedContainerAppState extends State<AnimatedContainerApp> {
  @override
  void dispose() {
    this.widget.height = 0;
    this.widget.width = 0;
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    double hei = this.widget.height;
    double wid = this.widget.width;
    this.widget.height = 0;
    this.widget.width = 0;
    Future.delayed(Duration(milliseconds: 100), (){
      setState(() {
        this.widget.height = hei;
        this.widget.width = wid;
      });
      Future.delayed(Duration(seconds: 2), (){
        setState(() {
          this.widget.height = 0;
          this.widget.width = 0;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      curve: Curves.fastOutSlowIn,
      width: this.widget.width,
      height: this.widget.height,
      duration: Duration(milliseconds: 500),
      child: this.widget.child
    );
  }
}