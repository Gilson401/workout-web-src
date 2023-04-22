class AppConstants {

static  String storageBaseKey = 'appMyWorkout';

static  String storageWorkoutSerieDone = "${storageBaseKey}SeriesDone_";

static String seriesDoneStorageKey(int id) => "$storageWorkoutSerieDone$id";


static  String svgA = 'assets/imgs/a.svg';
static  String svgB = 'assets/imgs/b.svg';
static  String svgC = 'assets/imgs/c.svg';
static  String svgD = 'assets/imgs/d.svg';
static  String svgE = 'assets/imgs/e.svg';


}