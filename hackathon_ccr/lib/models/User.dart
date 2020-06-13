import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';

class User {
  int telefone;
  String nome;
  String imagem;
  List<String> membrosFamilia;
  List<int> membrosTelefones;
  int pontos;

  User(
      {this.telefone,
        this.nome,
        this.imagem,
        this.membrosFamilia,
        this.membrosTelefones,
        this.pontos}){
    if(this.membrosFamilia==null)
      this.membrosFamilia = new List<String>();
    if(this.membrosTelefones==null)
      this.membrosTelefones = new List<int>();
    if(this.pontos==null)
      this.pontos = 0;
  }

  User.fromJson(Map<String, dynamic> json) {
    telefone = json['telefone'];
    nome = json['nome'];
    imagem = json['imagem'];
    membrosFamilia = json['membros_familia'].cast<String>();
    membrosTelefones = json['membros_telefones'].cast<int>();
    pontos = json['pontos'];
  }

  fromJson(Map<String, dynamic> json) {
    this.telefone = json['telefone'];
    this.nome = json['nome'];
    this.imagem = json['imagem'];
    this.membrosFamilia = json['membros_familia'].cast<String>();
    this.membrosTelefones = json['membros_telefones'].cast<int>();
    this.pontos = json['pontos'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['telefone'] = this.telefone;
    data['nome'] = this.nome;
    data['imagem'] = this.imagem;
    data['membros_familia'] = this.membrosFamilia;
    data['membros_telefones'] = this.membrosTelefones;
    data['pontos'] = this.pontos;
    return data;
  }

  save() async{
    await Firestore.instance.collection('Users').document(this.telefone.toString()).setData(this.toJson());
  }

  Future<bool> reload() async{
    var doc = await Firestore.instance.collection('Users').document(this.telefone.toString()).get();
    if(doc.exists){
      this.fromJson(doc.data);
      return true;
    }
    else
      return false;
  }
}
