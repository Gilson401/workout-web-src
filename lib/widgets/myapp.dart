import 'package:flutter/material.dart';
import 'package:hello_flutter/pages/page_data/bloc/data_block.dart';
import 'package:hello_flutter/pages/cubit_page/cubit/counter_cubit.dart';

import 'package:hello_flutter/pages/page_data/data_page.dart';
import 'package:hello_flutter/pages/cubit_page/cubit_page.dart';

import 'package:hello_flutter/utils/app_controller.dart';
import 'package:hello_flutter/pages/home.dart';
// import 'package:device_preview/device_preview.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
              // ignore: deprecated_member_use
              useInheritedMediaQuery: true,
              theme: ThemeData(
                colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.cyan).copyWith(background: Color.fromARGB(121, 247, 247, 247)),
              ),
              home:
                 Home(title: 'Meus Exercícios', reRenderFn: reRender),

              routes: {
                
                '/bloc':(_) =>                 
                BlocProvider(
                  create: (_) => DataBloc(),
                  child: DataBlocPage()),

                '/bloc-carregado':(_) =>                 
                BlocProvider(
                  create: (_) => DataBloc()..add(DecrementaEstado()),
                  child: DataBlocPage()),  

                '/cubit':(_) => BlocProvider(
                  create: (_) => CounterCubit(),
                  child: CubitPage()),
              },   
                
            );
        });
  }
}
