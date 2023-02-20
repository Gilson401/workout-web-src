import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vibration/vibration.dart';

class AppController extends ChangeNotifier {
  static AppController instance = AppController();
  bool _canVibrate = false;

  AppController() {
    _setVibrateStatus();
  }

  final ButtonStyle raisedButtonStyle = ElevatedButton.styleFrom(
    foregroundColor: Colors.black87,
    backgroundColor: Color.fromARGB(255, 5, 4, 4),
    minimumSize: Size(88, 36),
    padding: EdgeInsets.symmetric(horizontal: 16),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(2)),
    ),
  );
  
  Future<void> _setVibrateStatus() async {
    bool? canVibrate = await Vibration.hasVibrator();

    if (canVibrate != null && canVibrate) {
      _canVibrate = true;
    }

    print('Controle started and _canVibrate is $_canVibrate');
  }

  notifyAll() {
    notifyListeners();
  }

  vibrate(int time) {
    if (_canVibrate) {
      Vibration.vibrate(duration: time);
    }
  }
}
