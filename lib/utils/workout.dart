// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:convert';
class Workout {
  String nome;
  String grupoMuscular;
  String repeticoes;
  String carga;
  String image;
  String videoId;
  List<String>? orientacoes;

  int id;
  int seriesFeitas;
  String lastDayDone = "";
  String currentCarga = "";
    

  Workout({
    required this.nome,
    required this.grupoMuscular,
    this.repeticoes = "",
    this.carga = "",
    this.image = "",
    required this.id,
    this.videoId = "",
    this.seriesFeitas = 0,
    this.orientacoes
  });

  factory Workout.fromJson(Map<String, dynamic> json) {
    
    List<String> list = List<String>.from(json['orientacoes']);

    return Workout(
      nome: json['nome'] ?? "",
      grupoMuscular: json['grupoMuscular'] ?? "",
      id: json['id'] as int,
      repeticoes: json['repeticoes'] ?? "",
      carga: json['carga'] ?? "",
      image: json['image'] ?? "",
      videoId: json['videoId'] ?? "",  
      orientacoes: list,    
    );
  }


void setCurrentCarga(String cargaValue){
  currentCarga = cargaValue;
}

void setLastDayDone(String lastDay){
  lastDayDone = lastDay;
}

void incrementSeriesFeitas(){
  seriesFeitas++;
}

void decrementSeriesFeitas(){
  seriesFeitas--;
}


///devolve um map com os dados lastDayDone seriesFeitas id currentCarga no localStorage
Map<String, dynamic> toStoreMap() {
    return <String, dynamic>{
      'lastDayDone': lastDayDone,
      'seriesFeitas': seriesFeitas,
      'id': id,
      'currentCarga': currentCarga,
    };
  }
  

///Retorna uma jsonString com os dados lastDayDone seriesFeitas id currentCarga no localStorage
String toStoreJson() => json.encode(toStoreMap());

///Recupera os dados de local storage: lastDayDone seriesFeitas id currentCarga no localStorage
 static Map<String, dynamic>  fromLocalStoredJson(String jsonParam) {
    Map<String, dynamic> json = jsonDecode(jsonParam);
    return  {
      'lastDayDone': json['lastDayDone'] ?? "",
      'id': json['id'] as int,
      'currentCarga': json['currentCarga'] ?? "",
      'seriesFeitas': json['seriesFeitas'] ?? 0,   
    };
  }


  @override
  String toString() => 'Id: $id , Nome: é $nome';
}
