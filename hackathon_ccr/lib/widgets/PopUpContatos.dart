import 'package:flutter/material.dart';

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
      title: Text("Telefones de emergência"),
      content: Container(
        width: MediaQuery.of(context).size.width*0.8,
        height: MediaQuery.of(context).size.height*0.7,
        child: Scrollbar(
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: this.contatos.length,
            itemBuilder: (BuildContext context, int index){
              return Padding(
                padding: EdgeInsets.only(top: 2.0, bottom: 2.0),
                child: Card(
                  child: Padding(
                    padding: EdgeInsets.only(top: 2.0, bottom: 2.0, right: 10.0, left: 10.0),
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
                ),
              );
            },
          ),
        ),
      ),
      actions: [
        FlatButton(
          child: Text("Ok"),
          onPressed: (){
            Navigator.pop(context);
          },
        )
      ],
    );
  }
}
