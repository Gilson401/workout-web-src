import 'package:get_it/get_it.dart';
import 'package:hello_flutter/utils/local_storage.dart';
import 'package:hello_flutter/home/view/widgets/workout_group_handler.dart';


final GetIt inject = GetIt.I;

void startModules() {
  inject.registerSingleton<LocalStorage>(SharePreferencesImpl());
  inject.registerSingleton<WorkoutGroupHandler>(WorkoutGroupHandler());

  }