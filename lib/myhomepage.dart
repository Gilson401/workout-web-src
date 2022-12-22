import 'package:flutter/material.dart';

import 'mywidget.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 1;
  int _columItems = 1;


  void _incrementColumnItems() {
    
    setState(() {
      _columItems++;
    });
    
  }

  void _incrementCounter() {
    if(_counter < 10){
    setState(() {
      _counter++;
    });
    }
  }


void _decrementCounter() {
  if(_counter > 2){
    setState(() {
      _counter--;
    });
  }
}

void _resetCounter(){
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
              Row(
                children: [
                  Container(
                    color: Color.fromARGB(5 * _counter, 255, 9, 9),
                    width: MediaQuery.of(context).size.width / 3,
                    height: 300,
                    child: const MyWidget(),
                  ),
                  for (var i = 0; i < _counter; i++)
                    Container(
                      color: Color.fromARGB(10 * i, 255 - (10 * i)  , 30 * i, 9 ),
                      width: ((2 * MediaQuery.of(context).size.width / 3) / _counter) - (_counter * 2) ,
                      height: 300,
                      margin: const EdgeInsets.all(2),
                      child: Center(
                          child: Text(
                        'Item: $i',
                        softWrap: true,
                      )),
                    ),
                ],
              ),
              Container(
                margin:  const EdgeInsets.only(bottom: 5, left: 5, right: 5, top: 10) ,
                color: Colors.lightBlueAccent,
                width: MediaQuery.of(context).size.width,
                height: 100,
                child: Center(child: Text('TODO: ADD CONTENT $_counter')),
              ),
              for (var i = 0; i < _columItems; i++)
              Container(
                margin:  const EdgeInsets.only(bottom: 5, left: 5, right: 5) ,
                width: MediaQuery.of(context).size.width,
                height: 100,
                decoration:  BoxDecoration(
                  color: Color.fromARGB(255 - 20 * i,  30 * i, 255 - (10 * i)  , 9 ),
                  borderRadius: BorderRadius.all(
                     Radius.circular( 1 + i.toDouble())
                  )
                  ),
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
