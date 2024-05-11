import 'package:flutter/material.dart';


import 'package:hello_flutter/pages/settings_page.dart';
import 'package:hello_flutter/utils/timer_periodic.dart';
import 'package:hello_flutter/home/model/workout_model.dart';
import 'package:hello_flutter/home/view/widgets/timer_button.dart';
import 'package:hello_flutter/home/view/widgets/workout_group.dart';
import 'package:hello_flutter/home/view/clocktimer_page.dart';

import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class HomePage extends StatefulWidget {
  final Function reRenderFn;
  final String title;
  const HomePage({super.key, required this.title, required this.reRenderFn});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final apiItemsListKey = GlobalKey<WorkoutGroupState>();

  final _controller = YoutubePlayerController.fromVideoId(
    videoId: '',
    autoPlay: true,
    params: const YoutubePlayerParams(
      showFullscreenButton: true,
      mute: true,
    ),
  );

  void setCurrentWorkout(WorkoutModel workout) async {
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

  void forceRerender() {
    apiItemsListKey.currentState!.updateWithLocalStorage().then(
          (value) => setState(() {}),
        );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(widget.title),
        elevation: 10,
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.settings),
            tooltip: 'Settings',
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (context) =>
                        SettingsPage(reRenderFn: forceRerender)),
              );
            },
          ),
        ],
      ),
      body: WorkoutGroup(
        setWorkout: setCurrentWorkout,
        key: apiItemsListKey,
        reRenderFn: widget.reRenderFn,
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
