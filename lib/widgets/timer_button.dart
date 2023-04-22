
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:hello_flutter/utils/app_controller.dart';


class TimerButton extends StatefulWidget {

  final int timerLimitInSeconds;
  final String label;
  const TimerButton({
    Key? key,
    required this.timerLimitInSeconds,
    required this.label,
  }) : super(key: key);

  @override
  State<TimerButton> createState() => _TimerButtonState();
}

class _TimerButtonState extends State<TimerButton> {
  bool _stopTimer = false;
  int timerMaxSeconds = 0;

  int currentSeconds = 0;

  final ButtonStyle raisedButtonStyle = ElevatedButton.styleFrom(
    foregroundColor: Colors.black87,
    backgroundColor: Colors.grey[300],
    minimumSize: Size(88, 36),
    padding: EdgeInsets.symmetric(horizontal: 16),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(2)),
    ),
  );

String get timerText =>
      '${((timerMaxSeconds - currentSeconds) ~/ 60).toString().padLeft(2, '0')}:${((timerMaxSeconds - currentSeconds) % 60).toString().padLeft(2, '0')}';


  void startTimeout() {

    setState(() {
      _stopTimer = false;
      timerMaxSeconds = widget.timerLimitInSeconds;
      currentSeconds = widget.timerLimitInSeconds;
    });

    Duration duration = Duration(seconds: 1);

    Timer.periodic(duration, (timer) {
      if (_stopTimer) {
        setState(() {
          currentSeconds = 0;
          timerMaxSeconds = 0;
        });
        timer.cancel();
      } else {
        setState(() {
          currentSeconds = timer.tick;
        });

        if (timer.tick >= widget.timerLimitInSeconds) {
          timer.cancel();
          AppController.instance.vibrate(500);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    
    return ElevatedButton(
      style: raisedButtonStyle,
      child: Text(
        timerMaxSeconds - currentSeconds <= 0
        ? widget.label
        : timerText),
      onPressed: () {
        startTimeout();
      },
    );
  }
}
