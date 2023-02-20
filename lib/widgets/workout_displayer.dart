import 'package:flutter/material.dart';
import 'package:hello_flutter/local_storage.dart';
import 'package:hello_flutter/workout.dart';

import '../di/inject.dart';

class WorkoutDisplayer extends StatefulWidget {
  const WorkoutDisplayer({
    Key? key,
    required Workout seletctedWorkout,
    required this.textStyle,
  })  : _seletctedWorkout = seletctedWorkout,
        super(key: key);

  final Workout _seletctedWorkout;
  final TextStyle textStyle;

  @override
  State<WorkoutDisplayer> createState() => _WorkoutDisplayerState();
}

class _WorkoutDisplayerState extends State<WorkoutDisplayer> {
  String? _temporaryCarga;

  final _localStorage = inject<LocalStorage>();

  final _focusNode = FocusNode();

    @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  Future<void> _setCurrentWorkoutCarga(String id) async {
    String? workoutIdStr = await _localStorage.get(id);

    if (workoutIdStr != "") {
      setState(() {
        _temporaryCarga = workoutIdStr ?? "";
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _setCurrentWorkoutCarga('appMayWorkoutIdId_${widget._seletctedWorkout.id}');
  }

  @override
  void didUpdateWidget(WorkoutDisplayer oldWidget) {
    super.didUpdateWidget(oldWidget);
    _setCurrentWorkoutCarga('appMayWorkoutIdId_${widget._seletctedWorkout.id}');
  }

  Future<void> _showModal(BuildContext context) async {
    
   await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Carga para ${widget._seletctedWorkout.nome}'),
                    SizedBox(height: 5),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            focusNode: _focusNode,
                            onChanged: (value) {
                              setState(() {
                                _temporaryCarga = value;
                              });
                              print(value);
                            },
                            onSubmitted: (String value) {
                              onSubmitCarga();
                            },
                            maxLines: 1,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        ElevatedButton(
                            onPressed: () {
                              onSubmitCarga();
                            },
                            child: Text('Define')),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    ).then((value){
      _focusNode.requestFocus();
      });


  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Text(
          'Exercício: ${widget._seletctedWorkout.nome}',
          softWrap: true,
          style: widget.textStyle,
        ),
        Text("Repetições: ${widget._seletctedWorkout.repeticoes}",
            softWrap: true),
        for (var i = 0; i < widget._seletctedWorkout.orientacoes!.length; i++)
          Text(widget._seletctedWorkout.orientacoes![i], softWrap: true),
        Text("Carga obs.: ${widget._seletctedWorkout.carga}", softWrap: true),
        Row(
          children: [
            Flexible(
              // flex: 2,
              child: ElevatedButton(
                  onPressed: () async {
                    await _showModal(context);

                    _focusNode.requestFocus();
                    
                  },
                  child: Text('Carga')),
            ),
            SizedBox(width: 5),
            Expanded(
              child: Text(_temporaryCarga ?? "", softWrap: true),
            ),
          ],
        ),
      ],
    );
  }

  void onSubmitCarga() {
    if (_temporaryCarga != null || _temporaryCarga != '') {
      _localStorage.set(
          'appMayWorkoutIdId_${widget._seletctedWorkout.id}', _temporaryCarga);
      Navigator.of(context).pop();
    }
  }
}
