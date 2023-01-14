import 'package:flutter/cupertino.dart';

class AppController extends ChangeNotifier {
  static AppController instance = AppController();

  // int renderCount = 0;

  increaseRenderCount() {
    // renderCount++;
    notifyListeners();
  }
}
