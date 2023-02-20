import 'package:flutter/material.dart';
import 'package:hello_flutter/utils/app_controller.dart';

// import 'home_controller.dart';
import '../pages/my_stateful_homepage.dart';
// import 'stateless_homepage.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: AppController.instance,
        builder: (context, child) {
          return MaterialApp(
            title: 'Home Workout App',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              primarySwatch: Colors.cyan,
              backgroundColor: Color.fromARGB(121, 247, 247, 247),
            ),
            home: MyStatefullHomePage(title: 'Séries de exercícios'),
          );
        });
  }
}
