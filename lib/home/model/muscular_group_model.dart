import 'dart:ui';
import 'package:hello_flutter/home/model/workout_model.dart';

class MuscularGroupModel {
  final String label;
  final String image;
  final String svg;
  final Color color;
  final List<WorkoutModel>? workoutList;
  MuscularGroupModel(
      {this.workoutList, required this.label, this.image = "", this.svg = ""})
      : color = Color.fromARGB(155, 100, 165, 250);
  MuscularGroupModel.color(
      {this.workoutList,
      required this.label,
      this.image = "",
      this.svg = "",
      required this.color});

  @override
  String toString() => 'Label é $label , imagem é $image';
}
