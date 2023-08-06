import 'package:flutter/material.dart';


import 'package:hello_flutter/pages/settings_page.dart';
import 'package:hello_flutter/utils/timer_periodic.dart';
import 'package:hello_flutter/utils/workout.dart';
import 'package:hello_flutter/widgets/timer_button.dart';
import 'package:hello_flutter/widgets/workout_group.dart';
import 'package:hello_flutter/widgets/clocktimer_page.dart';

import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class Home extends StatefulWidget {
  final Function reRenderFn;
  final String title;
  const Home({super.key, required this.title, required this.reRenderFn});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final apiItemsListKey = GlobalKey<WorkoutGroupState>();

  final _controller = YoutubePlayerController.fromVideoId(
    videoId: '',
    autoPlay: true,
    params: const YoutubePlayerParams(
      showFullscreenButton: true,
      mute: true,
    ),
  );

  void setCurrentWorkout(Workout workout) async {
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
    print('Context Home ${context.hashCode}');

    return Scaffold(
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
