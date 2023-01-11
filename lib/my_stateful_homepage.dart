import 'package:flutter/material.dart';
import 'package:hello_flutter/workout.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';
import 'apiItemsList.dart';

class MyStatefullHomePage extends StatefulWidget {
  const MyStatefullHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyStatefullHomePage> createState() => _MyStatefullHomePageState();
}

class _MyStatefullHomePageState extends State<MyStatefullHomePage> {
  Workout _seletctedWorkout = Workout(
      nome: 'Selecione um exercício', grupoMuscular: '', orientacoes: []);

  final _controller = YoutubePlayerController.fromVideoId(
    videoId: '',
    autoPlay: true,
    params: const YoutubePlayerParams(
      showFullscreenButton: true,
      mute: true,
    ),
  );

  void setCurrentWorkout(Workout workout) async {
    setState(() {
      _seletctedWorkout = workout;
    });

    print("VídeoId Carregado. ${_seletctedWorkout.videoId}");

    _controller.loadVideoById(videoId: workout.videoId);

    _controller.pauseVideo();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var apiItemsList = ApiItemsList(setWorkout: setCurrentWorkout);
    var textStyle = TextStyle(
        // fontSize: 17,
        fontFamily: 'Raleway',
        fontWeight: FontWeight.w700);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        elevation: 10,
      ),
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Column(
                children: [
                  apiItemsList,
                  Container(
                    color: Color.fromARGB(255, 255, 255, 255),
                    height: 350,
                    width: MediaQuery.of(context).size.width,
                    margin: const EdgeInsets.all(2),
                    padding: const EdgeInsets.all(5),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            SizedBox(
                              height: 300,
                              width: MediaQuery.of(context).size.width,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(
                                    'Exercício: ${_seletctedWorkout.nome}',
                                    softWrap: true,
                                    style: textStyle,
                                  ),
                                  Text(
                                      "Repetições: ${_seletctedWorkout.repeticoes}",
                                      softWrap: true),
                                  Text("Carga: ${_seletctedWorkout.carga}",
                                      softWrap: true),
                                  for (var i = 0;
                                      i < _seletctedWorkout.orientacoes!.length;
                                      i++)
                                    Text(_seletctedWorkout.orientacoes![i],
                                        softWrap: true),
                                ],
                              ),
                            ),
                            if (_seletctedWorkout.image != "")
                              SizedBox(
                                height: 300,
                                width: MediaQuery.of(context).size.width,
                                child: Image.network(_seletctedWorkout.image),
                              ),
                            if (_seletctedWorkout.videoId != "")
                              SizedBox(
                                height: 300,
                                width: MediaQuery.of(context).size.width,
                                child: YoutubePlayer(
                                  controller: _controller,
                                  aspectRatio: 16 / 9,
                                  backgroundColor:
                                      Color.fromARGB(255, 35, 35, 87),
                                ),
                              ),
                          ]),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        elevation: 10,
        color: Colors.white,
        child: IconTheme(
            data: IconThemeData(color: Theme.of(context).colorScheme.onPrimary),
            child: Row(
              children: [],
            )),
      ),
    );
  }
}
