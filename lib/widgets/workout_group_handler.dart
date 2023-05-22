import 'package:flutter/services.dart';
import 'package:hello_flutter/utils/grupo_muscular.dart';
import 'package:hello_flutter/utils/local_storage_workout_handler.dart';
import 'package:hello_flutter/utils/workout.dart';
import 'package:hello_flutter/utils/app_constants.dart';
import 'dart:convert';

class WorkoutGroupHandler {
  Color currentColor = Color.fromARGB(0, 255, 255, 255);

  List<GrupoMuscular> gruposMusculares = [
    GrupoMuscular.color(
        label: 'A: Peito e Ombros',
        svg: AppConstants.svgA,
        color: Color.fromARGB(155, 43, 179, 151)),
    GrupoMuscular.color(
        label: 'B: Costas e Ombro',
        svg: AppConstants.svgB,
        color: Color.fromARGB(155, 248, 252, 35)),
    GrupoMuscular.color(
        label: 'C: Pernas',
        svg: AppConstants.svgC,
        color: Color.fromARGB(155, 131, 131, 128)),
    GrupoMuscular.color(
        label: 'D: Bíceps e Tríceps',
        svg: AppConstants.svgD,
        color: Color.fromARGB(155, 243, 79, 51))
  ];

  LocalStorageWorkoutHandler localStorageWorkoutHandler =
      LocalStorageWorkoutHandler();

  List<Workout> _workoutItemsFromLocalJson = [];

  Future<void> loadDataLocal() async {
    final String response =
        await rootBundle.loadString('assets/json/series.json');

    final jsonMapFromLocalJson = await json.decode(response);

    List<dynamic> exerciciosFromJson = jsonMapFromLocalJson['exercicios'];

    List<Workout> parsedListWorkout =
        exerciciosFromJson.map((element) => Workout.fromJson(element)).toList();

    _workoutItemsFromLocalJson = parsedListWorkout;

    await _updateWithLocalStorage();
  }

  Future<void> _updateWithLocalStorage() async {
    for (Workout item in _workoutItemsFromLocalJson) {
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


  List<Workout> workoutListFromGroup(String grupoMuscular) {

    List<Workout> filtredList = _workoutItemsFromLocalJson
        .where((element) => element.grupoMuscular == grupoMuscular)
        .toList();

        return filtredList;

  }

}
