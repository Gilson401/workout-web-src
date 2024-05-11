import 'package:flutter/material.dart';
import 'package:hello_flutter/utils/app_controller.dart';
import 'package:hello_flutter/pages/home.dart';
import 'package:hello_flutter/widgets/responsive_wrapper.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  void reRender() {
    setState((() {}));
  }



  @override
  Widget build(BuildContext context) {

    return AnimatedBuilder(
        animation: AppController.instance,
        builder: (context, child) {
          return MaterialApp(
              title: 'Home Workout App',
              debugShowCheckedModeBanner: false,
              theme: ThemeData(
                colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.cyan).copyWith(background: Color.fromARGB(121, 247, 247, 247)),
              ),
              home: ResponsiveWrapper(
                child:  Home(title: 'Meus Exercícios', reRenderFn: reRender),
              )
            );
        });
  }
}
