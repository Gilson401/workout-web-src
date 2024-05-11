import 'package:flutter/material.dart';
import 'package:hello_flutter/home/model/grupo_muscular.dart';
import 'package:hello_flutter/home/controller/local_storage_workout_handler.dart';
import 'package:hello_flutter/home/model/workout.dart';
import 'package:hello_flutter/utils/app_constants.dart';
import 'package:hello_flutter/home/view/widgets/workout_list_tile.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

enum ImageType { img, svg, unset }

class WorkoutGroup extends StatefulWidget {
  final Function setWorkout;
  final Function reRenderFn;

  const WorkoutGroup(
      {super.key, required this.setWorkout, required this.reRenderFn});

  @override
  createState() => WorkoutGroupState();
}

class WorkoutGroupState extends State<WorkoutGroup> {
  Color _currentColor = Color.fromARGB(0, 255, 255, 255);

  List<GrupoMuscular> gruposMusculares = [
    GrupoMuscular.color(
        label: 'A: Peito e Ombros',
        svg: AppConstants.svgA,
        color: Color.fromARGB(155, 43, 179, 151)),
    GrupoMuscular.color(
        label: 'B: Costas e Ombro',
        svg: AppConstants.svgB,
        color: Color.fromARGB(155, 248, 252, 35)),
    GrupoMuscular.color(
        label: 'C: Pernas',
        svg: AppConstants.svgC,
        color: Color.fromARGB(155, 131, 131, 128)),
    GrupoMuscular.color(
        label: 'D: Bíceps e Tríceps',
        svg: AppConstants.svgD,
        color: Color.fromARGB(155, 243, 79, 51))
  ];

  LocalStorageWorkoutHandler localStorageWorkoutHandler =
      LocalStorageWorkoutHandler();

  _onListTileClick(Workout workout) {
    widget.setWorkout(workout);
    setState(() {
      _currentWorkoutId = workout.id;
    });
  }

  var forceRender = 1;
  List<Workout> _items = [];

  List<Workout> _displayItems = [];
  List<Workout> _listWorkout = [];

  int? _currentWorkoutId;

  @override
  void initState() {
    super.initState();
    _loadDataLocal();
  }

  void resetCurrentWorkoutIndex() {
    setState(() {
      _currentWorkoutId = null;
    });
  }

 
  Future<void> updateWithLocalStorage() async {
    for (Workout item in _items) {
      await localStorageWorkoutHandler.updateWorkoutWithStoredLocalData(item);
    }
  }


  Future<void> _loadDataLocal() async {
    String workoutApi =
        "https://my-json-server.typicode.com/Gilson401/json_placeholder/exercicios";

    try {
      http.Response response = await http.get(Uri.parse(workoutApi));
      List<dynamic> decoded = jsonDecode(response.body);
      List<Workout> parsedListWorkout =
          decoded.map((element) => Workout.fromJson(element)).toList();

      setState(() {
         _items = parsedListWorkout;
      _listWorkout = parsedListWorkout;
      _displayItems = parsedListWorkout;
      });
    } catch (err) {
      print(err);
    }
  }

  void _filterExercicesDisplayList(GrupoMuscular grupoMuscular) {
    List<Workout> filtredList = _listWorkout
        .where((element) => element.grupoMuscular == grupoMuscular.label)
        .toList();

    sortDisplayListByLastDayDone(filtredList);

    resetCurrentWorkoutIndex();
    setState(() {
      _displayItems = filtredList;
      _currentColor = grupoMuscular.color;
    });
  }

  void sortDisplayListByLastDayDone(List<Workout> filtredList) {
    filtredList.sort(( a, b) => getLastTenCharacters(a.lastDayDone)
        .compareTo((getLastTenCharacters(b.lastDayDone))));
  }

  List<dynamic> gruposMusc() {
    return _items.map((exercicio) => exercicio.grupoMuscular).toList();
  }

  String getLastTenCharacters(String text) {
    if (text.length <= 10) {
      return text;
    }
    String data = text.substring(text.length - 10);

    List<String> partes = data.split('/');
    String dia = partes[0];
    String mes = partes[1];
    String ano = partes[2];

    return '$ano-$mes-$dia';
  }

  String _findLatestDate(GrupoMuscular grupoMuscular) {
    List<Workout> exerciciosDoGrupoComLastDoneDay = [];

    String tempSt = "";

    try {
      exerciciosDoGrupoComLastDoneDay = [..._items].where((element) {
        return grupoMuscular.label == element.grupoMuscular &&
            element.lastDayDone != "";
      }).toList();

      if (exerciciosDoGrupoComLastDoneDay.isEmpty) {
        return 'NoDate';
      }

      exerciciosDoGrupoComLastDoneDay.sort((a, b) =>
          getLastTenCharacters(a.lastDayDone)
              .compareTo((getLastTenCharacters(b.lastDayDone))));
   

      tempSt = exerciciosDoGrupoComLastDoneDay
          .map((element) => element.lastDayDone)
          .toList()
          .last;
    } catch (e) {
      print('LOG err $e');
    }
    return tempSt;
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
                _filterExercicesDisplayList(gruposMusculares[i]);
              },
              splashColor: Colors.blue,
              splashFactory: InkSplash.splashFactory,
              child: Container(
                  margin: const EdgeInsets.all(2),
                  padding: const EdgeInsets.all(5),
                  width: 90,
                  decoration: BoxDecoration(
                      color: gruposMusculares[i].color,
                      borderRadius: BorderRadius.all(Radius.circular(12))),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          flex: 1,
                          child: Text(gruposMusculares[i].label,
                              textAlign: TextAlign.center),
                        ),
                        SizedBox(
                          height: 40,
                          child: showImage(gruposMusculares[i]),
                        ),
                        Text(_findLatestDate(gruposMusculares[i]),
                            textAlign: TextAlign.center),
                      ])),
            ),
        ],
      ),
    );
  }

  Widget showImage(GrupoMuscular group) {
    if (group.image != "") {
      return Image.asset(
        group.image,
        fit: BoxFit.contain,
      );
    } else if (group.svg != "") {
      return SvgPicture.asset(
        group.svg,
      );
    } else {
      return Icon(Icons.image_not_supported);
    }
  }

  ListView itemsListViewBulder() {
    return ListView.builder(
      itemCount: _displayItems.length,
      itemBuilder: (BuildContext context, int position) {
        return _buildRow(position);
      },
    );
  }

  Widget _buildRow(int position) {
    List<Workout> itemsLocally = _displayItems;
    return ListTileTheme(
        selectedColor: Colors.black,
        child: WorkoutListTile(
            key: ValueKey(itemsLocally[position].id),
            currentColor: _currentColor,
            workout: itemsLocally[position],
            currentWorkoutId: _currentWorkoutId,
            setWorkout: _onListTileClick,
            reRenderFn: () {
              sortDisplayListByLastDayDone(_displayItems);
              widget.reRenderFn();
            }));
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return SizedBox(
            width: constraints.maxWidth,
            height: constraints.maxHeight,
            child: Column(
              children: [
                Expanded(
                  flex: 3,
                  child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                      ),
                      child: Center(child: groupMusclesButtons())),
                ),
                Expanded(
                  flex: 14,
                  child: itemsListViewBulder(),
                ),
              ],
            ));
      },
    );
  }
}
