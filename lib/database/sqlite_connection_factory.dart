// ignore_for_file: prefer_conditional_assignment

import 'package:hello_flutter/database/sqlite_migration_factory.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:synchronized/synchronized.dart';

class SqliteConnectionFactory {
  static const _version = 1;
  static const _databaseName = 'SQLITE_MY_WORKOUT';

  static SqliteConnectionFactory? _instance;

  Database? _db;
  final _lock = Lock();

  SqliteConnectionFactory._();

  factory SqliteConnectionFactory() {
    _instance ??= SqliteConnectionFactory._();
    return _instance!;
  }

  Future<Database> openConnection() async {
    var databasePath = await getDatabasesPath();
    final databaseFinalPath = join(databasePath, _databaseName);

    if (_db == null) {
      await _lock.synchronized(() async {
        if (_db == null) {
          _db = await openDatabase(
            databaseFinalPath,
            version: _version,
            onConfigure: _onConfigure,
            onCreate: _onCreate,
            onDowngrade: _onDowngrade,
            onUpgrade: _onUpgrade,
          );
        }
      });
    }
    return _db!;
  }

  void closeConnection() {
    _db?.close();
    _db = null;
  }

  Future<void> _onConfigure(Database db) async {
    await db.execute('PRAGMA foreign_keys = ON');
  }

  Future<void> _onCreate(Database db, int version) async {

      final batch = db.batch();

      final migrations = SqliteMigrationFactory().getCreateMigration();
      for (var migration in migrations) {
        migration.create(batch);
      }

      batch.commit();
  }

  Future<void> _onDowngrade(Database db, int oldVersion, int version) async {
      final batch = db.batch();

      final migrations = SqliteMigrationFactory().getUpgradeMigration(oldVersion);
      for (var migration in migrations) {
        migration.update(batch);
      }

      batch.commit();
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int version) async {}
}
