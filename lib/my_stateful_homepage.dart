import 'package:flutter/material.dart';
import 'package:hello_flutter/timerPeriodic.dart';
import 'package:hello_flutter/timer_button.dart';
import 'package:hello_flutter/workout.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';
import 'apiItemsList.dart';
import 'clockTime_page.dart';
import 'widgets/workout_displayer.dart';

class MyStatefullHomePage extends StatefulWidget {
  const MyStatefullHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyStatefullHomePage> createState() => _MyStatefullHomePageState();
}

class _MyStatefullHomePageState extends State<MyStatefullHomePage> {
  Workout _seletctedWorkout = Workout(
      nome: 'Selecione um exercício', grupoMuscular: '', orientacoes: [], id: 0);



  final _controller = YoutubePlayerController.fromVideoId(
    videoId: '',
    autoPlay: true,
    params: const YoutubePlayerParams(
      showFullscreenButton: true,
      mute: true,
    ),
  );

  void setCurrentWorkout(Workout workout) async {
    setState(() {
      _seletctedWorkout = workout;
    });

    _controller.loadVideoById(videoId: workout.videoId);

    _controller.pauseVideo();
  }

  @override
  void initState() {
    super.initState();
  }

  TimePeriodic timePeriodic60 =
      TimePeriodic(stopTimer: true, currentSeconds: 0, timerMaxSeconds: 60);

  TimePeriodic timePeriodic90 =
      TimePeriodic(stopTimer: true, currentSeconds: 0, timerMaxSeconds: 90);

  TimePeriodic timePeriodic120 =
      TimePeriodic(stopTimer: true, currentSeconds: 0, timerMaxSeconds: 120);

  void stopAllTimers() {
    timePeriodic120.stopTimer = true;
    timePeriodic90.stopTimer = true;
    timePeriodic60.stopTimer = true;
  }

  @override
  Widget build(BuildContext context) {
    var apiItemsList = ApiItemsList(setWorkout: setCurrentWorkout);
    var textStyle = TextStyle(
        fontFamily: 'Raleway',
        fontWeight: FontWeight.w700);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        elevation: 10,
      ),
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Column(
                children: [
                  apiItemsList,
                  Container(
                    color: Color.fromARGB(255, 255, 255, 255),
                    height: 350,
                    width: MediaQuery.of(context).size.width,
                    margin: const EdgeInsets.all(2),
                    padding: const EdgeInsets.all(5),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            SizedBox(
                              height: 300,
                              width: MediaQuery.of(context).size.width,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: WorkoutDisplayer(seletctedWorkout: _seletctedWorkout, textStyle: textStyle),
                              ),
                            ),
                            if (_seletctedWorkout.image != "")
                              SizedBox(
                                height: 300,
                                width: MediaQuery.of(context).size.width,
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height: 30,
                                      width: MediaQuery.of(context).size.width,
                                      child: Text(
                                        'Exercício: ${_seletctedWorkout.nome}',
                                        softWrap: true,
                                        style: textStyle,
                                      ),
                                    ),
                                    SizedBox(
                                        height: 270,
                                        child: Image.network(
                                            _seletctedWorkout.image)),
                                  ],
                                ),
                              ),
                            if (_seletctedWorkout.videoId != "")
                              SizedBox(
                                height: 300,
                                width: MediaQuery.of(context).size.width,
                                child: YoutubePlayer(
                                  controller: _controller,
                                  aspectRatio: 16 / 9,
                                  backgroundColor:
                                      Color.fromARGB(255, 35, 35, 87),
                                ),
                              ),
                          ]),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        elevation: 10,
        color: Colors.white,
        child: IconTheme(
            data: IconThemeData(color: Theme.of(context).colorScheme.onPrimary),
            child: Row(
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
            )),
      ),
    );
  }
}

