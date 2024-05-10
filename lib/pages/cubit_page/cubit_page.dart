import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hello_flutter/pages/cubit_page/cubit/counter_cubit.dart';

class CubitPage extends StatelessWidget {
  const CubitPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cubit Page Bloc"),
        elevation: 10,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
        child: Column(
          children: <Widget>[
            //blocBuilder igual ao bloc
            BlocBuilder<CounterCubit, CounterStateCubit>(
                builder: (context, state) {
              return Text('CounterStateCubit ${state.counter}');
            }),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                //Não dispara evento, chama a função no Cubit
                context.read<CounterCubit>().increment();
              },
              child: Text('Action increment'),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                //Não dispara evento, chama a função no Cubit
                context.read<CounterCubit>().decrement();
              },
              child: Text('Action decrement'),
            ),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
