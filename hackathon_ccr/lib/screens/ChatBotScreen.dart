import 'package:bubble/bubble.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hackathon_ccr/functions/HexColor.dart';
import 'package:hackathon_ccr/main.dart';
import 'package:hackathon_ccr/models/ChatBot.dart';
import 'package:chatbar/chatbar.dart';

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
    getBotMessages();
  }

  @override
  dispose(){
    super.dispose();
  }

  getBotMessages() async{
    List<String> novasMessages = chatBox.getProximasMensagens();
    for(int i=0;i<novasMessages.length;i++){
      await Future.delayed(Duration(seconds: botMessageTime), (){
        this.isBootMessage.add(true);
        this.messages.add(novasMessages[i]);
        setState(() {
          messagesController.jumpTo(messagesController.position.maxScrollExtent+50.0);
        });
      });
    }
    getOpcoes();
  }

  getOpcoes(){
    Future.delayed(Duration(seconds: botMessageTime), (){
      this.opcoes = chatBox.getProximasOpcoes();
      setState(() {
        messagesController.jumpTo(messagesController.position.maxScrollExtent);
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
    getBotMessages();
  }

  @override
  Widget build(BuildContext context) {
    double pixelRatio = MediaQuery.of(context).devicePixelRatio;
    double px = 1 / pixelRatio;
    BubbleStyle styleSomebody = BubbleStyle(
      nip: BubbleNip.leftTop,
      color: HexColor.fromHex("#f6b89f"),
      elevation: 1 * px,
      margin: BubbleEdges.only(top: 8.0, right: 50.0),
      alignment: Alignment.topLeft,
    );
    BubbleStyle styleMe = BubbleStyle(
      nip: BubbleNip.rightTop,
      color: HexColor.fromHex("#475255E"),
      elevation: 1 * px,
      margin: BubbleEdges.only(top: 8.0, left: 50.0),
      alignment: Alignment.topRight,
    );

    BubbleStyle styleButton = BubbleStyle(
      nip: BubbleNip.no,
      color: laranja,
      elevation: 2,
      margin: BubbleEdges.only(top: 2.0, bottom: 2.0, left: 15.0, right: 10.0),
      alignment: Alignment.topCenter,
    );

    double offset = 300.0;
    if(this.opcoes.length==0)
      offset = 0;
    return WillPopScope(
      onWillPop: () async{
        return true;
      },
      child: Scaffold(
        appBar: ChatBar(
          profilePic: "https://firebasestorage.googleapis.com/v0/b/hackathonccr-78a4f.appspot.com/o/logo_fundo.jpg?alt=media&token=9bfe308f-a51e-48c9-b2d1-2fc397992a75",
          username: "Rubinho",
          status: ChatBarState.ONLINE,
          color: laranja,
          backbuttoncolor: Colors.white,
          backbutton: IconButton(icon: Icon(Icons.keyboard_arrow_left), onPressed:(){},color:Colors.white,),
          actions: <Widget>[
          ],
        ),
        body: Stack(
          children: [
            Scaffold(
              backgroundColor: Colors.white,
            ),
            Container(
              height: MediaQuery.of(context).size.height-offset,
              child: ListView.builder(
                shrinkWrap: true,
                controller: messagesController,
                padding: EdgeInsets.all(8.0),
                itemCount: this.messages.length,
                itemBuilder: (BuildContext context, int index){
                  BubbleStyle style;
                  Color fontColor = Colors.black87;
                  if(this.isBootMessage[index]){
                    style = styleSomebody;
                    fontColor = colorFontConversaBot;
                  }
                  else if(this.opcoes.contains(this.messages[index]))
                    style = styleButton;
                  else
                    style = styleMe;
                  if(!this.opcoes.contains(this.messages[index])){
                    return Bubble(
                      style: style,
                      child: Text(this.messages[index], style: TextStyle(fontFamily: "OpenSans", fontSize: 17.0, color: HexColor.fromHex("#47525E")),),
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
              alignment: Alignment.topCenter,
              child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: Padding(
                    padding: EdgeInsets.only(left: 10.0, right: 10.0, top: MediaQuery.of(context).size.height-300.0),
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: this.opcoes.length,
                      itemBuilder: (BuildContext context, int index){
                        return GestureDetector(
                            onTap: (){
                              selectProxMessages(this.opcoes[index]);
                            },
                            child: Padding(
                              padding: EdgeInsets.only(top: 5.0, left: 20.0, right: 20.0),
                              child: Container(
                                child: Card(
                                  elevation: 0.0,
                                  color: HexColor.fromHex("#EEEEEE"),
                                  child: Padding(
                                    padding: EdgeInsets.all(10.0),
                                    child: Text(this.opcoes[index], style: TextStyle(fontFamily: "OpenSans", fontSize: 17.0, color: HexColor.fromHex("#47525E")), textAlign: TextAlign.center,),
                                  ),
                                ),
                              ),
                            )
                        );
                      },
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