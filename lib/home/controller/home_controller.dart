import 'package:flutter/cupertino.dart';

class HomeController extends InheritedNotifier<ValueNotifier<int>> {
  
  final String homeControllerStringVar = "Text stored in homeControllerStringVar ";

  HomeController({Key? key, required Widget child})
      : super(
          key: key,
          child: child,
          notifier: ValueNotifier(0),
        );

  int get value => notifier!.value;

  increment() {
    notifier!.value++;
  }

  static HomeController of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<HomeController>()!;
  }
}
