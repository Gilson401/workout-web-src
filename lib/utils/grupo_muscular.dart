import 'dart:ui';

class GrupoMuscular {
  
  final String label;
  final String image;
  final Color color;

  GrupoMuscular(this.label, this.image) : color = Color.fromARGB(155, 100, 165, 250);
  GrupoMuscular.color(this.label, this.image, this.color);

   @override
  String toString() => 'Label é $label , imagem é $image';
  
}