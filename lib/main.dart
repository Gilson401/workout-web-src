import 'package:flutter/material.dart';
import 'package:hello_flutter/di/inject.dart';
import 'home/view/widgets/app.dart';
import 'package:flutter/services.dart';


void main() {
   startModules();

 runApp(

    App(), 
   );

  
   SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
}
