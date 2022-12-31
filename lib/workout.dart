class Workout {
  String nome;
  String grupoMuscular;
  String repeticoes;
  String carga;
  String image;
  String videoId;
  // List<String> orientacoes;

  Workout({
    required this.nome,
    required this.grupoMuscular,
    this.repeticoes = "",
    this.carga = "",
    this.image = "",
    this.videoId = "",

  });

  factory Workout.fromJson(Map<String, dynamic> json) {
    return Workout(
      nome: json['nome'] as String,
      grupoMuscular: json['grupoMuscular'] as String,
      repeticoes: json['repeticoes'] as String,
      carga: json['carga'] as String,
      image: json['image'] as String,
      videoId: json['videoId'] as String,      
    );
  }

  @override
  String toString() => 'nome é $nome , grupoMuscular é $grupoMuscular';
}
