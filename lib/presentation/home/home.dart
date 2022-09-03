import 'package:fitmate/ui/bar_widget.dart';
import 'package:fitmate/ui/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../data/post_api.dart';
import '../../domain/model/posts.dart';

class HomePage extends StatefulWidget {
  bool reload;

  HomePage({Key? key, required this.reload}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin {
  bool refresh = false;
  int count = 0;
  final postApi = PostApi();
  final barWidget = BarWidget();

  @override
  void initState() {
    super.initState();
  }

  //새로고침 방지
  @override
  bool get wantKeepAlive => true;

  // Text('${snapshot.data?[index]['post_title']}');
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: whiteTheme,
      appBar: barWidget.appBar(context),
      bottomNavigationBar: barWidget.bottomNavigationBar(context, 1),
      body: SafeArea(
        child: Text("home"),
      ),
    );
  }
}
