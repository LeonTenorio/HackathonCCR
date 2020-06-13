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

  LocalCredenciado.fromId({this.id});

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
    lat_lng = LatLng(lat, lng);
  }

  fromJson(Map<String, dynamic> json) {
    this.nome = json['nome'];
    this.id = json['id'];
    this.idResponsavel = json['id_responsavel'];
    this.icon = json['icon'];
    this.tipo = json['tipo'];
    this.telefone = json['telefone'];
    this.email = json['email'];
    this.endereco = json['endereco'];
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

  Future<bool> reload() async{
    var doc = await Firestore.instance.collection('LocalCredenciado').document(this.id).get();
    if(doc.exists){
      this.fromJson(doc.data);
      return true;
    }
    else
      return false;
  }

  createAvaliacao(String comentario, int nota, String idAvaliador) async{
    Avaliacao avaliacao = Avaliacao(comentario: comentario, nota: nota, idAvaliador: idAvaliador);
    await Firestore.instance.collection('LocalCredenciado').document(this.id).collection('Avaliacoes').document(avaliacao.id).setData(avaliacao.toJson());
  }

  createVantagem(String imagem, int pontos, String descricao, DateTime horaValidade, int quantidadeMaxima) async{
    Vantagens vantagens = Vantagens(imagem: imagem, idLocal: this.id, pontos: pontos, descricao: descricao, horarioCriacao: DateTime.now().toString(), horarioValidade: horaValidade.toString(), quantidadeMaxima: quantidadeMaxima);
    await Firestore.instance.collection('LocalCredenciado').document(this.id).collection('Vantagens').document(vantagens.id).setData(vantagens.toJson());
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

  Future<List<Vantagens>> getVantagens() async{
    var docs = await Firestore.instance.collection('LocalCredenciado').document(this.id).collection('Vantagens').where('horario_validade', isGreaterThanOrEqualTo: DateTime.now().toString()).orderBy('horario_validade', descending: false).getDocuments();
    List<Vantagens> ret = new List<Vantagens>();
    if(docs!=null){
      for(int i=0;i<docs.documents.length;i++){
        ret.add(Vantagens.fromJson(docs.documents[i].data));
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

class Vantagens {
  String id;
  String imagem;
  String idLocal;
  int pontos;
  String descricao;
  String horarioCriacao;
  String horarioValidade;
  int quantidadeMaxima;

  Vantagens(
      {this.imagem,
        this.idLocal,
        this.pontos,
        this.descricao,
        this.horarioCriacao,
        this.horarioValidade,
        this.quantidadeMaxima}){
    this.id = this.idLocal + this.horarioCriacao;
  }

  Vantagens.fromId({this.id, this.idLocal});

  Vantagens.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    imagem = json['imagem'];
    idLocal = json['id_local'];
    pontos = json['pontos'];
    descricao = json['descricao'];
    horarioCriacao = json['horario_criacao'];
    horarioValidade = json['horario_validade'];
    quantidadeMaxima = json['quantidade_maxima'];
  }

  fromJson(Map<String, dynamic> json) {
    this.id = json['id'];
    this.imagem = json['imagem'];
    this.idLocal = json['id_local'];
    this.pontos = json['pontos'];
    this.descricao = json['descricao'];
    this.horarioCriacao = json['horario_criacao'];
    this.horarioValidade = json['horario_validade'];
    this.quantidadeMaxima = json['quantidade_maxima'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['imagem'] = this.imagem;
    data['id_local'] = this.idLocal;
    data['pontos'] = this.pontos;
    data['descricao'] = this.descricao;
    data['horario_criacao'] = this.horarioCriacao;
    data['horario_validade'] = this.horarioValidade;
    data['quantidade_maxima'] = this.quantidadeMaxima;
    return data;
  }

  Future<bool> reload() async{
    var doc = await Firestore.instance.collection('LocalCredenciado').document(this.idLocal).collection('Vantagens').document(this.id).get();
    if(doc.exists){
      this.fromJson(doc.data);
      return true;
    }
    else
      return false;
  }
}
