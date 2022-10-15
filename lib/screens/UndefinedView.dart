import 'package:flutter/material.dart';

class UndefinedView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Home View',
            ),
          ],
        ),
      ),
    );
  }
}
