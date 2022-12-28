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
  int _counter = 1;
  int _columItems = 1;
  Workout _seletctedWorkout =
      Workout(nome: 'Selecione um exercício', grupoMuscular: '');

  final _controller = YoutubePlayerController.fromVideoId(
    videoId: '',
    autoPlay: false,
    params: const YoutubePlayerParams(showFullscreenButton: true),
  );

  void setCurrentWorkout(Workout workout) async {
    print(
        "O método addInWorkoutList em MyStatefullHomePage foi chamado. ${workout.toString()}");

    setState(() {
      _seletctedWorkout = workout;
    });

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

    List<String> gruposMusculares = [
      'Peito e Tríceps',
      'Pernas',
      'Ombros',
      'Bíceps Costas'
    ];

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
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    for (var i = 0; i < gruposMusculares.length; i++)
                      InkWell(
                        onTap: () {
                          print('Selecionou grupo ${gruposMusculares[i]}');
                        },
                        splashColor: Colors.blue,
                        splashFactory: InkSplash.splashFactory,
                        child: Container(
                          margin: const EdgeInsets.all(5),
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                              color: Color.fromARGB(255, 100, 165, 250),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12))),
                          child: Center(child: Text(gruposMusculares[i])),
                        ),
                      ),
                  ],
                ),
              ),
              Column(
                children: [
                  Container(
                    color: Color.fromARGB(5 * _counter, 255, 9, 9),
                    width: MediaQuery.of(context).size.width ,
                    height: 300,
                    child: apiItemsList,
                  ),
                  Container(
                    color: Color.fromARGB(10, 255, 30, 9),
                    height: 300,
                    margin: const EdgeInsets.all(2),
                    padding: const EdgeInsets.all(12),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text('Exercício: ${_seletctedWorkout.nome}',
                              softWrap: true),
                          Text(_seletctedWorkout.repeticoes, softWrap: true),
                          Text(_seletctedWorkout.carga, softWrap: true),
                          SizedBox(
                            height: 100,
                            width: MediaQuery.of(context).size.width,
                            child: Image.network(_seletctedWorkout.image),
                          ),
                        ]),
                  ),
                ],
              ),
              if (_seletctedWorkout.videoId != "")
                YoutubePlayer(
                  controller: _controller,
                  aspectRatio: 16 / 9,
                  backgroundColor: Color.fromARGB(255, 35, 35, 87),
                ),
              SizedBox(
                height: 100,
                width: double.infinity,
                child: ListView.builder(
                    itemCount: 5,
                    clipBehavior: Clip.hardEdge,
                    itemBuilder: (context, index) {
                      return ListTile(
                        isThreeLine: true,
                        title: Text('Item: $index'),
                        subtitle: Text(
                            'Item de ListViewBuilder $index: Lorem Ipsum Dolor Lorem Ipsum Dolor  Lorem Ipsum Dolor Lorem Ipsum Dolor '),
                        // tileColor: Color.fromARGB(30 * index, 255 - (10 * index), 30 * index, 9),
                      );
                    }),
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    for (var i = 0; i < _counter; i++)
                      Container(
                        margin:
                            const EdgeInsets.only(bottom: 5, left: 5, right: 5),
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                            color: Color.fromARGB(
                                255 - (20 * i), 255 - (10 * i), 30 * i, 9),
                            borderRadius:
                                BorderRadius.all(Radius.circular(50))),
                        child: Center(
                            child: Text('Container em SingleChildScrollView')),
                      ),
                  ],
                ),
              ),
              if (_columItems < 5)
                Container(
                  margin: const EdgeInsets.all(5),
                  color: Colors.lightBlueAccent,
                  width: MediaQuery.of(context).size.width,
                  height: 100,
                  child: Center(
                      child: Text(
                          'Este container renderiza quando _columItems é maior que 5. Agora _columItems é : $_counter')),
                ),
              for (var i = 0; i < _columItems; i++)
                Container(
                  margin: const EdgeInsets.only(bottom: 5, left: 5, right: 5),
                  width: MediaQuery.of(context).size.width,
                  height: 100,
                  decoration: BoxDecoration(
                      color: Color.fromARGB(
                          255 - 20 * i, 30 * i, 255 - (10 * i), 9),
                      borderRadius:
                          BorderRadius.all(Radius.circular(1 + i.toDouble()))),
                  child: Center(child: Text('Column item $i')),
                ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        // onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.restore),
        onPressed: () {
          _resetCounter();
        },
      ),
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
