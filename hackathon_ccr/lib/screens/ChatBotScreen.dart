import 'package:bubble/bubble.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hackathon_ccr/models/gMapsAPI/ChatBot.dart';

final botMessageTime = 1;

class ChatBox extends StatefulWidget {
  @override
  _ChatBoxState createState() => _ChatBoxState();
}

class _ChatBoxState extends State<ChatBox> {

  List<String> messages = new List<String>();
  List<bool> isBootMessage = new List<bool>();
  ChatMessages chatBox = new ChatMessages();

  List<String> opcoes = new List<String>();
  ScrollController messagesController = ScrollController();

  @override
  initState(){
    super.initState();
    getBootMessages();
  }

  @override
  dispose(){
    super.dispose();
  }

  getBootMessages() async{
    List<String> novasMessages = chatBox.getProximasMensagens();
    for(int i=0;i<novasMessages.length;i++){
      await Future.delayed(Duration(seconds: botMessageTime), (){
        this.isBootMessage.add(true);
        this.messages.add(novasMessages[i]);
        setState(() {
          messagesController.jumpTo(messagesController.position.maxScrollExtent);
        });
      });
    }
    getOpcoes();
  }

  getOpcoes(){
    Future.delayed(Duration(seconds: botMessageTime), (){
      this.opcoes = chatBox.getProximasOpcoes();
      setState(() {

      });
    });
  }

  selectProxMessages(String opcao){
    this.messages.add(opcao);
    this.isBootMessage.add(false);
    this.opcoes = new List<String>();
    setState(() {

    });
    chatBox.setOpcao(opcao);
    getBootMessages();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom, SystemUiOverlay.top]);
    double pixelRatio = MediaQuery.of(context).devicePixelRatio;
    double px = 1 / pixelRatio;
    BubbleStyle styleSomebody = BubbleStyle(
      nip: BubbleNip.leftTop,
      color: Colors.white,
      elevation: 1 * px,
      margin: BubbleEdges.only(top: 8.0, right: 50.0),
      alignment: Alignment.topLeft,
    );
    BubbleStyle styleMe = BubbleStyle(
      nip: BubbleNip.rightTop,
      color: Color.fromARGB(255, 225, 255, 199),
      elevation: 1 * px,
      margin: BubbleEdges.only(top: 8.0, left: 50.0),
      alignment: Alignment.topRight,
    );

    BubbleStyle styleButton = BubbleStyle(
      nip: BubbleNip.no,
      color: Colors.lightGreen,
      elevation: 2,
      margin: BubbleEdges.only(top: 2.0, bottom: 2.0, left: 15.0, right: 10.0),
      alignment: Alignment.topRight,
    );

    return WillPopScope(
      onWillPop: () async{
        SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text("CHAT"),
          backgroundColor: Colors.green,
        ),
        body: Stack(
          children: [
            Image.asset(
              "assets/images/whatsapp.png",
              fit: BoxFit.cover,
            ),
            Container(
              height: MediaQuery.of(context).size.height,
              child: ListView.builder(
                shrinkWrap: true,
                controller: messagesController,
                padding: EdgeInsets.all(8.0),
                itemCount: this.messages.length,
                itemBuilder: (BuildContext context, int index){
                  BubbleStyle style;
                  if(this.isBootMessage[index])
                    style = styleSomebody;
                  else if(this.opcoes.contains(this.messages[index]))
                    style = styleButton;
                  else
                    style = styleMe;
                  if(!this.opcoes.contains(this.messages[index])){
                    return Bubble(
                      style: style,
                      child: Text(this.messages[index]),
                    );
                  }
                  else{
                    return SizedBox(
                      height: 2.0,
                    );
                  }
                },
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 125.0,
                  child: Padding(
                    padding: EdgeInsets.only(left: 3.0, right: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                            width: MediaQuery.of(context).size.width-50.0,
                            child: Padding(
                              padding: EdgeInsets.all(10.0),
                              child: ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: this.opcoes.length,
                                itemBuilder: (BuildContext context, int index){
                                  return GestureDetector(
                                    onTap: (){
                                      selectProxMessages(this.opcoes[index]);
                                    },
                                    child: Bubble(
                                      style: styleButton,
                                      child: Text(this.opcoes[index]),
                                    ),
                                  );
                                },
                              ),
                            )
                        ),
                        Icon(
                          Icons.send,
                          size: 35.0,
                          color: Colors.black38,
                        )
                      ],
                    ),
                  )
              ),
            )
          ],
        ),
      ),
    );
  }
}
