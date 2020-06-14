import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hackathon_ccr/functions/HexColor.dart';
import 'package:hackathon_ccr/models/User.dart';
import 'package:hackathon_ccr/screens/MapScreen.dart';
import 'package:hackathon_ccr/screens/NavigatorMenu.dart';
import 'package:hackathon_ccr/screens/PopUpPerguntas.dart';
import 'package:hackathon_ccr/widgets/PopUpContatos.dart';
import '../main.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => new _LoginState();
}

class _LoginState extends State<Login> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  final telefone = TextEditingController();
  final pwdController = TextEditingController();

  static String errorMessage = "";

  static bool isLoading = false;

  reloadAndNextScreen() async{
    try{
      user = User(telefone: int.tryParse(telefone.text));
      if(await user.reload()){
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => NavigationMenu()), (route) => false);
        showDialog(
          context: context,
          builder: (BuildContext context){
            return PopUpPerguntas();
          }
        );
      }
      else{
        errorMessage = "Cadastre-se";
        setState(() {
          isLoading = false;
        });
      }
    }
    catch(e){
      setState(() {
        errorMessage = "Número de telefone inválido, apenas números por favor";
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: greyColor,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          !isLoading ?
          Container(
              child: Padding(
                padding: EdgeInsets.only(left: 20.0, right: 20.0),
                child: Column(
                  children: <Widget>[
                    Padding(
                        padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 80.0, bottom: 60.0),
                        child: Align(
                          alignment: Alignment.topCenter,
                          child: Image.asset(
                            "assets/images/banner_rubens.png",
                            width: 270,
                          ),
                        )
                    ),
                    Text(
                      errorMessage,
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 18.0,
                        fontFamily: 'OpenSans',
                      ),
                    ),
                    SizedBox(height: 10.0),
                    TextFormField(
                      obscureText: false,
                      controller: telefone,
                      keyboardType: TextInputType.phone,
                      style: TextStyle(fontFamily: 'Roboto', fontSize: 18.0),
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(20.0, 16.0, 20.0, 16.0),
                        hintText: "Telefone",
                        filled: true,
                        fillColor: const Color(0xFFF0F0F0),
                        hintStyle: TextStyle(
                            color: const Color(0xFFa6a6a6),
                            fontSize: 18.0
                        ),
                        border: OutlineInputBorder(
                            borderSide: BorderSide(color: const Color(0xFFe6e6e6), width: 0.5),
                            borderRadius: BorderRadius.circular(8.0)
                        ),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: const Color(0xFFe6e6e6), width: 0.5),
                            borderRadius: BorderRadius.circular(8.0)
                        ),
                      ),
                    ),
                    SizedBox(height: 12.0,),
                    TextFormField(
                      controller: pwdController,
                      obscureText: true,
                      style: TextStyle(fontFamily: 'Roboto', fontSize: 18.0),
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(20.0, 16.0, 20.0, 16.0),
                        hintText: "Senha",
                        filled: true,
                        fillColor: const Color(0xFFF0F0F0),
                        hintStyle: TextStyle(
                            color: const Color(0xFFa6a6a6),
                            fontSize: 18.0
                        ),
                        border: OutlineInputBorder(
                            borderSide: BorderSide(color: const Color(0xFFe6e6e6), width: 0.5),
                            borderRadius: BorderRadius.circular(8.0)
                        ),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: const Color(0xFFe6e6e6), width: 0.5),
                            borderRadius: BorderRadius.circular(8.0)
                        ),
                      ),
                    ),
                    SizedBox(height: 30.0,),
                    Material(
                      borderRadius: BorderRadius.circular(25.0),
                      child: MaterialButton(
                        color: laranja,
                        height: 60.0,
                        minWidth: MediaQuery.of(context).size.width,
                        child: Center(
                          child: Text(
                              "Entrar",
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
                          if(this.telefone.text.length==0){
                            setState(() {
                              errorMessage = "Insira um telefone";
                            });
                          }
                          else if(this.pwdController.text.length==0){
                            setState(() {
                              errorMessage = "Insira sua senha";
                            });
                          }
                          else{
                            setState(() {
                              isLoading = true;
                              errorMessage = "";
                            });
                            reloadAndNextScreen();
                          }
                        },
                      ),
                    ),
                    SizedBox(height: 50.0,),
                    !isLoading?
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: <Widget>[
                          InkWell(
                            child: Text(
                                "Esqueci minha senha",
                                style: TextStyle(
                                    fontFamily: 'Roboto',
                                    fontSize: 17.0,
                                    fontWeight: FontWeight.w600
                                )
                            ),
                            onTap: () {

                            },
                          ),
                          SizedBox(height: 15.0,),
                          InkWell(
                            child: Text(
                                "Ainda não tenho uma conta",
                                style: TextStyle(
                                    fontFamily: 'Roboto',
                                    fontSize: 17.0,
                                    fontWeight: FontWeight.w600
                                )
                            ),
                            onTap: () {

                            },
                          ),
                          SizedBox(height: 15.0,),
                        ],
                      ),
                    )
                        :Container(),
                    SizedBox(height: 10.0,),
                    !isLoading?
                    Column(
                      children: [
                        InkWell(
                          child: Text(
                              "CONTATOS",
                              style: TextStyle(
                                  fontFamily: 'Roboto',
                                  fontSize: 17.0,
                                  fontWeight: FontWeight.w600
                              )
                          ),
                          onTap: () {
                            showDialog(
                                context: context,
                                builder: (BuildContext context){
                                  return PopUpContatos();
                                }
                            );
                          },
                        ),
                        SizedBox(height: 25.0,),
                      ],
                    ):
                    Container(),
                  ],
                ),
              )
          )
              : loading(),
          !isLoading?
          Container(
            child: Text(
                "2020 © Hackathon CCR - RUBENS App",
                style: TextStyle(
                    fontFamily: "Roboto",
                    fontSize: 12.0,
                    color: Color(0xFF272727)
                )
            ),
          ):
          Container()
        ],
      ),
    );
  }

  Widget loading() {
    return Container(
      height: MediaQuery.of(context).size.height / 2,
      child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
              ),
              SizedBox(height: 20.0,),
              Text(
                "Autenticando",
                style: TextStyle(
                    color: Colors.red,
                    fontSize: 22.0,
                    fontFamily: 'OpenSans',
                ),
              )
            ],
          )
      ),
    );
  }
}
