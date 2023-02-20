import 'package:flutter/material.dart';
import 'package:hello_flutter/utils/home_controller.dart';


class StatelessHomePage extends StatelessWidget {
  const StatelessHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
  var controller = HomeController.of(context);
  final deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text('Stateless HomePage ${controller.value}'),
        elevation: 10,
      ),
      body: Center(
        
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Container(
              color: Color.fromARGB(255, 214, 101, 101),
              width: MediaQuery.of(context).size.width,
              height: 100,
              child: Center(
                  child: Text(
                'Father data: ${controller.homeControllerStringVar}',
                style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
              )),
            ),
            Expanded(
              child: Container(
                color: Colors.lightBlueAccent,
                width: MediaQuery.of(context).size.width,
                height: 100,
                child: Center(
                    child: Text('controller.value: ${controller.value}')),
              ),
            ),
            Expanded(
              child: Container(
                color: Colors.greenAccent,
                width: MediaQuery.of(context).size.width,
                child: Center(child: Text('Text from build : $deviceWidth')),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          controller.increment();
          print('Clicou no Floating Button');
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
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
                    print('You clicked in menu inferior');
                  },
                ),
              ],
            )),
      ),
    );
  }
}
