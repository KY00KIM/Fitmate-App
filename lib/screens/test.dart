import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';


class FirstRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('First Route'),
      ),
      body: Center(
        child: RaisedButton(
          child: Text('Open route'),
          onPressed: () {
            Navigator
                .of(context)
                .pushReplacement(new MaterialPageRoute(builder: (BuildContext context) => SecondRoute()));
          },
        ),
      ),
    );
  }
}

class SecondRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Second Route"),
      ),
      body: Center(
        child: RaisedButton(
          onPressed: () {
            Navigator
                .of(context)
                .pushReplacement(new MaterialPageRoute(builder: (BuildContext context) => FirstRoute()));
          },
          child: Text('Go First!'),
        ),
      ),
    );
  }
}