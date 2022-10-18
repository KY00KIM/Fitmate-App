import 'package:flutter/material.dart';

class First extends StatefulWidget {
  @override
  _FirstState createState() => _FirstState();
}

class _FirstState extends State<First> with AutomaticKeepAliveClientMixin {

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    print("퍼스트 페이지");
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text('First'),
    );
  }
}
