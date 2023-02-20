// import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/src/widgets/container.dart';
// import 'package:flutter/src/widgets/framework.dart';

import 'otpTimer.dart';

class ClockTimerPage extends StatelessWidget {
  const ClockTimerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tempo descanso"),
        elevation: 10,
      ),
      body: Center(
        child: OtpTimer(),
      ),
    );
  }
}