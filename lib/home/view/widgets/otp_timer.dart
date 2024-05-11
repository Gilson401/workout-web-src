import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hello_flutter/utils/app_controller.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:hello_flutter/utils/app_constants.dart';

enum PercentDisplaMode {
  circle,
  line
}

class OtpTimer extends StatefulWidget {
  const OtpTimer({super.key});

  @override
  OtpTimerState createState() => OtpTimerState();
}

class OtpTimerState extends State<OtpTimer> {
  final interval = const Duration(seconds: 1);
  final ButtonStyle raisedButtonStyle  = AppConstants.raisedButtonStyle;
  
  int timerMaxSeconds = 0;

  int currentSeconds = 0;

  String get timerText =>
      '${((timerMaxSeconds - currentSeconds) ~/ 60).toString().padLeft(2, '0')}:${((timerMaxSeconds - currentSeconds) % 60).toString().padLeft(2, '0')}';



  bool _stopTimer = false;

  startTimeout(timerLimitInSeconds) {
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
