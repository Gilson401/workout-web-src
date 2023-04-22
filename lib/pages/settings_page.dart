
import 'package:flutter/material.dart';
import 'package:hello_flutter/utils/local_storage_workout_handler.dart';

class SettingsPage extends StatefulWidget {


   final Function? reRenderFn;

  const SettingsPage({super.key, this.reRenderFn});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {

        bool _switchValue1 = false;
  bool _switchValue2 = false;
    LocalStorageWorkoutHandler localStorageManager = LocalStorageWorkoutHandler();

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBar(
        title: Text("Configurações"),
        elevation: 10,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
        child: ListView(
        children: <Widget>[
          ElevatedButton(
            onPressed: () {
              localStorageManager.deleteAppLocalStorage().then((_) {
                if(widget.reRenderFn != null){
                  widget.reRenderFn!();
                }
              });

            },
            child: Text('Limpar LocalStorage.'),
          ),
          SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {},
            child: Text('Inativo'),
          ),
          SizedBox(height: 10),
          SwitchListTile(
            title: Text('Inativo'),
            value: _switchValue1,
            onChanged: (value) {
              setState(() {
                _switchValue1 = value;
              });
            },
          ),
          SizedBox(height: 10),
          SwitchListTile(
            title: Text('Inativo'),
            value: _switchValue2,
            onChanged: (value) {
              setState(() {
                _switchValue2 = value;
              });
            },
          ),
          SizedBox(height: 10),
        ],
    ),
      ),
    );
  }
}