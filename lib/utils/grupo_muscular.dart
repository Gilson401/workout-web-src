import 'dart:ui';

class GrupoMuscular {
  
  final String label;
  final String image;
  final String svg;
  final Color color;

  GrupoMuscular({required this.label, this.image = "", this.svg = ""}) : color = Color.fromARGB(155, 100, 165, 250);
  GrupoMuscular.color({required this.label, this.image = "", this.svg = "", required this.color});

   @override
  String toString() => 'Label é $label , imagem é $image';
  
}