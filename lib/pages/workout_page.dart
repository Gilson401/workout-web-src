import 'package:flutter/material.dart';
import 'package:hello_flutter/utils/local_storage_workout_handler.dart';
import 'package:hello_flutter/utils/workout.dart';
import 'package:hello_flutter/utils/date_mixins.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';
import 'package:hello_flutter/widgets/timer_button.dart';
import 'package:hello_flutter/widgets/clocktimer_page.dart';


class WorkoutPage extends StatefulWidget {
  final Workout _seletctedWorkout;
  final TextStyle textStyle;
  final Function? reRenderFn;

  const WorkoutPage({
    Key? key,
    this.reRenderFn,
    required Workout seletctedWorkout,
    required this.textStyle,
  })  : _seletctedWorkout = seletctedWorkout,
        super(key: key);

  @override
  State<WorkoutPage> createState() => _WorkoutPageState();
}

class _WorkoutPageState extends State<WorkoutPage> with DateFunctions {

  LocalStorageWorkoutHandler localStorageManager = LocalStorageWorkoutHandler();

  String? _temporaryCarga;
  int _title = 0;

  int counter = 0;

  final _controller = YoutubePlayerController.fromVideoId(
    videoId: '',
    autoPlay: true,
    params: const YoutubePlayerParams(
      showFullscreenButton: true,
      mute: true,
    ),
  );

  void setCurrentWorkout() async {
    _controller.loadVideoById(videoId: widget._seletctedWorkout.videoId);
    _controller.pauseVideo();
  }

  @override
  void initState() {
    super.initState();
    _title = widget._seletctedWorkout.id;
    _setCurrentWorkoutCarga('appMayWorkoutIdId_${widget._seletctedWorkout.id}');
    setCurrentWorkout();
  }

  @override
  void didUpdateWidget(WorkoutPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    _setCurrentWorkoutCarga('appMayWorkoutIdId_${widget._seletctedWorkout.id}');
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    int newTitle = widget._seletctedWorkout.id;
    if (newTitle != _title) {
      resetCounter();
    }
  }

  void resetCounter() {
    localStorageManager.saveWorkoutData(widget._seletctedWorkout);

    setState(() {
      counter = 0;
    });
  }

  

  final _focusNode = FocusNode();

  @override
  void dispose() {
    _focusNode.dispose();
    _controller.close();
    super.dispose();
  }

  Future<void> _setCurrentWorkoutCarga(String id) async {
    Map<String, dynamic>? workoutIdStr = await localStorageManager
        .mapFromLocalStoredJson(widget._seletctedWorkout);

    if (workoutIdStr != null) {
      setState(() {
        _temporaryCarga = workoutIdStr['currentCarga'];
      });
    }
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
    ).then((value) {
      _focusNode.requestFocus();
    });
  }

String get dateCurrent => currentData();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget._seletctedWorkout.nome),
        elevation: 10,
        actions: [
          Switch(
          value: widget._seletctedWorkout.lastDayDone == dateCurrent,
          onChanged: (bool value) {
            if (value) {
              widget._seletctedWorkout.setLastDayDone(dateCurrent);
            } else {
              widget._seletctedWorkout.setLastDayDone("");
            }
            localStorageManager.saveWorkoutData(widget._seletctedWorkout);
            widget.reRenderFn!();
          },
          activeColor: Color.fromARGB(255, 2, 86, 155),
          inactiveTrackColor: Color.fromARGB(141, 13, 17, 24),
        ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(10.0),
        physics: const BouncingScrollPhysics(),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            // TEXTO DO EXERCICIO:

            Container(
              margin: const EdgeInsets.only(bottom: 20),
              constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height * 0.33),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Repetições: ${widget._seletctedWorkout.repeticoes}",
                      softWrap: true),
                  SizedBox(height: 10),
                              //Botões de repetições feitas
            Row(
              children: [
                ElevatedButton.icon(
                    onPressed: () {
                      if (widget._seletctedWorkout.seriesFeitas > 0) {
                        widget._seletctedWorkout.decrementSeriesFeitas();
                        localStorageManager
                            .saveWorkoutData(widget._seletctedWorkout);
                        if (widget.reRenderFn != null) {
                          widget.reRenderFn!();
                        }
                      }
                    },
                    icon: Icon(Icons.remove_circle_outline),
                    label: Container()),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      for (var i = 0;
                          i < widget._seletctedWorkout.seriesFeitas;
                          i++)
                        Icon(Icons.check_circle_outline, color: Colors.green),
                    ],
                  ),
                ),
                ElevatedButton.icon(
                    //ADICIONA REPETICAO########################
                    onPressed: () {
                      widget._seletctedWorkout.incrementSeriesFeitas();
                      localStorageManager
                          .saveWorkoutData(widget._seletctedWorkout);
                      if (widget.reRenderFn != null) {
                        widget.reRenderFn!();
                      }
                    },
                    icon: Icon(Icons.add_circle_outline),
                    label: Container())
              ],
            ),

             SizedBox(height: 10),

                  for (var i = 0;
                      i < widget._seletctedWorkout.orientacoes!.length;
                      i++)
                    Text(widget._seletctedWorkout.orientacoes![i],
                        softWrap: true),
                  SizedBox(height: 10),
                  Text("Carga obs.: ${widget._seletctedWorkout.carga}",
                      softWrap: true),
                ],
              ),
            ),


            SizedBox(height: 10),

            // Marcador da carga atual
            DecoratedBox(
              decoration: BoxDecoration(
                color: Colors.blue.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(_temporaryCarga ?? "", softWrap: true),
                    ),
                    SizedBox(width: 5),
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () async {
                        await _showModal(context);
                        _focusNode.requestFocus();
                      },
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 10),

            //Timmer Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                  tooltip: 'Descanso',
                  icon: const Icon(Icons.timer),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => ClockTimerPage()),
                    );
                  },
                ),
                TimerButton(timerLimitInSeconds: 60, label: '1 min'),
                TimerButton(timerLimitInSeconds: 90, label: '1.5 min'),
                TimerButton(timerLimitInSeconds: 120, label: '2 min'),
              ],
            ),
            SizedBox(height: 10),

            //Foto do exercício ##################################:
            if (widget._seletctedWorkout.image != "")
              DecoratedBox(
                decoration: BoxDecoration(),
                child: Center(
                  child: SizedBox(
                      height: 270,
                      child: Image.network(widget._seletctedWorkout.image)),
                ),
              ),

            SizedBox(height: 10),

            //Youtube VideoPayer ######################################
            if (widget._seletctedWorkout.videoId != "")
              SizedBox(
                // height: 300,
                width: MediaQuery.of(context).size.width,
                child: YoutubePlayer(
                  controller: _controller,
                  aspectRatio: 16 / 9,
                  backgroundColor: Color.fromARGB(255, 35, 35, 87),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void onSubmitCarga() {
    if (_temporaryCarga != null || _temporaryCarga != '') {
      widget._seletctedWorkout.setCurrentCarga(_temporaryCarga!);
      localStorageManager.saveWorkoutData(widget._seletctedWorkout);
      Navigator.of(context).pop();
    }
  }
}
