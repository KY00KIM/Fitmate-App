import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitmate/screens/makePromise.dart';
import 'package:fitmate/screens/matching.dart';
import 'package:fitmate/screens/profile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fitmate/screens/writing.dart';
import 'package:fitmate/screens/detail.dart';
import 'package:fitmate/screens/notice.dart';
import 'package:http/http.dart' as http;

import 'package:flutter_chat_bubble/bubble_type.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:flutter_chat_bubble/clippers/chat_bubble_clipper_6.dart';

import '../utils/data.dart';
import 'chatList.dart';

class ChatPage extends StatefulWidget {
  String name;
  String imageUrl;
  String uid;
  String userId;
  ChatPage({Key? key, required this.name, required this.imageUrl, required this.uid, required this.userId}) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  CollectionReference chats = FirebaseFirestore.instance.collection('chats');
  var chatDocId;
  var _textController = new TextEditingController();
  var data;
  @override
  void initState() {
    super.initState();
    checkUser();
  }

  void checkUser() async {
    await chats
        .where('users', isEqualTo: {widget.uid: null, UserData['social']['user_id']: null})
        .limit(1)
        .get()
        .then(
          (QuerySnapshot querySnapshot) async {
        if (querySnapshot.docs.isNotEmpty) {
          setState(() {
            chatDocId = querySnapshot.docs.single.id;
          });

          print(chatDocId);
        } else {
          await chats.add({
            'users': {widget.uid: null, UserData['social']['user_id']: null},
            'names':{widget.uid:widget.name, UserData['social']['user_id']:UserData['social']['user_name'] }
          }).then((value) => {chatDocId = value});
        }
      },
    )
        .catchError((error) {});
  }

  void sendMessage(String msg) {
    if (msg == '') return;
    chats.doc(chatDocId).collection('messages').add({
      'createdOn': FieldValue.serverTimestamp(),
      'uid': UserData['social']['user_id'],
      'friendName':widget.uid,
      'msg': msg
    }).then((value) {
      _textController.text = '';
    });
  }

  bool isSender(String friend) {
    return friend == UserData['social']['user_id'];
  }

  Alignment getAlignment(friend) {
    if (friend == UserData['social']['user_id']) {
      return Alignment.topRight;
    }
    return Alignment.topLeft;
  }


  @override
  Widget build(BuildContext context) {
    /*
    final Size size = MediaQuery.of(context).size;
    print("name : ${widget.name}");
    print("imageUrl : ${widget.imageUrl}");
    print("uid : ${widget.uid}");
    print("userId : ${widget.userId}");
    return Scaffold(
      backgroundColor: Color(0xFF22232A),
      appBar: AppBar(
        //centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back,
          ),
        ),
        elevation: 0.0,
        shape: Border(
          bottom: BorderSide(
            color: Color(0xFF3D3D3D),
            width: 1,
          ),
        ),
        backgroundColor: Color(0xFF22232A),
        title: Transform(
          transform: Matrix4.translationValues(-20.0, 0.0, 0.0),
          child: Text(
            "${widget.name}",
            style: TextStyle(
              color: Color(0xFFffffff),
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
            child: ElevatedButton(
              onPressed: () async {
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) => MakePromisePage(partnerId : widget.userId),
                    transitionDuration: Duration.zero,
                    reverseTransitionDuration: Duration.zero,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                minimumSize: Size(80, 35),
                primary: Color(0xFF22232A),
                alignment: Alignment.center,
                side: BorderSide(
                  width: 1.5,
                  color: Color(0xFFffffff),
                ),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(7.0)),
              ),
              child:Text(
                '약속잡기',
                style: TextStyle(
                  color: Color(0xFFffffff),
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          SizedBox(width: size.width * 0.05,)
          /*
          SizedBox(width: 10,),
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                barrierDismissible: true,
                builder: (BuildContext context) {
                  return AlertDialog(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0))),
                    backgroundColor: Color(0xFF22232A),
                    title: Text(
                      '채팅방을 나가면 채팅 목록 및 대화 내용이 삭제되고 복구할 수 없습니다. 나가시겠습니까?',
                      style: TextStyle(
                        color: Color(0xFFffffff),
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    content: SingleChildScrollView(
                      child: ListBody(
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              setState(() {

                              });
                            },
                            child: Text(
                              '네, 나갈래요',
                              style: TextStyle(
                                color: Color(0xFFffffff),
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              elevation: 0,
                              primary: Color(0xFF3889D1),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text(
                              '취소',
                              style: TextStyle(
                                color: Color(0xFF757575),
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              primary: Color(0xFF22232A),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
            icon: Padding(
              padding: EdgeInsets.only(right: 200),
              child: Icon(
                Icons.delete,
                color: Color(0xFFffffff),
                size: 30.0,
              ),
            ),
          )
           */
        ],
      ),
      body: SafeArea(
        child: StreamBuilder<QuerySnapshot>(
      stream: chats
          .doc(chatDocId.toString())
          .collection('messages')
          .orderBy('createdOn', descending: true)
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text("Something went wrong"),
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: Text("Loading"),
          );
        }

        if (snapshot.hasData) {
          var data;
          return CupertinoPageScaffold(
            child: Column(
              children: [
                Expanded(
                  child: ListView(
                    reverse: true,
                    children: snapshot.data!.docs.map(
                          (DocumentSnapshot document) {
                        data = document.data()!;
                        //print(data.toString());
                        //print(document.toString());
                        //print(data['msg'].toString());
                        return Padding(
                          padding:
                          const EdgeInsets.symmetric(horizontal: 8.0),
                          child: ChatBubble(
                            clipper: ChatBubbleClipper6(
                              nipSize: 0,
                              radius: 0,
                              type: isSender(data['uid'].toString())
                                  ? BubbleType.sendBubble
                                  : BubbleType.receiverBubble,
                            ),
                            alignment: getAlignment(data['uid']?.toString()),
                            margin: EdgeInsets.only(top: 20),
                            backGroundColor: isSender(data['uid'].toString())
                                ? Color(0xFF08C187)
                                : Color(0xffE7E7ED),
                            child: Container(
                              constraints: BoxConstraints(
                                maxWidth:
                                MediaQuery.of(context).size.width * 0.7,
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.start,
                                    children: [
                                      Text(data['msg'],
                                          style: TextStyle(
                                              color: isSender(
                                                  data['uid'].toString())
                                                  ? Colors.white
                                                  : Colors.black),
                                          maxLines: 100,
                                          overflow: TextOverflow.ellipsis)
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text(
                                        data['createdOn'] == null
                                            ? DateTime.now().toString()
                                            : data['createdOn']
                                            .toDate()
                                            .toString(),
                                        style: TextStyle(
                                            fontSize: 10,
                                            color: isSender(
                                                data['uid'].toString())
                                                ? Colors.white
                                                : Colors.black),
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ).toList(),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 18.0),
                        child: CupertinoTextField(
                          controller: _textController,
                        ),
                      ),
                    ),
                    CupertinoButton(
                        child: Icon(Icons.send_sharp),
                        onPressed: () => sendMessage(_textController.text))
                  ],
                )
              ],
            ),
          );
        } else {
          return Container();
        }
      },
    ),
      ),
    );

     */
    return StreamBuilder<QuerySnapshot>(
      stream: chats
          .doc(chatDocId)
          .collection('messages')
          .orderBy('createdOn', descending: true)
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text("Something went wrong"),
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: Text("Loading"),
          );
        }

        if (snapshot.hasData) {
          var data;
          return Scaffold(
            backgroundColor: Color(0xFF22232A),
            appBar: AppBar(
              leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.arrow_back,
                ),
              ),
              elevation: 0.0,
              shape: Border(
                bottom: BorderSide(
                  color: Color(0xFF3D3D3D),
                  width: 1,
                ),
              ),
              backgroundColor: Color(0xFF22232A),
              title: Transform(
                transform: Matrix4.translationValues(-20.0, 0.0, 0.0),
                child: Text(
                  "${widget.name}",
                  style: TextStyle(
                    color: Color(0xFFffffff),
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              actions: [
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                  child: ElevatedButton(
                    onPressed: () async {
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder: (context, animation, secondaryAnimation) => MakePromisePage(partnerId: widget.userId),
                          transitionDuration: Duration.zero,
                          reverseTransitionDuration: Duration.zero,
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(80, 35),
                      primary: Color(0xFF22232A),
                      alignment: Alignment.center,
                      side: BorderSide(
                        width: 1.5,
                        color: Color(0xFFffffff),
                      ),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(7.0)),
                    ),
                    child:Text(
                      '약속잡기',
                      style: TextStyle(
                        color: Color(0xFFffffff),
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10,),
              ],
            ),

            /*
            navigationBar: CupertinoNavigationBar(
              middle: Text('sfeefes'),
              trailing: CupertinoButton(
                padding: EdgeInsets.zero,
                onPressed: () {},
                child: Icon(CupertinoIcons.phone),
              ),
              previousPageTitle: "Back",
            ),

             */
            body: SafeArea(
              child: Column(
                children: [
                  Expanded(
                    child: ListView(
                      reverse: true,
                      children: snapshot.data!.docs.map(
                            (DocumentSnapshot document) {
                          data = document.data()!;
                          print(document.toString());
                          print(data['msg']);
                          return Padding(
                            padding:
                            const EdgeInsets.symmetric(horizontal: 8.0),
                            child: ChatBubble(
                              clipper: ChatBubbleClipper6(
                                nipSize: 0,
                                radius: 0,
                                type: isSender(data['uid'].toString())
                                    ? BubbleType.sendBubble
                                    : BubbleType.receiverBubble,
                              ),
                              alignment: getAlignment(data['uid'].toString()),
                              margin: EdgeInsets.only(top: 20),
                              backGroundColor: isSender(data['uid'].toString())
                                  ? Color(0xFF2975CF)
                                  : Color(0xff303037),
                              child: Container(
                                constraints: BoxConstraints(
                                  maxWidth: MediaQuery.of(context).size.width * 0.7,
                                ),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Flexible(
                                          child: RichText(
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 100,
                                            strutStyle: StrutStyle(fontSize: 14),
                                            text: TextSpan(
                                              text: data['msg'],
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: Color(0xFFDADADA),
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                        /*
                                        Text(data['msg'],
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Color(0xffffffff),
                                                //color: isSender(data['uid'].toString()) ? Colors.white : Colors.black
                                            ),
                                            maxLines: 100,
                                            overflow: TextOverflow.ellipsis)

                                         */
                                      ],
                                    ),
                                    /*
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text(
                                          data['createdOn'] == null
                                              ? DateTime.now().toString()
                                              : data['createdOn']
                                              .toDate()
                                              .toString(),
                                          style: TextStyle(
                                              fontSize: 10,
                                              color: Color(0xffffffff),
                                              //color: isSender(data['uid'].toString()) ? Colors.white : Colors.black
                                          ),
                                        )
                                      ],
                                    )
                                     */
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ).toList(),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 18.0),
                            child: TextField(
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Color(0xFF303037),
                              ),
                              controller: _textController,
                            ),
                          ),
                        ),
                        CupertinoButton(
                            child: Icon(Icons.send_sharp),
                            onPressed: () => sendMessage(_textController.text))
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        } else {
          return Container();
        }
      },
    );
  }
}
