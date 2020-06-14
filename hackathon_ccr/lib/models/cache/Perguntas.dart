import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

final List<String> perguntas = [
  "Está se sentindo bem?",
  "Dormiu bem?",
  "Está cansado?"
];

final String cacheKey = "perguntas";

String getKeyDia(DateTime dia){
  return dia.day.toString() +"-"+dia.month.toString()+"-"+dia.year.toString();
}

class DadosPerguntas{
  static Future<Map<String, dynamic>> openCache() async{
    final cacheRef = await SharedPreferences.getInstance();
    Map<String, dynamic> ret = <String, dynamic>{};
    if(cacheRef.containsKey(cacheKey)){
      ret = json.decode(cacheRef.getString(cacheKey));
    }
    return ret;
  }
  
  static storeCache(Map<String, dynamic> jsonCache) async{
    final cacheRef = await SharedPreferences.getInstance();
    await cacheRef.setString(cacheKey, json.encode(jsonCache));
  }
  
  static Future<List<String>> getProximasPerguntas(DateTime dia) async{
    List<String> ret = perguntas;
    Map<String, dynamic> respondido = await DadosPerguntas.openCache();
    if(respondido.containsKey(getKeyDia(dia))){
      Map<String, dynamic> perguntasDia = respondido[getKeyDia(dia)];
      ret = new List<String>();
      for(int i=0;i<perguntas.length;i++){
        if(!perguntasDia.keys.toList().contains(perguntas[i]))
          ret.add(perguntas[i]);
      }
    }
    return ret;
  }
  
  static responderPerguntas(DateTime dia, List<String> perguntas, List<String> respostas) async{
    Map<String, dynamic> respondido = await DadosPerguntas.openCache();
    if(!respondido.containsKey(getKeyDia(dia))){
      respondido[getKeyDia(dia)] = <String, dynamic>{};
    }
    for(int i=0;i<perguntas.length;i++){
      respondido[getKeyDia(dia)][perguntas[i]] = respostas[i];
    }
    await storeCache(respondido);
  }
}