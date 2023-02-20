import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vibration/vibration.dart';
import 'package:hello_flutter/workout.dart';
// import 'package:http/http.dart' as http;
import 'dart:convert';
import 'app_controller.dart';
import 'grupo_muscular.dart';

class ApiItemsListState extends State<ApiItemsList> {
  dynamic _currentColor = Color.fromARGB(0, 255, 255, 255);
  List<GrupoMuscular> gruposMusculares = [
    GrupoMuscular.color('Peito e Tríceps', 'assets/imgs/peito.png',
        Color.fromARGB(155, 43, 179, 151)),
    GrupoMuscular.color('Bíceps e Costas', 'assets/imgs/dumbbell.PNG',
        Color.fromARGB(155, 248, 252, 35)),
    GrupoMuscular.color(
        'Pernas Anterior', 'assets/imgs/leg.png', Color.fromARGB(155, 223, 220, 220)),
    GrupoMuscular('Ombros', 'assets/imgs/ombros.png'),
    GrupoMuscular.color(
        'Pernas Posterior', 'assets/imgs/leg.png', Color.fromARGB(155, 243, 79, 51)),
  ];

  _onListTileClick(workout) {
    widget.setWorkout(workout);
  }

  bool _canVibrate = false;
  var forceRender = 1;
  var _items = [];

  List<Workout> _displayItems = [];

  List<Workout> _listWorkout = [];

  final _font = const TextStyle(
    fontSize: 15.0,
  );

  @override
  void initState() {
    super.initState();
    _loadDataLocal();
    _setVibrateStatus();
  }

  Future<void> _setVibrateStatus() async {
    bool? canVibrate = await Vibration.hasVibrator();

    if (canVibrate != null && canVibrate) {
      setState(() {
        _canVibrate = true;
      });
    }
  }

  Future<void> _loadDataLocal() async {
    //lê o json
    final String response =
        await rootBundle.loadString('assets/json/series.json');

    // FileHandler  frdl = FileHandler();

    // final String response = await frdl.readFile();

    //parseia o json para _JsonMap ou _JsonList
    final jsonMapFromLocalJson = await json.decode(response);

    //a key exercicios é um _JsonList (~array) e é atribuída a uma List<dynamic>
    List<dynamic> exerciciosFromJson = jsonMapFromLocalJson['exercicios'];

    //Uma List<dynamic> pode receber um map e retornar uma List de outro tipo
    List<Workout> parsedListWorkout =
        exerciciosFromJson.map((element) => Workout.fromJson(element)).toList();

    setState(() {
      _items = parsedListWorkout;
      _listWorkout = parsedListWorkout;
      _displayItems = parsedListWorkout;
    });
  }

//este método é pela api
  // _loadData() async {
  //   String workoutApi =
  //       "https://my-json-server.typicode.com/Gilson401/json_placeholder/exercicios";

  //   try {
  //     http.Response response = await http.get(Uri.parse(workoutApi));
  //     List<dynamic> decoded = jsonDecode(response.body);
  //     List<Workout> parsedListWorkout =
  //         decoded.map((element) => Workout.fromJson(element)).toList();

  //     setState(() {
  //       _items = parsedListWorkout;
  //     });
  //   } catch (err) {
  //     print(err);
  //   }
  // }

  _filterExercicesDisplayList(GrupoMuscular grupoMuscular) {
    print("_filterExercicesDisplayList $grupoMuscular");
    List<Workout> filtredList = _listWorkout
        .where((element) => element.grupoMuscular == grupoMuscular.label)
        .toList();

    setState(() {
      _displayItems = filtredList;
      _currentColor = grupoMuscular.color;
    });
  }

  List<dynamic> gruposMusc() {
    return _items.map((exercicio) => exercicio.grupoMuscular).toList();
  }

  Widget groupMusclesButtons() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          for (var i = 0; i < gruposMusculares.length; i++)
            InkWell(
              onTap: () {
                print('Selecionou grupo ${gruposMusculares[i].label}');
                _filterExercicesDisplayList(gruposMusculares[i]);
              },
              splashColor: Colors.blue,
              splashFactory: InkSplash.splashFactory,
              child: Container(
                  margin: const EdgeInsets.all(2),
                  width: 90,
                  height: 100,
                  decoration: BoxDecoration(
                      color: gruposMusculares[i].color,
                      borderRadius: BorderRadius.all(Radius.circular(12))),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(gruposMusculares[i].label,
                            textAlign: TextAlign.center),
                        SizedBox(
                          width: 100,
                          height: 50,
                          child: Image.asset(
                            gruposMusculares[i].image,
                            fit: BoxFit.contain,
                          ),
                        )
                      ])),
            ),
        ],
      ),
    );
  }

  Widget itemsListViewBulder() {
    return ListView.builder(
      padding: const EdgeInsets.all(5.0),
      itemCount: _displayItems.length,
      itemBuilder: (BuildContext context, int position) {
        return _buildRow(position);
      },
    );
  }

  Widget _buildRow(int position) {
    List<Workout> itemsLocally = _displayItems;

    return ListTile(
        tileColor: _currentColor,
        selectedColor: Color.fromARGB(155, 2, 55, 99),
        trailing: itemsLocally[position].getStatus ? Icon(Icons.done) : null,
        onLongPress: () {
          itemsLocally[position].toggleDone();
          if (_canVibrate) {
            Vibration.vibrate(duration: 500);
          }
          AppController.instance.notifyAll();
        },
        shape: RoundedRectangleBorder(
          side: BorderSide(width: 2, color: Color.fromARGB(255, 255, 255, 255)),
          borderRadius: BorderRadius.circular(20),
        ),
        title: Text(
          itemsLocally[position].nome,
          textAlign: TextAlign.left,
          style: TextStyle(
              fontSize: 17, fontFamily: 'Raleway', fontWeight: FontWeight.w700),
        ),
        subtitle: Text("Grupo: ${itemsLocally[position].grupoMuscular}  ",
            style: _font),
        leading: Padding(
            padding: EdgeInsets.all(0.5),
            child: SizedBox(
                width: MediaQuery.of(context).size.width / 7,
                child: Image.network(itemsLocally[position].image, scale: 1))),
        onTap: () {
          _onListTileClick(itemsLocally[position]);
        });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
            ),
            child: Center(child: groupMusclesButtons())),
        SizedBox(height: 300, child: itemsListViewBulder())
      ],
    );
  }
}

class ApiItemsList extends StatefulWidget {
  final Function setWorkout;

  const ApiItemsList({super.key, required this.setWorkout});

  @override
  createState() => ApiItemsListState();
}
