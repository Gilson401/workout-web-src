import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hello_flutter/utils/grupo_muscular.dart';
import 'package:hello_flutter/utils/local_storage_workout_handler.dart';
import 'package:hello_flutter/utils/workout.dart';
import 'package:hello_flutter/utils/app_constants.dart';
import 'package:hello_flutter/widgets/workout_list_tile.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
  var _items = [];

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

  Future<void> _loadDataLocal() async {
    final String response =
        await rootBundle.loadString('assets/json/series.json');

    final jsonMapFromLocalJson = await json.decode(response);

    List<dynamic> exerciciosFromJson = jsonMapFromLocalJson['exercicios'];

    List<Workout> parsedListWorkout =
        exerciciosFromJson.map((element) => Workout.fromJson(element)).toList();

    setState(() {
      _items = parsedListWorkout;
      _listWorkout = parsedListWorkout;
      _displayItems = parsedListWorkout;
    });
    await updateWithLocalStorage();
  }

  Future<void> updateWithLocalStorage() async {
    for (Workout item in _items) {
      await localStorageWorkoutHandler.updateWorkoutWithStoredLocalData(item);
    }
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
    List<Workout> filtredList = _listWorkout
        .where((element) => element.grupoMuscular == grupoMuscular.label)
        .toList();
    resetCurrentWorkoutIndex();
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
                _filterExercicesDisplayList(gruposMusculares[i]);
              },
              splashColor: Colors.blue,
              splashFactory: InkSplash.splashFactory,
              child: Container(
                  margin: const EdgeInsets.all(2),
                  padding: const EdgeInsets.all(5),
                  width: 90,
                  height: 110,
                  decoration: BoxDecoration(
                      color: gruposMusculares[i].color,
                      borderRadius: BorderRadius.all(Radius.circular(12))),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(gruposMusculares[i].label,
                            textAlign: TextAlign.center),
                        SizedBox(
                          width: 100,
                          height: 50,
                          child: showImage(gruposMusculares[i]),
                        )
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

  Widget itemsListViewBulder() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 20.0),
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
            reRenderFn: widget.reRenderFn));
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
        SizedBox(height: 590, child: itemsListViewBulder()),
        SizedBox(height: 10.0)
      ],
    );
  }
}
