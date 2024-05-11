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

  static void showSnackbar(
      {required BuildContext context, String message = ""}) {
    final snackBar = SnackBar(
      action: SnackBarAction(
        textColor: Colors.white,
        label: 'Fechar',
        onPressed: () {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
        },
      ),
      content: Text(message),
      duration: const Duration(milliseconds: 6000),
      // width: 280.0, // Width of the SnackBar.
      padding: const EdgeInsets.symmetric(
        horizontal: 8.0, // Inner padding for SnackBar content.
      ),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
