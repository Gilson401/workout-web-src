import 'package:shared_preferences/shared_preferences.dart';
import 'package:hello_flutter/utils/app_constants.dart' as locals;
abstract class LocalStorage {
  Future<String?> get(String key);
  void set(String key, dynamic value);
  void remove(String key);
}

class SharePreferencesImpl implements LocalStorage {
  late SharedPreferences? _prefs;

  Future<dynamic> _getInstance() async =>
      _prefs = await SharedPreferences.getInstance();

  Future<List<String>?> getAppLocalStorageKeys() async {
    await _getInstance();

    List<String>? keys = _prefs?.getKeys().toList();

    List<String>? filteredKeys = keys
        ?.where((key) => key.contains(locals.AppConstants.storageWorkoutSerieDone))
        .toList();

    return filteredKeys;
  }

  @override
  Future<String?> get(String key) async {
    await _getInstance();
    return _prefs?.getString(key);
  }

  @override
  void set(String key, dynamic value) async {
    await _getInstance();
    await _prefs?.setString(key, value);
  }

  @override
  void remove(String key) async {
    await _getInstance();
    await _prefs?.remove(key);
  }
}
