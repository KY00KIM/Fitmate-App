import 'package:fitmate/screens/Home.dart';
import 'package:fitmate/screens/Second.dart';
import 'package:fitmate/screens/UndefinedView.dart';
import 'package:flutter/material.dart';

import 'constants/router.dart';

class Router {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case homeRoute:
        return MaterialPageRoute(
            settings: RouteSettings(name: settings.name, arguments: true),
            builder: (_) => Home()
        );
      case secondRoute:
        return MaterialPageRoute(
            settings: RouteSettings(name: settings.name, arguments: true),
            builder: (_) => Second()
        );
      default:
        return MaterialPageRoute(builder: (context) => UndefinedView());
    }
  }
}
