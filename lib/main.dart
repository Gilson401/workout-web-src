import 'package:flutter/material.dart';
import 'package:hello_flutter/di/inject.dart';
import 'widgets/myapp.dart';
import 'package:flutter/services.dart';

void main() {
    SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  startModules();
  runApp(const MyApp());
}

