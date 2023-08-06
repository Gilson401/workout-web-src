
import 'dart:convert';

class WorkoutDatabaseModel {


final String carga ;
final String data;
final int workoutId;

  WorkoutDatabaseModel({

    required this.carga,
    required this.data,
    required this.workoutId,
  });


  Map<String, dynamic> toMap() {
    return <String, dynamic>{

      'carga': carga,
      'data': data,
      'workoutId': workoutId,
    };
  }

  factory WorkoutDatabaseModel.fromMap(Map<String, dynamic> map) {
    return WorkoutDatabaseModel(

      carga: map['carga'] as String,     
      data: map['data'] as String,
      workoutId: map['workoutId'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory WorkoutDatabaseModel.fromJson(String source) => WorkoutDatabaseModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'WorkoutDatabaseModel(carga: $carga, data: $data, workoutId: $workoutId)';
  }

}
