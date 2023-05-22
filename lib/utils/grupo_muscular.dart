import 'dart:ui';
import 'package:hello_flutter/utils/workout.dart';
class GrupoMuscular {
  
  final String label;
  final String image;
  final String svg;
  final Color color;
final List<Workout>? workoutList ;
  GrupoMuscular({this.workoutList, required this.label, this.image = "", this.svg = ""}) : color = Color.fromARGB(155, 100, 165, 250);
  GrupoMuscular.color({this.workoutList , required this.label, this.image = "", this.svg = "", required this.color});

   @override
  String toString() => 'Label é $label , imagem é $image';
  
}