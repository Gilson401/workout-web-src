import 'package:flutter/services.dart';
import 'package:hello_flutter/home/model/muscular_group_model.dart';
import 'package:hello_flutter/home/repository/local_storage_workout_handler.dart';
import 'package:hello_flutter/home/model/workout_model.dart';
import 'package:hello_flutter/utils/app_constants.dart';
import 'dart:convert';

class WorkoutGroupHandler {
  Color currentColor = Color.fromARGB(0, 255, 255, 255);

  String testeSt = '';

  List<MuscularGroupModel> gruposMusculares = [
    MuscularGroupModel.color(
        label: 'A: Peito e Ombros',
        svg: AppConstants.svgA,
        color: Color.fromARGB(155, 43, 179, 151)),
    MuscularGroupModel.color(
        label: 'B: Costas e Ombro',
        svg: AppConstants.svgB,
        color: Color.fromARGB(155, 248, 252, 35)),
    MuscularGroupModel.color(
        label: 'C: Pernas',
        svg: AppConstants.svgC,
        color: Color.fromARGB(155, 131, 131, 128)),
    MuscularGroupModel.color(
        label: 'D: Bíceps e Tríceps',
        svg: AppConstants.svgD,
        color: Color.fromARGB(155, 243, 79, 51))
  ];

  LocalStorageWorkoutHandler localStorageWorkoutHandler =
      LocalStorageWorkoutHandler();

  List<WorkoutModel> _workoutItemsFromLocalJson = [];

  Future<void> loadDataLocal(List<dynamic> exerciciosFromJson) async {

    List<WorkoutModel> parsedListWorkout =
        exerciciosFromJson.map((element) => WorkoutModel.fromJson(element)).toList();

    _workoutItemsFromLocalJson = parsedListWorkout;

    await _updateWithLocalStorage();
    
  }

  Future<void> _updateWithLocalStorage() async {
    for (WorkoutModel item in _workoutItemsFromLocalJson) {
      await localStorageWorkoutHandler.updateWorkoutWithStoredLocalData(item);
    }
  }

  List<dynamic> gruposMusc() {
    return _workoutItemsFromLocalJson
        .map((exercicio) => exercicio.grupoMuscular)
        .toList();
  }

  List<String> gruposMuscularUniqueLabels() {
    List<String> temp = _workoutItemsFromLocalJson
        .map((exercicio) => exercicio.grupoMuscular)
        .toList();

    Set<String> conjunto = Set.from(temp);

    List<String> uniqueValuesList = conjunto.toList();

    return uniqueValuesList;
  }


  List<WorkoutModel> workoutListFromGroup(String grupoMuscular) {

    List<WorkoutModel> filtredList = _workoutItemsFromLocalJson
        .where((element) => element.grupoMuscular == grupoMuscular)
        .toList();

        return filtredList;

  }

}
