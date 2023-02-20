import 'package:flutter/material.dart';
import 'package:hello_flutter/di/inject.dart';
import 'widgets/myapp.dart';

void main() {
  startModules();
  runApp(const MyApp());
}

