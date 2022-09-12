import 'package:fitmate/ui/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TwoWidget extends StatelessWidget {

  TwoWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteTheme,
      appBar: AppBar(),
      body: SafeArea(
        child: Center(
          child:Text("second page"),
        )
      ),
    );
  }
}
