import 'package:flutter/material.dart';
import 'package:hello_flutter/di/inject.dart';
import 'package:hello_flutter/pages/workout_page.dart';
import 'package:hello_flutter/utils/app_constants.dart';
import 'package:hello_flutter/utils/date_mixins.dart';
import 'package:hello_flutter/utils/local_storage.dart';
import 'package:hello_flutter/utils/local_storage_workout_handler.dart';
import 'package:hello_flutter/utils/workout.dart';

class WorkoutListTile extends StatefulWidget {
  final Color currentColor;
  final int? currentWorkoutId;
  final Workout workout;
  final Function setWorkout;
  final Function reRenderFn;

  const WorkoutListTile({
    Key? key,
    required this.currentColor,
    required this.currentWorkoutId,
    required this.workout,
    required this.setWorkout,
    required this.reRenderFn,
  }) : super(key: key);

  @override
  State<WorkoutListTile> createState() => _WorkoutListTileState();
}

class _WorkoutListTileState extends State<WorkoutListTile> with DateFunctions {
  final _localStorage = inject<LocalStorage>();
  LocalStorageWorkoutHandler localStorageManager = LocalStorageWorkoutHandler();

  final _font = const TextStyle(
    fontSize: 15.0,
  );

  String get dateCurrent => currentData();

  Future<String?> lastDayWorkoutSaved() async {
    final String id = widget.workout.id.toString();
    String? workoutIdLastDay =
        await _localStorage.get('${AppConstants.storageWorkoutSerieDone}$id');
    return workoutIdLastDay;
  }

  @override
  void initState() {
    super.initState();
  }

  bool isTodayDone() => widget.workout.lastDayDone == dateCurrent;

  @override
  Widget build(BuildContext context) {
    
    return ListTile(
        tileColor: isTodayDone()
            ? widget.currentColor.withOpacity(0.99)
            : widget.currentColor,
        selectedTileColor: widget.currentColor.withOpacity(0.99),
        selected: widget.currentWorkoutId == widget.workout.id,
        trailing: isTodayDone()
            ? Icon(Icons.check_circle_outline)
            : Icon(Icons.circle_outlined),
        shape: RoundedRectangleBorder(
          side: BorderSide(width: 2, color: Color.fromARGB(255, 255, 255, 255)),
          borderRadius: BorderRadius.circular(12),
        ),
        title: Text(
          '${widget.workout.id} - ${widget.workout.nome}',
          textAlign: TextAlign.left,
          style: TextStyle(
              fontSize: 17, fontFamily: 'Raleway', fontWeight: FontWeight.w700),
        ),
        subtitle: ClipRect(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (widget.workout.lastDayDone != "")
                Text(widget.workout.lastDayDone, style: _font),
              SizedBox(width: 15),
              Row(
                children: [
                  for (var i = 0; i < widget.workout.seriesFeitas; i++)
                    Icon(Icons.check_circle_outline,
                        color: Colors.black, size: 16),
                ],
              )
            ],
          ),
        ),
        leading: Padding(
          padding: EdgeInsets.all(0.5),
          child: SizedBox(
              width: MediaQuery.of(context).size.width / 7,
              child: (widget.workout.image != "")
                  ? Image.network(widget.workout.image, scale: 1)
                  : Icon(Icons.image_not_supported)),
        ),
        onTap: () {
          Navigator.of(context)
              .push(
            MaterialPageRoute(
                builder: (context) => 
                
                WorkoutPage(

                      seletctedWorkout: widget.workout,
                      textStyle: const TextStyle(
                        fontSize: 15.0,
                      ),
                      reRenderFn: widget.reRenderFn,
                    )
                    
                    
                    
                    ),
          )
              .then((result) {
            widget.reRenderFn();
          });
        });
  }
}
