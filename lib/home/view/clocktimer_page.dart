
import 'package:flutter/material.dart';
import 'package:hello_flutter/home/view/widgets/timers_menu.dart';

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
        child: TimersMenu(),
      ),
    );
  }
}