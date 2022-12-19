
import 'package:flutter/material.dart';

import 'mywidget.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}


class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Row(
              children: [
                Container(
                  color: Color.fromARGB(5, 255, 9, 9),
                  width: MediaQuery.of(context).size.width / 3,
                  height: 300,
                  child: const MyWidget(),
                ),
                Container(
                  color: Color.fromARGB(255, 67, 71, 73),
                  width: MediaQuery.of(context).size.width / 3,
                  height: 300,
                  child: Center(child: const Text(
                    'Gray Container',
                    style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
                   )),
                ),
                Container(
                  color: Color.fromARGB(255, 233, 7, 7),
                  width: MediaQuery.of(context).size.width / 3,
                  height: 300,
                  child: Center(child: const Text('Red Container',
                  style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
                  )),
                ),
              ],
            ),
            Expanded(
              child: Container(
                color: Colors.lightBlueAccent,
                width: MediaQuery.of(context).size.width,
                height: 100,
                child: Center(child: const Text('TODO: ADD CONTENT')),
              ),
            ),
            Expanded(
              child: Container(
                color: Colors.greenAccent,
                width: MediaQuery.of(context).size.width,
                child:
                    Center(child: const Text('TODO: ADD CONTENT')),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.access_time),
      ),
      bottomNavigationBar: BottomAppBar(
        elevation: 10,
        color: Colors.white,
        child: IconTheme(
            data: IconThemeData(color: Theme.of(context).colorScheme.onPrimary),
            child: Row(
              children: [
                IconButton(
                  tooltip: 'Open navigation menu',
                  icon: const Icon(Icons.menu),
                  onPressed: () {
                    print('You clicker in Open nav menu');
                  },
                ),
              ],
            )),
      ),
    );
  }
}
