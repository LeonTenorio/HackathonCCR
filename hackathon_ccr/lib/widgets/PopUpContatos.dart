import 'package:flutter/material.dart';
import 'package:hackathon_ccr/main.dart';

class PopUpContatos extends StatelessWidget {
  List<List<String>> contatos = [
    ["Policia Militar", "190"],
    ["Polícia Rodoviária Federal", "191"],
    ["SAMU", "192"],
    ["Corpo de Bombeiros", "193"],
    ["Polícia Rodoviária Estadual", "198"]
  ];

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: greyColor,
      title: Text("Telefones de emergência", style: TextStyle(fontFamily: "Roboto"),),
      content: Container(
        width: MediaQuery.of(context).size.width*0.9,
        height: MediaQuery.of(context).size.height*0.5,
        child: Scrollbar(
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: this.contatos.length,
            itemBuilder: (BuildContext context, int index){
              return Padding(
                padding: EdgeInsets.only(top: 3.0, bottom: 3.0, right: 10.0, left: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width*0.6-45.0,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(this.contatos[index][0], style: TextStyle(
                              fontFamily: 'OpenSans',
                              fontSize: 16.0,
                              fontWeight: FontWeight.w600
                          ),),
                          SizedBox(height: 2.0,),
                          Text(this.contatos[index][1], style: TextStyle(
                            fontFamily: 'OpenSans',
                            fontSize: 16.0,
                          ),)
                        ],
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.phone),
                      color: redColor,
                      iconSize: 25.0,
                      onPressed: (){

                      },
                    )
                  ],
                )
              );
            },
          ),
        ),
      ),
      actions: [
        FlatButton(
          child: Text("Ok", style: TextStyle(color: redColor, fontFamily: "OpenSans"),),
          onPressed: (){
            Navigator.pop(context);
          },
        )
      ],
    );
  }
}
