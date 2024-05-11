
import 'package:flutter/material.dart';

class AppConstants {

static  String storageBaseKey = 'appMyWorkout';

static  String storageWorkoutSerieDone = "${storageBaseKey}SeriesDone_";

static String seriesDoneStorageKey(int id) => "$storageWorkoutSerieDone$id";


// static  String seriesAssetJson = 'assets/json/series.json';

static  String svgA = 'assets/imgs/a.svg';
static  String svgB = 'assets/imgs/b.svg';
static  String svgC = 'assets/imgs/c.svg';
static  String svgD = 'assets/imgs/d.svg';
static  String svgE = 'assets/imgs/e.svg';
static  String checked = 'assets/imgs/checked.svg';


  static ButtonStyle raisedButtonStyle = ElevatedButton.styleFrom(
    foregroundColor: Colors.black87,
    backgroundColor: Colors.grey[300],
    minimumSize: Size(88, 36),
    padding: EdgeInsets.symmetric(horizontal: 16),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(2)),
    ),
  );

}