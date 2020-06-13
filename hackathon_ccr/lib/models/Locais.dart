import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

/*Teste, criar documentos na abertura do app*/
/*List<LocalCredenciado> test = [
  LocalCredenciado(
    nome: "Pedágio Jacareí",
    idResponsavel: "ccr",
    telefone: "4000-1001",
    email: "ccr@test.com.br",
    icon: "https://upload.wikimedia.org/wikipedia/commons/thumb/c/cd/Grupo_CCR.svg/1200px-Grupo_CCR.svg.png",
    tipo: "pedagio",
    endereco: "Nova Dutra Km 116, Jacareí - SP",
    lat_lng: LatLng(-23.2997553,-46.0139753)
  ),
  LocalCredenciado(
      nome: "Pedágio Jacareí - acesso",
      idResponsavel: "ccr",
      telefone: "4000-1001",
      email: "ccr@test.com.br",
      icon: "https://upload.wikimedia.org/wikipedia/commons/thumb/c/cd/Grupo_CCR.svg/1200px-Grupo_CCR.svg.png",
      tipo: "pedagio",
      endereco: "Nova Dutra Km 116, Jacareí - SP",
      lat_lng: LatLng(-23.295811,-46.0264855)
  )
];*/

class LocalCredenciado {
  String nome;
  String id;
  String idResponsavel;
  String icon;
  String tipo;
  LatLng lat_lng;
  String telefone;
  String email;
  String endereco;

  LocalCredenciado({this.nome, this.idResponsavel, this.icon, this.tipo, this.lat_lng, this.telefone, this.email, this.endereco}){
    this.id = this.nome+this.idResponsavel;
  }

  LocalCredenciado.fromJson(Map<String, dynamic> json) {
    nome = json['nome'];
    id = json['id'];
    idResponsavel = json['id_responsavel'];
    icon = json['icon'];
    tipo = json['tipo'];
    telefone = json['telefone'];
    email = json['email'];
    endereco = json['endereco'];
    double lat = double.parse(json['lat'].toString());
    double lng = double.parse(json['lng'].toString());
    this.lat_lng = LatLng(lat, lng);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['nome'] = this.nome;
    data['id'] = this.id;
    data['id_responsavel'] = this.idResponsavel;
    data['telefone'] = this.telefone;
    data['email'] = this.email;
    data['icon'] = this.icon;
    data['tipo'] = this.tipo;
    data['lat'] = this.lat_lng.latitude;
    data['lng'] = this.lat_lng.longitude;
    data['endereco'] = this.endereco;
    return data;
  }

  save() async{
    await Firestore.instance.collection('LocalCredenciado').document(this.id).setData(this.toJson());
  }

  createAvaliacao(String comentario, int nota, String idAvaliador) async{
    Avaliacao avaliacao = Avaliacao(comentario: comentario, nota: nota, idAvaliador: idAvaliador);
    await Firestore.instance.collection('LocalCredenciado').document(this.id).collection('Avaliacoes').document(avaliacao.id).setData(avaliacao.toJson());
  }

  Future<List<Avaliacao>> getAvaliacoes() async{
    var docs = await Firestore.instance.collection('LocalCredenciado').document(this.id).collection('Avaliacoes').orderBy('horario', descending: true).getDocuments();
    List<Avaliacao> ret = new List<Avaliacao>();
    if(docs!=null){
      for(int i=0;i<docs.documents.length;i++){
        ret.add(Avaliacao.fromJson(docs.documents[i].data));
      }
    }
    return ret;
  }
}

class Avaliacao {
  String id;
  String comentario;
  int nota;
  String idAvaliador;
  String horario;

  Avaliacao({this.comentario, this.nota, this.idAvaliador}){
    this.horario = DateTime.now().toString();
    this.id = this.idAvaliador + this.horario;
  }

  Avaliacao.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    comentario = json['comentario'];
    nota = json['nota'];
    idAvaliador = json['id_avaliador'];
    horario = json['horario'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['comentario'] = this.comentario;
    data['nota'] = this.nota;
    data['id_avaliador'] = this.idAvaliador;
    data['horario'] = this.horario;
    return data;
  }
}