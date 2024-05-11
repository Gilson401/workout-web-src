import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hello_flutter/database/workout_database_model.dart';
import 'package:hello_flutter/utils/app_constants.dart';
import 'package:hello_flutter/utils/app_controller.dart';
import 'package:hello_flutter/utils/local_storage_workout_handler.dart';
import 'package:hello_flutter/utils/ui_helpers.dart';
import 'package:hello_flutter/utils/workout.dart';
import 'package:hello_flutter/utils/date_mixins.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';
import 'package:hello_flutter/widgets/timer_button.dart';
import 'package:hello_flutter/di/inject.dart';
import 'package:hello_flutter/widgets/workout_group_handler.dart';

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

  final _workoutGroupHandler = inject<WorkoutGroupHandler>();


  String? _temporaryCarga;
  String? _videoTitle;
  UiHelpers uiHelpers = UiHelpers();
  int _title = 0;

  int counter = 0;

  final TextEditingController _textFieldController =
      TextEditingController(text: 'Valor inicial');

  final _controller = YoutubePlayerController.fromVideoId(
    videoId: '',
    autoPlay: true,
    params: const YoutubePlayerParams(
      showFullscreenButton: true,
      mute: true,
    ),
  );

  List<Map<String, dynamic>> timers = [
    {
      'seconds': 60,
      'label': '1 min',
    },
    {
      'seconds': 90,
      'label': '1.5 min',
    },
    {'seconds': 120, 'label': '2 min'}
  ];

  @override
  void initState() {
    super.initState();

    _title = widget._seletctedWorkout.id;
    _setCurrentWorkoutCarga('appMayWorkoutIdId_${widget._seletctedWorkout.id}');

    _controller.listen((event) {
      print('LOG ${event.playerState}');

      if (event.metaData.title != "" && event.metaData.title != null) {
        setState(() => _videoTitle = event.metaData.title);
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      AppController.instance.setCanStartTimer(true);
    });
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
    setState(() => counter = 0);
  }

  final _focusNode = FocusNode();

  @override
  void dispose() {
    _focusNode.dispose();
    _controller.close();

    _textFieldController.dispose();

    super.dispose();
  }

  final popMenuKey = GlobalKey<PopupMenuButtonState>();

  Future<void> _setCurrentWorkoutCarga(String id) async {
    Map<String, dynamic>? workoutIdStr = await localStorageManager
        .mapFromLocalStoredJson(widget._seletctedWorkout);

    if (workoutIdStr != null) {
      setState(() => _temporaryCarga = workoutIdStr['currentCarga']);
    }
  }

  Future<void> _showModal(BuildContext context) async {
    _textFieldController.text = _temporaryCarga ?? "";

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
                    columSpacer(5),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _textFieldController,
                            focusNode: _focusNode,
                            onChanged: (value) {
                              setState(() => _temporaryCarga = value);
                            },
                            maxLines: null,
                            decoration: InputDecoration(
                              labelText: 'Carga do exercício',
                              border: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          ),
                        ),
                        rowSpacer(5),
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
  bool _showvideo = false;
  BoxDecoration boxNotDisponible() {
    return BoxDecoration(
      color: Colors.black.withOpacity(0.9),
      borderRadius: BorderRadius.circular(4),
    );
  }

  void resetDataForToday() {
    widget._seletctedWorkout.setLastDayDone("");
    widget._seletctedWorkout.setSeriesFeitas(0);
    localStorageManager.saveWorkoutData(widget._seletctedWorkout);
    if (widget.reRenderFn != null) {
      widget.reRenderFn!();
    }
  }

  void incrementSerie() {
    widget._seletctedWorkout.incrementSeriesFeitas();
    localStorageManager.saveWorkoutData(widget._seletctedWorkout);
    if (widget.reRenderFn != null) {
      widget.reRenderFn!();
    }

    _workoutGroupHandler.testeSt =
        widget._seletctedWorkout.seriesFeitas.toString();
  }

  Widget timerButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        for (Map<String, dynamic> element in timers)
          TimerButton(
              preIcon: Icon(Icons.add_circle_outline, color: Colors.black),
              timerLimitInSeconds: element['seconds'],
              label: element['label'],
              additionalAction: incrementSerie),
      ],
    );
  }

  List<Widget> workoutInstructions() {
    return [
      for (var i = 0; i < widget._seletctedWorkout.orientacoes!.length; i++)
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.only(right: 4.0),
                  child: Icon(Icons.info_outline, size: 20),
                ),
              ),
              Expanded(
                flex: 11,
                child: Text(widget._seletctedWorkout.orientacoes![i],
                    softWrap: true,
                    style: TextStyle(
                      fontSize: 14,
                    )),
              ),
            ],
          ),
        ),
    ];
  }

  Widget executionCounter() {
    return Row(
      children: [
        ElevatedButton(
            child: Icon(Icons.remove_circle_outline),
            onPressed: () {
              if (widget._seletctedWorkout.seriesFeitas > 0) {
                widget._seletctedWorkout.decrementSeriesFeitas();
                localStorageManager.saveWorkoutData(widget._seletctedWorkout);
                if (widget.reRenderFn != null) {
                  widget.reRenderFn!();
                }

                _workoutGroupHandler.testeSt =
                    widget._seletctedWorkout.seriesFeitas.toString();
              }
            }),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (var i = 0; i < widget._seletctedWorkout.seriesFeitas; i++)
                Icon(Icons.check_circle_outline, color: Colors.green),
            ],
          ),
        ),
        ElevatedButton(
          onPressed: () {
            incrementSerie();
          },
          child: Icon(Icons.add_circle_outline),
        )
      ],
    );
  }

  SizedBox columSpacer(double height) => SizedBox(height: height);

  SizedBox rowSpacer(double width) => SizedBox(width: width);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget._seletctedWorkout.nome,
          softWrap: true,
          maxLines: 2,
        ),
        elevation: 10,
        actions: [
          PopupMenuButton<String>(
            key: popMenuKey,
            //   onSelected: (value) {

            //  },
            itemBuilder: (BuildContext context) => [
              PopupMenuItem<String>(
                value: 'reset',
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 15.0),
                      child: GestureDetector(
                        onTap: () {
                          resetDataForToday();
                          Navigator.of(context).pop();
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: Icon(Icons.reset_tv),
                        ),
                      ),
                    ),
                    Text('Zerar Hoje'),
                  ],
                ),
              ),
              PopupMenuItem<String>(
                value: 'finished',
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Switch(
                      value:
                          widget._seletctedWorkout.lastDayDone == dateCurrent,
                      onChanged: (bool value) {
                        value
                            ? widget._seletctedWorkout
                                .setLastDayDone(dateCurrent)
                            : widget._seletctedWorkout.setLastDayDone("");

                        localStorageManager
                            .saveWorkoutData(widget._seletctedWorkout);

                        widget.reRenderFn!();
                        Navigator.of(context).pop();
                      },
                      activeColor: Color.fromARGB(255, 2, 86, 155),
                      inactiveTrackColor: Color.fromARGB(141, 13, 17, 24),
                    ),
                    Text('Tá pago'),
                  ],
                ),
              ),
            ],
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
            Container(
              margin: const EdgeInsets.only(bottom: 20),
              constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height * 0.33),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Repetições: ${widget._seletctedWorkout.repeticoes}",
                      softWrap: true,
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  columSpacer(10),
                  executionCounter(),
                  columSpacer(10),
                  Stack(
                    children: [
                      if (widget._seletctedWorkout.lastDayDone == dateCurrent)
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.95,
                          height: 200,
                          child: SvgPicture.asset(AppConstants.checked),
                        ),
                      Column(
                        children: [
                          ...workoutInstructions(),
                        ],
                      )
                    ],
                  ),
                  columSpacer(10),
                  Text("Carga obs.: ${widget._seletctedWorkout.carga}",
                      softWrap: true),
                  columSpacer(10),
                ],
              ),
            ),
            columSpacer(10),
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
                    rowSpacer(5),
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
            columSpacer(10),
            timerButtons(),
            columSpacer(10),
            if (widget._seletctedWorkout.image != "")
              Center(
                child: SizedBox(
                    height: 270,
                    child: Image.network(widget._seletctedWorkout.image)),
              ),
            columSpacer(10),
            if (widget._seletctedWorkout.videoId == "")
              AspectRatio(
                aspectRatio: 16 / 9,
                child: DecoratedBox(
                  decoration: boxNotDisponible(),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Não há vídeo definido para este item.',
                        style: TextStyle(color: Colors.white),
                      ),
                      columSpacer(30),
                      Center(
                          child: Icon(
                        Icons.videocam_off_rounded,
                        size: 100.0,
                      )),
                    ],
                  ),
                ),
              ),
            if (!_showvideo && widget._seletctedWorkout.videoId != "")
              InkWell(
                onTap: () {
                  _controller.loadVideoById(
                      videoId: widget._seletctedWorkout.videoId);
                  setState(() => _showvideo = true);
                },
                child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: DecoratedBox(
                      decoration: boxNotDisponible(),
                      child: Center(
                          child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Toque para carregar o vídeo',
                            style: TextStyle(color: Colors.white),
                          ),
                          columSpacer(30),
                          Icon(
                            Icons.smart_display,
                            size: 100.0,
                          )
                        ],
                      ))),
                ),
              ),
            if (_videoTitle != null)
              Center(
                  child: Text(_videoTitle ?? "",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 20.0))),
            if (_showvideo && widget._seletctedWorkout.videoId != "")
              SizedBox(
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

      var data = WorkoutDatabaseModel(
          carga: _temporaryCarga!,
          data: currentDateYYYYMMDD(),
          workoutId: widget._seletctedWorkout.id);


      Navigator.of(context).pop();

      uiHelpers.dialog(
          context: context, title: "Feito.", message: '''Nova carga armazenada: 
          $_temporaryCarga''');
    }
  }
}
