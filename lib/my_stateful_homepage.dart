import 'package:flutter/material.dart';
import 'package:hello_flutter/workout.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

import 'apiItemsList.dart';
import 'grupo_muscular.dart';

class MyStatefullHomePage extends StatefulWidget {
  const MyStatefullHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyStatefullHomePage> createState() => _MyStatefullHomePageState();
}

class _MyStatefullHomePageState extends State<MyStatefullHomePage> {
  int _counter = 1;
  int _columItems = 1;


  Workout _seletctedWorkout =
      Workout(nome: 'Selecione um exercício', grupoMuscular: '');

  final _controller = YoutubePlayerController.fromVideoId(
    videoId: '',
    autoPlay: true,
    params: const YoutubePlayerParams(
      showFullscreenButton: true,
      mute:true,
      ),
  );

  void setCurrentWorkout(Workout workout) async {
   

    setState(() {
      _seletctedWorkout = workout;
    });

     print(
        "VídeoId Carregado. ${_seletctedWorkout.videoId}");

    _controller.loadVideoById(videoId: workout.videoId);
  
     _controller.pauseVideo();
  }

  void _incrementColumnItems() {
    setState(() {
      _columItems++;
    });
  }

  void _incrementCounter() {
    if (_counter < 10) {
      setState(() {
        _counter++;
      });
    }
  }

  void _decrementCounter() {
    if (_counter > 2) {
      setState(() {
        _counter--;
      });
    }
  }

  void _resetCounter() {
    setState(() {
      _counter = 2;
    });
  }

  @override
  void initState() {
    super.initState();
    print('InitState: Valor inicial de _counter é $_counter');

    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    var apiItemsList = ApiItemsList(setWorkout: setCurrentWorkout);


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
                    height: 300,
                    width: MediaQuery.of(context).size.width,
                    margin: const EdgeInsets.all(2),
                    padding: const EdgeInsets.all(5),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text('Exercício: ${_seletctedWorkout.nome}',
                              softWrap: true),
                          Text(_seletctedWorkout.repeticoes, softWrap: true),
                          Text(_seletctedWorkout.carga, softWrap: true),
                          if (_seletctedWorkout.image != "")
                            SizedBox(
                              height: 100,
                              width: MediaQuery.of(context).size.width,
                              child: Image.network(_seletctedWorkout.image),
                            ),
                        ]),
                  ),
                ],
              ),
            
              if (_seletctedWorkout.videoId != "" )
                YoutubePlayer(
                  controller: _controller,
                  aspectRatio: 16 / 9,
                  backgroundColor: Color.fromARGB(255, 35, 35, 87),
                ),
          ],
          ),
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   // onPressed: _incrementCounter,
      //   tooltip: 'Increment',
      //   child: const Icon(Icons.restore),
      //   onPressed: () {
      //     _resetCounter();
      //   },
      // ),
      bottomNavigationBar: BottomAppBar(
        elevation: 10,
        color: Colors.white,
        child: IconTheme(
            data: IconThemeData(color: Theme.of(context).colorScheme.onPrimary),
            child: Row(
              children: [
                IconButton(
                  tooltip: 'decrement',
                  icon: const Icon(Icons.menu),
                  onPressed: () {
                    print('You clicker in Open nav menu $_counter');
                  },
                ),
                IconButton(
                  tooltip: 'Decrement Counter',
                  icon: const Icon(Icons.remove_circle_outline),
                  onPressed: () {
                    _decrementCounter();
                  },
                ),
                IconButton(
                  tooltip: 'Decrement Counter',
                  icon: const Icon(Icons.add_circle_outline),
                  onPressed: () {
                    _incrementCounter();
                  },
                ),
                IconButton(
                  tooltip: 'Add Column Item',
                  icon: const Icon(Icons.playlist_add_circle),
                  onPressed: () {
                    _incrementColumnItems();
                  },
                ),
              ],
            )),
      ),
    );
  }
}
