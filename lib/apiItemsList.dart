import 'package:flutter/material.dart';
// import 'package:hello_flutter/stock.dart';
import 'package:hello_flutter/workout.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// https://www.youtube.com/watch?v=cQbWd2tnfdc&t=2496s

///Neste exemplo ApiItemsList é o componente filho
class ApiItemsListState extends State<ApiItemsList> {
  var _gruposMusculares = [];

final String _somestringInState = "fgd";

  _onListTileClick(workout) {
    //Abaixo vc invoca a função recebida como parâmetro
    widget.setWorkout(workout);
  }

  var _items = [];

  final _font = const TextStyle(
    fontSize: 15.0,
  );

  String get grupos => _somestringInState;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  // get _gruposMusculares => _items.map((item) => item['grupoMuscular'] as String);

  _loadData() async {
    String workoutApi =
        "https://my-json-server.typicode.com/Gilson401/json_placeholder/exercicios";

    try {
      http.Response response = await http.get(Uri.parse(workoutApi));
      List<dynamic> decoded = jsonDecode(response.body);
      List<Workout> parsedListWorkout =
          decoded.map((element) => Workout.fromJson(element)).toList();

      setState(() {
        _items = parsedListWorkout;
      });

      setState(() {
        // _gruposMusculares = parsedListWorkout.map((item) => item.grupoMuscular as List<dynamic>);
        _gruposMusculares = parsedListWorkout
            .map((exercicio) => exercicio.grupoMuscular)
            .toList();
      });
    } catch (err) {
      print(err);
    }
  }

  List<dynamic> gruposMusc() {
    return _items.map((exercicio) => exercicio.grupoMuscular).toList();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: _items.length,
      itemBuilder: (BuildContext context, int position) {
        return _buildRow(position);
      },
    );
  }

  Widget _buildRow(int position) {
    return ListTile(
        title: Text(
          "${_items[position].nome}",
          textAlign: TextAlign.left,
          style: TextStyle(
              fontSize: 17, fontFamily: 'Raleway', fontWeight: FontWeight.w700),
        ),
        subtitle:
            Text("Grupo: ${_items[position].grupoMuscular}", style: _font),
        leading: const Padding(
          padding: EdgeInsets.all(2.0),
          child: CircleAvatar(
            backgroundColor: Colors.green,
            backgroundImage: NetworkImage('https://picsum.photos/250?image=9'),
          ),
        ),
        onTap: () {
          _onListTileClick(_items[position]);
        });
  }
}

class ApiItemsList extends StatefulWidget {
  final Function setWorkout;

  const ApiItemsList({super.key, required this.setWorkout});

  @override
  createState() => ApiItemsListState();
}
