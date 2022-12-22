import 'package:flutter/material.dart';
import 'home_controller.dart';
import 'myhomepage.dart';
import 'stateless_homepage.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hello Flutter',
      theme: ThemeData(
        primarySwatch: Colors.cyan,
        backgroundColor: Color.fromARGB(121, 247, 247, 247),
      ),
      // home: HomeController(child: const StatelessHomePage()),
      home:  MyHomePage(title: 'Stateful Widget Myhomepage'),
    );
  }
}
