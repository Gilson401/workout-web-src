// ignore_for_file: prefer_const_constructors_in_immutables, must_be_immutable

import 'package:flutter/cupertino.dart';

class HomeController extends InheritedNotifier<ValueNotifier<int>> {
  HomeController({Key? key, required Widget child})
      : super(
          key: key,
          child: child,
          notifier: ValueNotifier(0),
        );

  int get value => notifier!.value;
  String homeControllerStringVar = "Text stored in homeControllerStringVar ";

  increment() {
    notifier!.value++;
  }

  static HomeController of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<HomeController>()!;
  }
}
