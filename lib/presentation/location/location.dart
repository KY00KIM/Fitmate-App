import 'package:flutter/material.dart';


class LocationPage extends StatefulWidget {
  const LocationPage({Key? key}) : super(key: key);

  @override
  State<LocationPage> createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: const Color(0xff22232A),
        body: SafeArea(
          child: Container(
            margin: EdgeInsets.fromLTRB(25, 35, 25, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                '동네별 매칭 보기',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 20.0
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                SizedBox(
                  width: 350,
                  height: 35,
                  child: TextField(
                    textInputAction: TextInputAction.go,
                    onSubmitted: (value) async {
                      //addressListCnt = 0;
                      //gisObjList = [];
                      //_textEditingController.text = value;
                      //await fnGetLatLon(_textEditingController.text);
                      print('입력값 : $value');
                    },
                    style: TextStyle(color: Color(0xff878E97)),
                    decoration: InputDecoration(
                      hintText: '동, 읍, 면을 입력해주세요',
                      contentPadding: EdgeInsets.fromLTRB(15, 5, 0, 0),
                      hintStyle: TextStyle(color: Color(0xff878E97)),
                      labelStyle: TextStyle(color: Color(0xff878E97)),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(7.0)),
                        borderSide: BorderSide(width: 1, color: Color(0xff878E97)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(7.0)),
                        borderSide: BorderSide(width: 1, color: Color(0xff878E97)),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(7.0)),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
