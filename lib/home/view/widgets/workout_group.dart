import 'package:flutter/material.dart';
import 'package:hello_flutter/di/inject.dart';
import 'package:hello_flutter/home/controller/home_controller.dart';
import 'package:hello_flutter/home/model/muscular_group_model.dart';
import 'package:hello_flutter/home/repository/local_storage_workout_handler.dart';
import 'package:hello_flutter/home/model/workout_model.dart';
import 'package:hello_flutter/utils/app_constants.dart';
import 'package:hello_flutter/home/view/widgets/workout_list_tile.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hello_flutter/utils/ui_helpers.dart';

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

  final controller = inject<HomeController>();

  List<MuscularGroupModel> gruposMusculares = [
    MuscularGroupModel.color(
        label: 'A: Peito e Ombros',
        svg: AppConstants.svgA,
        color: Color.fromARGB(155, 43, 179, 151)),
    MuscularGroupModel.color(
        label: 'B: Costas e Ombro',
        svg: AppConstants.svgB,
        color: Color.fromARGB(155, 248, 252, 35)),
    MuscularGroupModel.color(
        label: 'C: Pernas',
        svg: AppConstants.svgC,
        color: Color.fromARGB(155, 131, 131, 128)),
    MuscularGroupModel.color(
        label: 'D: Bíceps e Tríceps',
        svg: AppConstants.svgD,
        color: Color.fromARGB(155, 243, 79, 51))
  ];

  LocalStorageWorkoutHandler localStorageWorkoutHandler =
      LocalStorageWorkoutHandler();

  _onListTileClick(WorkoutModel workout) {
    widget.setWorkout(workout);
    setState(() {
      _currentWorkoutId = workout.id;
    });
  }

  var forceRender = 1;
  List<WorkoutModel> _items = [];

  List<WorkoutModel> _displayItems = [];
  List<WorkoutModel> _listWorkout = [];

  int? _currentWorkoutId;

  @override
  void initState() {
    super.initState();
    Future(() async => await _loadData(context));
  }

  void resetCurrentWorkoutIndex() {
    setState(() {
      _currentWorkoutId = null;
    });
  }

  Future<void> updateWithLocalStorage() async {
    for (WorkoutModel item in _items) {
      await localStorageWorkoutHandler.updateWorkoutWithStoredLocalData(item);
    }
  }

  Future<void> _loadData(BuildContext context) async {
    controller.loadData().then((decoded) {
      List<WorkoutModel> parsedListWorkout =
          decoded.map((element) => WorkoutModel.fromJson(element)).toList();

      if (parsedListWorkout.isEmpty) {
        UiHelpers.showSnackbar(
            context: context, message: 'A busca não obteve dados.');
      }

      setState(() {
        _items = parsedListWorkout;
        _listWorkout = parsedListWorkout;
        _displayItems = parsedListWorkout;
      });
    }).catchError((err) {
      UiHelpers.showSnackbar(
          context: context, message: 'Houve um erro ao obter os dados.');
    });
  }

  void _filterExercicesDisplayList(MuscularGroupModel grupoMuscular) {
    List<WorkoutModel> filtredList = _listWorkout
        .where((element) => element.grupoMuscular == grupoMuscular.label)
        .toList();

    sortDisplayListByLastDayDone(filtredList);

    resetCurrentWorkoutIndex();
    setState(() {
      _displayItems = filtredList;
      _currentColor = grupoMuscular.color;
    });
  }

  void sortDisplayListByLastDayDone(List<WorkoutModel> filtredList) {
    filtredList.sort((a, b) => getLastTenCharacters(a.lastDayDone)
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

  String _findLatestDate(MuscularGroupModel grupoMuscular) {
    List<WorkoutModel> exerciciosDoGrupoComLastDoneDay = [];

    String tempSt = "";

    try {
      exerciciosDoGrupoComLastDoneDay = [..._items].where((element) {
        return grupoMuscular.label == element.grupoMuscular &&
            element.lastDayDone != "";
      }).toList();

      if (exerciciosDoGrupoComLastDoneDay.isEmpty) {
        return '';
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

  Widget showImage(MuscularGroupModel group) {
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
    List<WorkoutModel> itemsLocally = _displayItems;
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
                  flex: 4,
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
