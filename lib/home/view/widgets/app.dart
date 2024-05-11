import 'package:flutter/material.dart';
import 'package:hello_flutter/utils/app_controller.dart';
import 'package:hello_flutter/home/view/home_page.dart';
import 'package:hello_flutter/home/view/widgets/responsive_wrapper.dart';

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
                colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.cyan, backgroundColor: Colors.white) .copyWith(background: Colors.white),
              ),
              home: ResponsiveWrapper(
                child:  HomePage(title: 'Meus Exercícios', reRenderFn: reRender),
              )
            );
        });
  }
}
