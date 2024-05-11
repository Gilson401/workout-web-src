import 'package:flutter/material.dart';
import 'package:hello_flutter/di/inject.dart';
import 'package:hello_flutter/home/view/widgets/workout_group_handler.dart';
import 'package:hello_flutter/home/controller/local_storage_workout_handler.dart';
import 'package:hello_flutter/home/model/workout.dart';
class SettingsPage extends StatefulWidget {
  final Function? reRenderFn;

  const SettingsPage({super.key, this.reRenderFn});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  LocalStorageWorkoutHandler localStorageManager = LocalStorageWorkoutHandler();
  
  final _workoutGroupHandler = inject<WorkoutGroupHandler>();
  List<String> _gruposMuscularUniqueLabels = [];

  Future<void> loadLocalJsonData() async {
    await _workoutGroupHandler.loadDataLocal();
    setState(() {
      _gruposMuscularUniqueLabels =
          _workoutGroupHandler.gruposMuscularUniqueLabels();
    });
  }

  Color getColorByLabel(String st) {
    Color temp = _workoutGroupHandler.gruposMusculares
        .firstWhere((element) => element.label == st)
        .color;
    return temp;
  }

  @override
  void initState() {
    loadLocalJsonData();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Configurações"),
        elevation: 10,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
        child: ListView(
          children: <Widget>[
            Text(_workoutGroupHandler.testeSt),
            SizedBox(height: 10),
            for (String st in _gruposMuscularUniqueLabels)
              Container(
                margin: const EdgeInsets.symmetric(vertical: 10.0),
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(getColorByLabel(st)),
                    padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                      EdgeInsets.all(20.0),
                    ),
                  ),
                  onPressed: () {
                    List<Workout> listWorkout =
                        _workoutGroupHandler.workoutListFromGroup(st);
                    for (Workout wk in listWorkout) {
                      wk.setSeriesFeitas(0);
                      localStorageManager.saveWorkoutData(wk);
                      if (widget.reRenderFn != null) {
                        widget.reRenderFn!();
                      }
                    }

                    // final snackBar = SnackBar(
                    //   content: Text(
                    //       'Repetições de $st foram limpas em Local Storage'),
                    //   duration: Duration(seconds: 2),
                    //   behavior: SnackBarBehavior
                    //       .floating,
                    //   margin: EdgeInsets.symmetric(
                    //       vertical: 16.0,
                    //       horizontal:
                    //           16.0),
                    // );
                    // ScaffoldMessenger.of(context).showSnackBar(snackBar);

                    showDialog(
                        context: context,
                        builder: (context) {
                          return SimpleDialog(
                            title: Text('Feito!'),
                            contentPadding: EdgeInsets.all(25),
                            children: [
                              Text(
                                  'Repetições de $st foram limpas em Local Storage'),
                              TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text('Fechar'))
                            ],
                          );
                        });
                  },
                  child: Text('Limpar repetições de $st'),
                ),
              ),
            SizedBox(height: 10),
           

          ],
        ),
      ),
    );
  }
}
