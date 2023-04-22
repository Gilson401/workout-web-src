import 'package:flutter/material.dart';
import 'package:hello_flutter/di/inject.dart';
import 'widgets/myapp.dart';
import 'package:flutter/services.dart';

void main() {
   startModules();
   runApp(const App());
   SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
}
