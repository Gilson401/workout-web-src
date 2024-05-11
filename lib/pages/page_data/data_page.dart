import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hello_flutter/pages/page_data/bloc/data_block.dart';

class DataBlocPage extends StatefulWidget {
  final Function? reRenderFn;

  const DataBlocPage({super.key, this.reRenderFn});

  @override
  State<DataBlocPage> createState() => _DataBlocPageState();
}

class _DataBlocPageState extends State<DataBlocPage> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Data Page Bloc"),
        elevation: 10,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
        child: ListView(
          children: <Widget>[

            BlocBuilder<DataBloc, MeuEstado>(
              builder: (context, state) {
                return Text('retorno do BlocBuilder ${state.counter}');
              }
            ),

            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                context.read<DataBloc>().add(IncrementaEstado());
              },
              child: Text('Action Add'),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                context.read<DataBloc>().add(DecrementaEstado());
              },
              child: Text('Action 2'),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                 context.read<DataBloc>().add(EventoComParam(value: 20));
              },
              child: Text('Evento Com param'),
            ),
          ],
        ),
      ),
    );
  }
}
