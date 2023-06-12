import 'package:flutter/material.dart';

class UiHelpers {
  void dialog({
    required BuildContext context,
    required String title,
    required String message,
  }) {
    showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: Text(title),
            contentPadding: EdgeInsets.all(25),
            children: [
              Text(message),
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Fechar'))
            ],
          );
        });
  }
}
