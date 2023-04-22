import 'package:hello_flutter/utils/app_constants.dart';
import 'package:hello_flutter/utils/date_mixins.dart';
import 'package:hello_flutter/utils/local_storage.dart';
import 'package:hello_flutter/utils/workout.dart';


class LocalStorageWorkoutHandler with DateFunctions, SharePreferencesImpl {

  void saveWorkoutData(Workout workout) {
    String dataWorkoutToSave = workout.toStoreJson();
    set(AppConstants.seriesDoneStorageKey(workout.id), dataWorkoutToSave);
  }

  Future<String> getWorkout(Workout workout) async {
    String dataWorkoutToReturn = "";

    await get(AppConstants.seriesDoneStorageKey(workout.id))
        .then((value) => dataWorkoutToReturn = value ?? "");
    return dataWorkoutToReturn;
  }

  Future<Map<String, dynamic>?> mapFromLocalStoredJson(Workout workout) async {
    String jsonParam = await getWorkout(workout);
    if (jsonParam == "") return null;
    return Workout.fromLocalStoredJson(jsonParam);
  }

  Future<void> updateWorkoutWithStoredLocalData(Workout workout) async {
    mapFromLocalStoredJson(workout).then((value) {
      if (value != null) {
        workout.currentCarga = value['currentCarga'] ?? "";
        workout.lastDayDone = value['lastDayDone'] ?? "";
        workout.seriesFeitas = value['seriesFeitas'] ?? 0;
      }else{
         workout.currentCarga =  "";
        workout.lastDayDone =  "";
        workout.seriesFeitas =  0;
      }
    });
  }

  Future<void> deleteAppLocalStorage() async {
    List<String>? keys = await getAppLocalStorageKeys();

    if (keys != null && keys.isNotEmpty) {
      for (var key in keys) {
        set(key, '');
      }
    }
  }
}
