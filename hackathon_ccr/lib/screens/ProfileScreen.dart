import 'package:flutter/material.dart';
import 'package:hackathon_ccr/functions/HexColor.dart';
import 'package:hackathon_ccr/main.dart';
import 'package:hackathon_ccr/models/User.dart';
import 'package:hackathon_ccr/widgets/PopUpContatos.dart';

List<User> rankTest = [
  User(
      telefone: 12999999999,
      nome: "Rubens Augusto",
      imagem: "https://cdn3.iconfinder.com/data/icons/diversity-avatars-vol-2/64/trucker-ballcap-mustache-overalls-man-512.png",
      pontos: 450
  ),
  User(
      telefone: 12999999999,
      nome: "Carlos Alberto",
      imagem: "https://cdn3.iconfinder.com/data/icons/diversity-avatars-vol-2/64/trucker-ballcap-mustache-overalls-man-512.png",
      pontos: 310
  ),
  user,
  User(
    telefone: 12999999999,
    nome: "João da Silva",
    imagem: "https://cdn3.iconfinder.com/data/icons/diversity-avatars-vol-2/64/trucker-ballcap-mustache-overalls-man-512.png",
    pontos: 125
  ),
];

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: greyColor,
      body: ListView(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        children: [
          Stack(
            children: [
              Padding(
                  padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 40.0, bottom: 20.0),
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.white,
                      child: ClipOval(
                        child: Image.network(
                            user.imagem
                        ),
                      ),
                    ),
                  )
              ),
              Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 60.0, bottom: 20.0),
                  child: IconButton(
                    icon: Icon(Icons.phone),
                    color: laranja,
                    iconSize: 35.0,
                    onPressed: (){
                      showDialog(
                          context: context,
                          builder: (BuildContext context){
                            return PopUpContatos();
                          }
                      );
                    },
                  ),
                ),
              )
            ],
          ),
          SizedBox(
            height: 5.0,
          ),
          Padding(
            padding: EdgeInsets.only(left: 10.0, right: 10.0),
            child: Card(
              color: greyColor,
              child: Padding(
                padding: EdgeInsets.all(5.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(user.nome, style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 20.0,
                        fontWeight: FontWeight.w600
                    ),),
                    SizedBox(height: 2.0,),
                    Text("Telefone: "+user.telefone.toString(), style: TextStyle(fontSize: 16.0, fontFamily: 'OpenSans',),),
                    SizedBox(height: 5.0,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset('assets/images/steps_icone.png', width: 50.0, height: 25.0,),
                        SizedBox(width: 15.0,),
                        Text("STEPS: "+user.pontos.toString(), style: TextStyle(fontSize: 16.0, fontFamily: 'OpenSans',),)
                      ],
                    )
                  ],
                ),
              )
            )
          ),
          SizedBox(height: 20.0,),
          Align(
            alignment: Alignment.topCenter,
            child: Text("Ranking dos seus amigos", style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: 20.0,
                fontWeight: FontWeight.w600
            ),),
          ),
          SizedBox(height: 20.0,),
          Container(
            height: MediaQuery.of(context).size.height*0.5,
            child: Scrollbar(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: rankTest.length,
                itemBuilder: (BuildContext context, int index){
                  Color cardColor = greyColor;
                  if(rankTest[index].telefone==user.telefone)
                    cardColor = Colors.lightGreen;
                  return Card(
                    color: cardColor,
                    child: Container(
                      height: 50.0,
                      child: Center(
                        child: Padding(
                          padding: EdgeInsets.only(left: 10.0, right: 10.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Card(
                                    color: yellowColor,
                                    child: Padding(
                                      padding: EdgeInsets.only(left: 7.0, right: 7.0, bottom: 4.0, top: 4.0),
                                      child: Text((index+1).toString(), style: TextStyle(fontSize: 14.0, fontFamily: 'OpenSans',),),
                                    ),
                                  ),
                                  SizedBox(width: 10.0,),
                                  Container(
                                    width: MediaQuery.of(context).size.width*0.5,
                                    child: Text(rankTest[index].nome, style: TextStyle(fontSize: 16.0, fontFamily: 'OpenSans',),),
                                  ),
                                ],
                              ),
                              rankTest[index].telefone!=user.telefone?
                              IconButton(
                                icon: Icon(Icons.call),
                                iconSize: 20.0,
                                color: Colors.green,
                                onPressed: (){

                                },
                              ):Container()
                            ],
                          ),
                        ),
                      )
                    )
                  );
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}
