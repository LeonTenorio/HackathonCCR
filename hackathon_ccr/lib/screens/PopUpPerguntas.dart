import 'package:flutter/material.dart';
import 'package:hackathon_ccr/main.dart';
import 'package:hackathon_ccr/models/cache/Perguntas.dart';
import 'package:hackathon_ccr/widgets/Animation.dart';

class PopUpPerguntas extends StatefulWidget {
  @override
  _PopUpPerguntasState createState() => _PopUpPerguntasState();
}

class _PopUpPerguntasState extends State<PopUpPerguntas> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    this.isLoading = true;
    this.animation = new Container();
    loadPerguntas();
  }

  loadPerguntas() async{
    this.perguntas = await DadosPerguntas.getProximasPerguntas(DateTime.now());
    if(this.perguntas.length==0){
      Navigator.pop(context);
    }
    else
      done = false;
    setState(() {
      isLoading = false;
    });
  }

  closeRespostas(){
    if(this.novasRespostas.length>0){
      List<String> perguntasRespondidas = new List<String>();
      for(int i=0;i<indexPergunta;i++){
        perguntasRespondidas.add(this.perguntas[i]);
      }
      DadosPerguntas.responderPerguntas(DateTime.now(), perguntasRespondidas, novasRespostas);
    }
    Navigator.pop(context);
  }

  createAnimation(){
    Image image;
    Alignment alignment;
    if(this.done){
      image = Image.asset("assets/images/wow.gif");
      alignment = Alignment.bottomCenter;
    }
    else{
      image = Image.asset("assets/images/like.gif");
      alignment = Alignment.bottomRight;
    }
    this.animation = Align(
      alignment: alignment,
      child: new AnimatedContainerApp(width: 65.0, height: 65.0, child: image,),
    );
    Future.delayed(Duration(seconds: 3), (){
      setState(() {
        this.animation = new Container();
      });
    });
  }

  bool isLoading = true;
  bool done = false;

  List<String> perguntas;
  List<String> novasRespostas = new List<String>();
  int indexPergunta = 0;

  Widget animation;

  final List<String> respostas = ["Sim", "Mais o menos", "Não"];

  @override
  Widget build(BuildContext context) {
    if(this.isLoading){
      return WillPopScope(
        onWillPop: () async{
          closeRespostas();
          return true;
        },
        child: AlertDialog(
          backgroundColor: greyColor,
          title: Text("E ai parça?", style: TextStyle(fontFamily: "Roboto"),),
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
        ),
      );
    }
    else if(this.done){
      return WillPopScope(
        onWillPop: () async{
          closeRespostas();
          return true;
        },
        child: AlertDialog(
          backgroundColor: greyColor,
          title: Text("E ai parça?", style: TextStyle(fontFamily: "Roboto"),),
          content: Container(
            height: MediaQuery.of(context).size.height*0.3,
            width: MediaQuery.of(context).size.width*0.8,
            child: Stack(
              children: [
                Container(
                    height: MediaQuery.of(context).size.height*0.3,
                    width: MediaQuery.of(context).size.width*0.8,
                    child: Center(
                        child: Text("Obrigado por responder a tudo, tenha uma boa viagem ;)", style: TextStyle(fontFamily: 'OpenSans', fontSize: 18.0),)
                    )
                ),
                animation
              ],
            ),
          ),
          actions: [
            FlatButton(
              onPressed: (){
                closeRespostas();
              },
              child: Text("Ok", style: TextStyle(color: redColor, fontFamily: "OpenSans"),),
            )
          ],
        ),
      );
    }
    else{
      return WillPopScope(
        onWillPop: () async{
          closeRespostas();
          return true;
        },
        child: AlertDialog(
          backgroundColor: greyColor,
          title: Text("E ai parça?", style: TextStyle(fontFamily: "Roboto"),),
          content: Container(
            height: MediaQuery.of(context).size.height*0.3,
            child: Stack(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height*0.3,
                  width: MediaQuery.of(context).size.width*0.8,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.all(3.0),
                        child: Text(this.perguntas[indexPergunta], style: TextStyle(fontFamily: 'Roboto', fontSize: 18.0),),
                      ),
                      SizedBox(height: 15.0,),
                      Container(
                        alignment: Alignment.topCenter,
                        width: 125.0,
                        child: ListView(
                          shrinkWrap: true,
                          children: [
                            FlatButton(
                              color: laranja,
                              child: Text(this.respostas[0], style: TextStyle(fontFamily: 'OpenSans', fontSize: 14.0, color: Colors.white),),
                              onPressed: (){
                                if(indexPergunta<this.perguntas.length-1){
                                  setState(() {
                                    this.novasRespostas.add(this.respostas[0]);
                                    this.indexPergunta++;
                                  });
                                }
                                else{
                                  setState(() {
                                    done = true;
                                  });
                                }
                                createAnimation();
                              },
                            ),
                            FlatButton(
                              color: laranja,
                              child: Text(this.respostas[1], style: TextStyle(fontFamily: 'OpenSans', fontSize: 14.0, color: Colors.white),),
                              onPressed: (){
                                if(indexPergunta<this.perguntas.length){
                                  setState(() {
                                    this.novasRespostas.add(this.respostas[1]);
                                    this.indexPergunta++;
                                  });
                                }
                                else{
                                  setState(() {
                                    done = true;
                                  });
                                }
                                createAnimation();
                              },
                            ),
                            FlatButton(
                              color: laranja,
                              child: Text(this.respostas[2], style: TextStyle(fontFamily: 'OpenSans', fontSize: 14.0, color: Colors.white),),
                              onPressed: (){
                                if(indexPergunta<this.perguntas.length){
                                  setState(() {
                                    this.novasRespostas.add(this.respostas[2]);
                                    this.indexPergunta++;
                                  });
                                }
                                else{
                                  setState(() {
                                    done = true;
                                  });
                                }
                                createAnimation();
                              },
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                animation
              ],
            ),
          ),
          actions: [
            FlatButton(
              onPressed: (){
                closeRespostas();
              },
              child: Text("Ok", style: TextStyle(color: redColor, fontFamily: "OpenSans"),),
            )
          ],
        ),
      );
    }
  }
}
