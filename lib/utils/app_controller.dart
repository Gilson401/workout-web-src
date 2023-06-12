import 'package:flutter/material.dart';
import 'package:vibration/vibration.dart';

class AppController extends ChangeNotifier {
  static AppController instance = AppController();
  bool _canVibrate = false;
  bool canStartTheTimer = true;

  AppController() {
    _setVibrateStatus();
  }

  void setCanStartTimer(bool value) {
    canStartTheTimer = value;
    notifyAll();
  }

  Future<void> _setVibrateStatus() async {
    bool? canVibrate = await Vibration.hasVibrator();

    if (canVibrate != null && canVibrate) {
      _canVibrate = true;
    }
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
