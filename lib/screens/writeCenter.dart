import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

class WriteCenterPage extends StatefulWidget {
  const WriteCenterPage({Key? key}) : super(key: key);

  @override
  State<WriteCenterPage> createState() => _WriteCenterPageState();
}

class _WriteCenterPageState extends State<WriteCenterPage> {
  List data = [];
  String result = '';
  TextEditingController _editingController = new TextEditingController();

  Future<String> getJSONData() async {
    var url = Uri.parse('https://dapi.kakao.com/v2/local/search/keyword.json?size=15&sort=accuracy&query=${_editingController.text}&page=45');
    var response = await http
        .get(url, headers: {"Authorization": "KakaoAK 281e3d7d678f26ad3b6020d8fc517852"});

    setState(() {
      data.clear();
      var dataConvertedToJSON = json.decode(response.body);
      List result = dataConvertedToJSON["documents"];
      data.addAll(result);
    });
    return response.body;
  }

  Widget posets(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Container(
      child: data.length == 0
          ? Center(
        child: Text(
          "피트니스장을 찾을 수 없습니다",
          style: TextStyle(
            fontSize: 20,
            color: Color(0xFF757575),
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
      )
          : ListView.builder(itemBuilder: (context, index) {
        return ElevatedButton(
          /*
          onPressed: () {

            //Navigator.of(context).pop(data[index]);
            //log(data.toString());
            //Navigator.pop(context, Arguments(returnValue: ReturnValue(result:'Yep!')));
          },
           */
          onPressed: () => Navigator.pop(context),
          //onPressed: () {print(data[index]);},
          style: ElevatedButton.styleFrom(
            minimumSize: Size(size.width, 50),
            primary: Color(0xFF22232A),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(5, 0, 15, 0),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    data[index]['place_name'].toString(),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFDADADA),
                    ),
                  ),
                  Flexible(
                    child: RichText(
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      text: TextSpan(
                        text: data[index]['address_name'].toString(),
                        style: TextStyle(
                          color: Color(0xFF757575),
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ),
                ]
            ),
          ),
        );
      },
        itemCount: data.length,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    //var res = searchCenter('YB휘트니스');
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: const Color(0xff22232A),
        appBar: AppBar(
          elevation: 0,
          leading: Container(
            margin: EdgeInsets.only(left: 10),
            child: IconButton(
              icon: Icon(
                Icons.arrow_back_ios,
                color: Color(0xFF757575),
                size: 25,
              ),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          backgroundColor: Color(0xFF22232A),
          title: Transform(
            transform:  Matrix4.translationValues(-15.0, 0.0, 0.0),
            child: SizedBox(
              width: size.width * 0.9,
              height: 40,
              child: TextField(
                onSubmitted: (value) async {
                  getJSONData();
                },
                controller: _editingController,
                style: TextStyle(
                  color: Colors.white,
                ),
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.search,
                decoration: InputDecoration(
                    fillColor: Color(0xFF15161B),
                    filled: true,
                    contentPadding: EdgeInsets.fromLTRB(15, 0, 0, 10),
                    hintText: '피트니스장 검색',
                    hintStyle: TextStyle(
                      color: Color(0xFF757575),
                      fontSize: 17,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(width: 1, color: Color(0xFF878E97)),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(width: 1, color: Color(0xFF878E97)),
                      borderRadius: BorderRadius.circular(5),
                    )
                ),
              ),
            ),
          ),
        ),
        body: Container(
          child: data.length == 0
              ? Center(
            child: Text(
              "피트니스장을 찾을 수 없습니다",
              style: TextStyle(
                fontSize: 20,
                color: Color(0xFF757575),
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          )
              : ListView.builder(itemBuilder: (context, index) {
            return ElevatedButton(
              //onPressed: () => Navigator.pop(context),
              /*
              onPressed: () {
                Route route = MaterialPageRoute(builder: (context) => SignupPage());
                Navigator.pushReplacement(context, route);
              },

               */
              onPressed: () {
                print(data[index]);
                Navigator.of(context, rootNavigator: true).pop(data[index]);
              },
              //onPressed: () {print(data[index]);},
              style: ElevatedButton.styleFrom(
                minimumSize: Size(size.width, 50),
                primary: Color(0xFF22232A),
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(5, 0, 15, 0),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        data[index]['place_name'].toString(),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFDADADA),
                        ),
                      ),
                      SizedBox(width: 20,),
                      Flexible(
                        child: RichText(
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          text: TextSpan(
                            text: data[index]['address_name'].toString(),
                            style: TextStyle(
                              color: Color(0xFF757575),
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ),
                    ]
                ),
              ),
            );
          },
            itemCount: data.length,
          ),
        ),
      ),
    );
  }
}

