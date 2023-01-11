class Workout {
  String nome;
  String grupoMuscular;
  String repeticoes;
  String carga;
  String image;
  String videoId;
  bool _done = false;
  List<String>? orientacoes;

  Workout({
    required this.nome,
    required this.grupoMuscular,
    this.repeticoes = "",
    this.carga = "",
    this.image = "",
    this.videoId = "",
    this.orientacoes
  });

  factory Workout.fromJson(Map<String, dynamic> json) {
    
    List<String> list = List<String>.from(json['orientacoes']);

    return Workout(
      nome: json['nome'] as String,
      grupoMuscular: json['grupoMuscular'] as String,
      repeticoes: json['repeticoes'] as String,
      carga: json['carga'] as String,
      image: json['image'] as String,
      videoId: json['videoId'] as String,  
      orientacoes: list,    
    );
  }

void toggleDone(){
  _done = !_done;
}

bool get getStatus {
  return _done;
}

  @override
  String toString() => 'nome é $nome , grupoMuscular é $grupoMuscular';
}
