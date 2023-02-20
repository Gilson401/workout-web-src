import 'package:get_it/get_it.dart';
import 'package:hello_flutter/local_storage.dart';

final GetIt inject = GetIt.I;

void startModules() {
  inject.registerSingleton<LocalStorage>(SharePreferencesImpl());
  }