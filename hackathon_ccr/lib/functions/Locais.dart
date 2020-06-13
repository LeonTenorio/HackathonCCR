import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hackathon_ccr/models/Locais.dart';
import 'dart:async';

Future<List<LocalCredenciado>> getLocaisCredenciados() async{
  var docs = await Firestore.instance.collection('LocalCredenciado').getDocuments();
  List<LocalCredenciado> ret = new List<LocalCredenciado>();
  if(docs!=null){
    for(int i=0;i<docs.documents.length;i++){
      ret.add(LocalCredenciado.fromJson(docs.documents[i].data));
    }
  }
  return ret;
}