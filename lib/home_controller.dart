// ignore_for_file: prefer_const_constructors_in_immutables, must_be_immutable

import 'package:flutter/cupertino.dart';

class HomeController extends InheritedWidget{
  
  HomeController({Key? key, required Widget child})
  : super(
    key: key,
    child: child,
  );

// As duas variáveis abaixo serão acessadas pelo filho
int value = 1;
String homeControllerStringVar = "Text stored in homeControllerStringVar";

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return false;
  }

}