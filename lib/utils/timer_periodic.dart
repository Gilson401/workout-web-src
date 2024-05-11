
import 'dart:async';
import 'app_controller.dart';

class TimePeriodic {
  bool stopTimer = false;
  int timerMaxSeconds = 0;
  int currentSeconds = 0;

  TimePeriodic({
    required this.stopTimer,
    required this.timerMaxSeconds,
    required this.currentSeconds,
  });

  String get timerText =>
      '${((timerMaxSeconds - currentSeconds) ~/ 60).toString().padLeft(2, '0')}:${((timerMaxSeconds - currentSeconds) % 60).toString().padLeft(2, '0')}';


  startTimeout(timerLimitInSeconds) {
    stopTimer = false;
    timerMaxSeconds = timerLimitInSeconds;
    currentSeconds = timerLimitInSeconds;

    Duration duration = Duration(seconds: 1);

    Timer.periodic(duration, (timer) {
      if (stopTimer) {
        currentSeconds = 0;
        timerMaxSeconds = 0;

        timer.cancel();
      } else {
        currentSeconds = timer.tick;
        
        if (timer.tick >= timerLimitInSeconds) {
          AppController.instance.notifyAll();
          timer.cancel();
          AppController.instance.vibrate(500);
        }
      }
      AppController.instance.notifyAll();
    });
  }
}
