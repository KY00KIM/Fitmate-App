import 'dart:convert';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitmate/presentation/makePromise.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/clippers/chat_bubble_clipper_1.dart';
import 'package:http/http.dart' as http;

import 'package:flutter_chat_bubble/bubble_type.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';

import '../domain/util.dart';
import 'chatList.dart';

class ChatPage extends StatefulWidget {
  String name;
  String imageUrl;
  String uid;
  String userId;
  String chatId;
  ChatPage({Key? key, required this.chatId, required this.name, required this.imageUrl, required this.uid, required this.userId}) : super(key: key);

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
  }

  Future<bool> checkUser() async {
    while(chatDocId.runtimeType.toString() != 'String') {
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

          } else {
            await chats.add({
              'users': {widget.uid: null, UserData['social']['user_id']: null},
              'names':{widget.uid:widget.name, UserData['social']['user_id']:UserData['social']['user_name'] }
            }).then((value) {
              setState(() {
                chatDocId = value;
              });
            });
          }
        },
      )
          .catchError((error) {
      });
    }
    return true;
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
    print("chat Id : ${widget.chatId}");
    print("docId : $chatDocId");
    return FutureBuilder(
      future: checkUser(),
      builder: (context, snapshot) {
        print("snapshot : ${snapshot.data}");
        if (snapshot.hasData) {
          return StreamBuilder<QuerySnapshot>(
            stream: chats
                .doc(chatDocId)
                .collection('messages')
                .orderBy('createdOn', descending: true)
                .snapshots(),
            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              print("snapshot : $snapshot");
              print("snapshot data : ${snapshot.data}");
              print("snapshot hasdata : ${snapshot.hasData}");
              if (snapshot.hasError) {
                return Center(
                  child: Text("Something went wrong"),
                );
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
                /*
                return Center(
                  child: Text(
                    "Loading",
                    style: TextStyle(
                      fontSize: 13,
                      color: Color(0xFFffffff),
                    ),
                  ),
                );
                 */
              }
              if (snapshot.hasData) {
                print('snapshot data : ${snapshot.data}');
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
                      PopupMenuButton(
                        iconSize: 30,
                        color: Color(0xFF22232A),
                        shape: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0xFF757575),
                            width: 1,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
                        ),
                        elevation: 40,
                        onSelected: (value) async {
                          if (value == '/chatout') {
                            showDialog(
                              context: context,
                              //barrierDismissible: false,
                              builder: (BuildContext ctx) {
                                return AlertDialog(
                                  backgroundColor: Color(0xFF22232A),
                                  content: Text(
                                    '채팅방을 나가시면 채팅 목록 및 대화 내용이 삭제되고 복구 할 수 없어요. 채팅방을 나가시겠어요?',
                                    style: TextStyle(
                                      color: Color(0xFFffffff),
                                    ),
                                  ),

                                  actions: [
                                    Center(
                                      child: Column(
                                        children: [
                                          ElevatedButton(
                                            child: Text('네, 나갈레요.'),
                                            onPressed: () async {
                                              http.Response response = await http.delete(Uri.parse("${baseUrl}chats/${widget.chatId}"),
                                                headers: {
                                                  "Authorization" : "bearer $IdToken",
                                                  "chatroomId" : "${widget.chatId}"
                                                },
                                              );
                                              var resBody = jsonDecode(utf8.decode(response.bodyBytes));
                                              if(response.statusCode != 200 && resBody["error"]["code"] == "auth/id-token-expired") {
                                                IdToken = (await FirebaseAuth.instance.currentUser?.getIdTokenResult(true))!.token.toString();

                                                response = await http.delete(Uri.parse("${baseUrl}chats/${widget.chatId}"),
                                                  headers: {
                                                    "Authorization" : "bearer $IdToken",
                                                    "chatroomId" : "${widget.chatId}"
                                                  },
                                                );
                                                resBody = jsonDecode(utf8.decode(response.bodyBytes));
                                              }
                                              Navigator.pushReplacement(
                                                context,
                                                PageRouteBuilder(
                                                  pageBuilder: (context, animation, secondaryAnimation) => ChatListPage(),
                                                  transitionDuration: Duration.zero,
                                                  reverseTransitionDuration: Duration.zero,
                                                ),
                                              );
                                            },
                                          ),
                                          ElevatedButton(
                                            child: Text('취소'),
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                );
                              },
                            );
                          }
                        },
                        itemBuilder: (BuildContext bc) {
                          return [
                            PopupMenuItem(
                              child: Text(
                                '채팅방 나가기',
                                style: TextStyle(
                                  color: Color(0xFFffffff),
                                ),
                              ),
                              value: '/chatout',
                            ),
                          ];
                        },
                      ),
                    ],
                  ),
                  body: SafeArea(
                    child: Column(
                      children: [
                        Expanded(
                          child: ListView(
                            reverse: true,
                            children: snapshot.data!.docs.map(
                                  (DocumentSnapshot document) {
                                data = document.data()!;
                                print('document : ${document.toString()}');
                                print(data['msg']);
                                return Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                  child: ChatBubble(
                                    elevation: 0,
                                    clipper: ChatBubbleClipper1(
                                      nipWidth: 10,
                                      nipHeight: 5,
                                      type: isSender(data['uid'].toString())
                                          ? BubbleType.sendBubble
                                          : BubbleType.receiverBubble,
                                      //nipSize: 8,
                                      //radius: 0,
                                      //type: isSender(data['uid'].toString())
                                      //    ? BubbleType.sendBubble
                                      //    : BubbleType.receiverBubble,
                                    ),
                                    alignment: getAlignment(data['uid'].toString()),
                                    margin: EdgeInsets.only(top: 20),
                                    backGroundColor: isSender(data['uid'].toString())
                                        ? Color(0xFF2975CF)
                                        : Color(0xff303037),
                                    child: IntrinsicWidth(
                                      child: Container(
                                        constraints: BoxConstraints(
                                          maxWidth: MediaQuery.of(context).size.width * 0.7,
                                        ),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(10),
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
                                              ],
                                            ),
                                          ],
                                        ),
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
                                  padding: const EdgeInsets.fromLTRB(18.0, 5, 0, 10),
                                  child: TextField(
                                    style: TextStyle(
                                      color: Color(0xFF757575),
                                      fontSize: 17,
                                    ),
                                    decoration: InputDecoration(
                                      //contentPadding: EdgeInsets.symmetric(vertical: 2.0),
                                      contentPadding: EdgeInsets.fromLTRB(15, 0, 10, 0),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(Radius.circular(20.0)),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(Radius.circular(20.0)),
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(Radius.circular(20.0)),
                                      ),
                                      filled: true,
                                      fillColor: Color(0xFF303037),
                                    ),
                                    controller: _textController,
                                  ),
                                ),
                              ),
                              CupertinoButton(
                                  child: Icon(Icons.send_sharp),
                                  onPressed: () {
                                    sendMessage(_textController.value.text.toString());
                                  }
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                );
              } else {
                print("시발");
                return Container();
              }
            },
          );
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }
        // 기본적으로 로딩 Spinner를 보여줍니다.
        return Center(child: CircularProgressIndicator());
      },
    );
  }
}
