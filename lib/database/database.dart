import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
// import 'package:sqflite/sqlite_api.dart';

class DatabaseSqLite {
  Future<Database> openConnection() async {
    final databasePath = await getDatabasesPath();

    final databaseFinalPath = join(databasePath, 'SQLITE_MY_WORKOUT');
    return await openDatabase(
      databaseFinalPath,
      version: 1, //Mude aqui o número da versão e isso chamará o onUpgrade. *Nota 1

      onConfigure: (db) async{
        await db.execute('PRAGMA foreign_keys = ON');
      },
      
      onCreate: (Database db, int version) {
        final batch = db.batch();

        String createTableQuery = '''
          create table workouts ( id Integer primary key autoincrement, carga varchar(200), data varchar(200), workoutId Integer )''';
        batch.execute(createTableQuery);

        //Toda tabela nova que vc prever no onUpgrade também deve ser replicada no onCreate *Nota 2
        String createTableQueryNew = '''
          create table workoutsNew ( id Integer primary key autoincrement, carga varchar(200), data varchar(200), workoutId Integer )''';
          batch.execute(createTableQueryNew);

        batch.commit();
      },
      onUpgrade: (Database db, int oldVersion, int version) {
        final batch = db.batch();
        if (oldVersion == 1) {
          String createTableQuery = '''
          create table workoutsNew ( id Integer primary key autoincrement, carga varchar(200), data varchar(200), workoutId Integer )''';
          batch.execute(createTableQuery);
        }
      },
      onDowngrade: (Database db, int oldVersion, int version) {},
    );
  }
}
