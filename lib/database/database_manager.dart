import 'package:hello_flutter/database/database.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class DatabaseManager {
  Future<List<Object>> queryTable({required String table}) async {
    if (kIsWeb) return [];

    var database = await DatabaseSqLite().openConnection();

    var result = database.query(table);
    database.close();

    return result;
  }

  Future<void> insertItem(
      {required String table, required Map<String, dynamic> data}) async {
    if (kIsWeb) return;

    var database = await DatabaseSqLite().openConnection();

    database.insert(table, data);

    database.close();
  }

  Future<void> deleteItem(
      {required String table,
      required String whereString,
      required List<Object> whereArgs}) async {
    if (kIsWeb) return;
    var database = await DatabaseSqLite().openConnection();

    database.delete(table, where: whereString, whereArgs: whereArgs);

    database.close();
  }

  Future<void> updateItem(
      {required String table,
      required Map<String, dynamic> newData,
      required String whereString,
      required List<Object> whereArgs}) async {
    if (kIsWeb) return;
    var database = await DatabaseSqLite().openConnection();

    database.update(table, newData, where: whereString, whereArgs: whereArgs);

    database.close();
  }

}
