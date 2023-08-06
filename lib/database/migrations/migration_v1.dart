import 'package:hello_flutter/database/migrations/migration.dart';
import 'package:sqflite_common/sqlite_api.dart';

class MigrationV1 implements Migration {
  @override
  void create(Batch batch) {
      String createTableQuery = '''
          create table workouts ( id Integer primary key autoincrement, carga varchar(200), data varchar(200), workoutId Integer )''';
        batch.execute(createTableQuery);
  }

  @override
  void update(Batch batch) {
    // para a primeira versão não faz senbtido ter um Update. O método está aqui apenas por causa da interface.
  }

}