import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:hackathon_ccr/main.dart';
import 'package:hackathon_ccr/models/Locais.dart';

class ReadBuy extends StatefulWidget {
  @override
  _ReadBuyState createState() => _ReadBuyState();
}

class _ReadBuyState extends State<ReadBuy> {
  @override
  initState(){
    super.initState();
    //this.isLoading = true;
    //searchQrCodeSource("Pedágio Jacareíccr");
  }

  @override
  dispose(){
    super.dispose();
  }

  searchQrCodeSource(String barCode) async{
    try{
      List<String> params = barCode.split("; ");
      LocalCredenciado loadingLocal = LocalCredenciado.fromId(id: params[0]);
      if(await loadingLocal.reload()){
        this.local = loadingLocal;
      }
      if(params.length>1){
        Vantagens loadingVantagem = Vantagens.fromId(id: params[1], idLocal: params[0]);
        if(await loadingVantagem.reload()){
          this.vantagem = loadingVantagem;
        }
      }
      setState(() {
        isLoading = false;
        confirmar = true;
      });
    }
    catch(e){
      local = null;
      vantagem = null;
      setState(() {
        isLoading = false;
      });
    }
  }

  bool isLoading = false;
  bool confirmar = false;

  LocalCredenciado local;
  Vantagens vantagem;

  @override
  Widget build(BuildContext context) {
    if(isLoading){
      return Scaffold(
        backgroundColor: greyColor,
          body: Padding(
            padding: EdgeInsets.only(left: 10.0, right: 10.0),
            child: Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
              ),
            )
          )
      );
    }
    else if(confirmar){
      return Scaffold(
        backgroundColor: greyColor,
          body: Padding(
            padding: EdgeInsets.only(left: 10.0, right: 10.0),
            child: ListView(
              shrinkWrap: true,
              children: [
                Padding(
                    padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 5.0, bottom: 5.0),
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: CircleAvatar(
                        radius: 50,
                        backgroundColor: greyColor,
                        child: ClipOval(
                          child: Image.network(
                              this.local.icon
                          ),
                        ),
                      ),
                    )
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
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Local: "+this.local.nome, style: TextStyle(
                                  fontFamily: 'Roboto',
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.w600
                              ),),
                              SizedBox(height: 2.0,),
                              Text("Telefone: "+this.local.telefone, style: TextStyle(fontSize: 16.0, fontFamily: 'OpenSans',),),
                              SizedBox(height: 5.0,),
                              Text("Endereço: "+this.local.endereco, style: TextStyle(fontSize: 16.0, fontFamily: 'OpenSans',),),
                              SizedBox(height: 5.0,),
                            ],
                          ),
                        )
                    )
                ),
                this.vantagem!=null?
                Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(3.0),
                      child: Card(
                        color: greyColor,
                        child: Padding(
                          padding: EdgeInsets.all(5.0),
                          child: ListView(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            children: [
                              Image.network(this.vantagem.imagem, fit: BoxFit.contain, height: 150.0, alignment: Alignment.topCenter,),
                              SizedBox(height: 2.0,),
                              Text(this.vantagem.descricao, style: TextStyle(fontSize: 14.0, fontFamily: 'OpenSans',), textAlign: TextAlign.start, ),
                              SizedBox(height: 7.0,),
                              Text("STEPS: "+this.vantagem.pontos.toString(), style: TextStyle(fontSize: 14.0, fontFamily: 'OpenSans',),)
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 10.0),
                      child: Material(
                        borderRadius: BorderRadius.circular(25.0),
                        child: MaterialButton(
                          color: redColor,
                          height: 60.0,
                          minWidth: MediaQuery.of(context).size.width,
                          child: Center(
                            child: Text(
                                "Usar STEPS",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontFamily: 'Roboto',
                                    fontSize: 20.0,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600
                                )
                            ),
                          ),
                          onPressed: (){
                            setState(() {
                              confirmar = false;
                            });
                          },
                        ),
                      ),
                    )
                  ],
                ):
                Padding(
                  padding: EdgeInsets.only(top: 10.0),
                  child: Material(
                    borderRadius: BorderRadius.circular(25.0),
                    child: MaterialButton(
                      color: redColor,
                      height: 60.0,
                      minWidth: MediaQuery.of(context).size.width,
                      child: Center(
                        child: Text(
                            "Registrar compra",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontFamily: 'Roboto',
                                fontSize: 20.0,
                                color: Colors.white,
                                fontWeight: FontWeight.w600
                            )
                        ),
                      ),
                      onPressed: (){
                        setState(() {
                          confirmar = false;
                        });
                      },
                    ),
                  ),
                ),
                SizedBox(height: 30.0,)
              ],
            ),
          )
      );
    }
    else{
      return Scaffold(
          body: Padding(
            padding: EdgeInsets.only(left: 10.0, right: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Leia o código de um dos nossos parceiros", style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 20.0,
                    fontWeight: FontWeight.w600
                ), textAlign: TextAlign.center,),
                SizedBox(height: 50.0,),
                IconButton(
                  icon: Icon(Icons.camera_alt),
                  iconSize: 75.0,
                  color: redColor,
                  onPressed: () async{
                    var result = await BarcodeScanner.scan();
                    print(result.rawContent); // The barcode content
                    searchQrCodeSource(result.rawContent);
                  },
                )
              ],
            ),
          )
      );
    }
  }
}
