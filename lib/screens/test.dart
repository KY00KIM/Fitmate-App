import 'package:flutter/material.dart';



class HomeScreen extends StatefulWidget{
  _HomeScreen createState()=> _HomeScreen();
}

class _HomeScreen extends State<HomeScreen>{
  late String result = 'pick';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Returning data home"),
      ),
      body: Center(
        child: Builder(
          builder: (context) {
            return ElevatedButton(
              child: Text("$result"),
              onPressed: () async {
                final temp = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SelectionScreen(),
                  ),
                );
                setState() {
                  result = temp;
                }
              },
            );
          },
        ),
      ),
    );
  }
}

class SelectionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Returning data selectoin")),
      body: Center(
        child: Column(
          children: <Widget>[
            RaisedButton(
              child: Text("One"),
              onPressed: () {
                Navigator.pop(context, "One");
              },
            ),
            RaisedButton(
              child: Text("Two"),
              onPressed: () {
                Navigator.pop(context, "Two");
              },
            )
          ],
        ),
      ),
    );
  }
}

