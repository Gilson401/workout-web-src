// ignore_for_file: file_names

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hello_flutter/utils/app_controller.dart';
import 'package:percent_indicator/percent_indicator.dart';

enum PercentDisplaMode {
  circle,
  line
}

class OtpTimer extends StatefulWidget {
  const OtpTimer({super.key});

  @override
  _OtpTimerState createState() => _OtpTimerState();
}

class _OtpTimerState extends State<OtpTimer> {
  final interval = const Duration(seconds: 1);

  int timerMaxSeconds = 0;

  int currentSeconds = 0;

  String get timerText =>
      '${((timerMaxSeconds - currentSeconds) ~/ 60).toString().padLeft(2, '0')}:${((timerMaxSeconds - currentSeconds) % 60).toString().padLeft(2, '0')}';

  final ButtonStyle raisedButtonStyle = ElevatedButton.styleFrom(
    foregroundColor: Colors.black87,
    backgroundColor: Colors.grey[300],
    minimumSize: Size(88, 36),
    padding: EdgeInsets.symmetric(horizontal: 16),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(2)),
    ),
  );

  bool _stopTimer = false;

  startTimeout(timerLimitInSeconds) {
    print('Timer iniciado com $timerLimitInSeconds');
    setState(() {
      _stopTimer = false;
      timerMaxSeconds = timerLimitInSeconds;
      currentSeconds = timerLimitInSeconds;
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

        if (timer.tick >= timerLimitInSeconds) {
          timer.cancel();
          AppController.instance.vibrate(500);
        }
      }
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        SizedBox(
          width: 5,
        ),
        CircularPercentIndicator(
          radius: 100.0,
          lineWidth: 20.0,
          percent:
              (timerMaxSeconds == 0 || (currentSeconds / timerMaxSeconds) > 1.0)
                  ? 1.0
                  : currentSeconds / timerMaxSeconds,
          center: Text(
            timerText,
            style: TextStyle(
                fontSize: 30,
                color: Color.fromARGB(155, 2, 55, 99),
                fontFamily: 'Raleway',
                fontWeight: FontWeight.w700),
          ),
          // center: Icon(Icons.timer, color: Color.fromARGB(255, 2, 55, 99)),

          backgroundColor: Color.fromARGB(255, 111, 207, 245),
          progressColor: Color.fromARGB(255, 2, 55, 99),
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width,
          height: 100,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                style: raisedButtonStyle,
                onPressed: () {
                  setState(() {
                    _stopTimer = true;
                  });
                },
                child: Text('Parar'),
              ),
              ElevatedButton(
                style: raisedButtonStyle,
                child: Text('1 min'),
                onPressed: () {
                  startTimeout(60);
                },
              ),
              ElevatedButton(
                style: raisedButtonStyle,
                child: Text('2 min'),
                onPressed: () {
                  startTimeout(120);
                },
              ),
            ],
          ),
        )
      ],
    );
  }
}
