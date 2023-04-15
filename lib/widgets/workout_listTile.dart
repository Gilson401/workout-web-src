// ignore_for_file: public_member_api_docs, sort_constructors_first
// ignore: file_names
import 'package:flutter/material.dart';
import 'package:hello_flutter/di/inject.dart';
import 'package:hello_flutter/utils/local_storage.dart';
import 'package:flutter/services.dart';
import 'package:vibration/vibration.dart';

import 'package:hello_flutter/utils/app_controller.dart';
import 'package:hello_flutter/utils/grupo_muscular.dart';
import 'package:hello_flutter/utils/workout.dart';

// import 'package:http/http.dart' as http;
import 'dart:convert';

class WorkoutListTile extends StatefulWidget {
  final Color currentColor;
  final int? currentWorkoutId;
  final Workout workout;
  final Function setWorkout;

  const WorkoutListTile({
    Key? key,
    required this.currentColor,
    required this.currentWorkoutId,
    required this.workout,
    required this.setWorkout,
  }) : super(key: key);

  @override
  State<WorkoutListTile> createState() => _WorkoutListTileState();
}

class _WorkoutListTileState extends State<WorkoutListTile> {
  final _localStorage = inject<LocalStorage>();
  final String storageKey = 'appMayWorkoutIdIdDone_';

  final _font = const TextStyle(
    fontSize: 15.0,
  );

  bool isWorkoutDoneToday = false;
  String lastDayWorkout = "";

  String currentData() {
    DateTime now = DateTime.now();
    String formattedDate =
        "${now.year.toString().padLeft(4, '0')}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";
    print(formattedDate);

    return formattedDate;
  }

  Future<void> saveWorkoutDoneDay(bool isDone) async {
    final String id = widget.workout.id.toString();
    String dateCurrent = currentData();

    setState(() {
      lastDayWorkout = isDone ? dateCurrent : "";
    });

    if (isDone) {
      _localStorage.set('$storageKey$id', dateCurrent);
    }else{
      _localStorage.set('$storageKey$id', "");
    }
  }

  Future<String?> lastDayWorkoutSaved() async {
    final String id = widget.workout.id.toString();
    String? workoutIdLastDay = await _localStorage.get('$storageKey$id');
    return workoutIdLastDay;
  }

  @override
  void initState() {
    lastDayWorkoutSaved().then((value) {
      setState(() {
        isWorkoutDoneToday = value == currentData();
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
        tileColor: widget.currentColor.withOpacity(0.99),
        selected: widget.currentWorkoutId == widget.workout.id,
        selectedTileColor: widget.currentColor,
        trailing: Switch(
          value: isWorkoutDoneToday,
          onChanged: (bool value) {
            setState(() {
              isWorkoutDoneToday = value;
            });
            saveWorkoutDoneDay(value);
          },
          activeColor: Colors.black.withOpacity(0.99),
          inactiveTrackColor: Colors.black.withOpacity(0.99),
        ),
        shape: RoundedRectangleBorder(
          side: BorderSide(width: 2, color: Color.fromARGB(255, 255, 255, 255)),
          borderRadius: BorderRadius.circular(12),
        ),
        title: Text(
          widget.workout.nome,
          textAlign: TextAlign.left,
          style: TextStyle(
              fontSize: 17, fontFamily: 'Raleway', fontWeight: FontWeight.w700),
        ),
        subtitle:
            Text("Grupo: ${widget.workout.grupoMuscular}  ", style: _font),
        leading: Padding(
            padding: EdgeInsets.all(0.5),
            child: SizedBox(
                width: MediaQuery.of(context).size.width / 7,
                child: Image.network(widget.workout.image, scale: 1))),
        onTap: () {
          widget.setWorkout(widget.workout);
        });
  }
}
