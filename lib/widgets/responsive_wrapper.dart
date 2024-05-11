import 'package:flutter/material.dart';

class ResponsiveWrapper extends StatelessWidget {

  final Widget child;
  const ResponsiveWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  double padValue = constraints.maxWidth / 4;
              return Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: constraints.maxWidth > 800 ? padValue : 0),
                  child: child);
            });
  }
}