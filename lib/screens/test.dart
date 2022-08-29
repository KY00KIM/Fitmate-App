import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';



class TestScreen extends StatefulWidget{
  _TestScreen createState()=> _TestScreen();
}

class _TestScreen extends State<TestScreen>{
  late String result = 'pick';
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Color(0xFF22232A),
      appBar: AppBar(
        elevation: 0.0,
        shape: Border(
          bottom: BorderSide(
            color: Color(0xFF3D3D3D),
            width: 1,
          ),
        ),
        backgroundColor: Color(0xFF22232A),
        title: Padding(
          padding: EdgeInsets.only(left: 7.0),
          child: Image.asset(
            'assets/images/fitmate_logo.png',
            height: 20,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
            },
            icon: Padding(
              padding: EdgeInsets.only(right: 200),
              child: Icon(
                Icons.notifications_none,
                color: Color(0xFFffffff),
                size: 30.0,
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        color: Color(0xFF22232A),
        child: Container(
          width: size.width,
          //height: 60.0,
          height: size.height * 0.085,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton(
                style: TextButton.styleFrom(
                  splashFactory: NoSplash.splashFactory,
                ),
                onPressed: () {
                  //Route route = MaterialPageRoute(builder: (context) => HomePage());
                  //Navigator.pushReplacement(context, route);
                },
                child: Icon(
                  //Icons.home_filled,
                  Iconsax.smart_home5,
                  color: Color(0xFFffffff),
                  //size: 30.0,
                  size: size.width * 0.0763,
                ),
              ),
              TextButton(
                style: TextButton.styleFrom(
                  splashFactory: NoSplash.splashFactory,
                ),
                onPressed: () {
                },
                child: Column(
                  children: [
                    Icon(
                      Icons.chat_bubble_outline,
                      color: Color(0xFF757575),
                      //size: 30.0,
                      size: size.width * 0.0763,
                    ),
                  ],
                ),
              ),
              TextButton(
                style: TextButton.styleFrom(
                  splashFactory: NoSplash.splashFactory,
                ),
                onPressed: () {
                },
                child: Column(
                  children: [
                    Icon(
                      Icons.map,
                      color: Color(0xFF757575),
                      //size: 30.0,
                      size: size.width * 0.0763,
                    ),
                  ],
                ),
              ),
              TextButton(
                style: TextButton.styleFrom(
                  splashFactory: NoSplash.splashFactory,
                ),
                onPressed: () {
                },
                child: Column(
                  children: [
                    Icon(
                      Icons.calendar_month,
                      color: Color(0xFF757575),
                      //size: 30.0,
                      size: size.width * 0.0763,
                    ),
                  ],
                ),
              ),
              TextButton(
                style: TextButton.styleFrom(
                  splashFactory: NoSplash.splashFactory,
                ),
                onPressed: () {
                },
                child: Column(
                  children: [
                    Icon(
                      Icons.person,
                      color: Color(0xFF757575),
                      size: size.width * 0.0763,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      body: Theme(
        data: ThemeData(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        ),
        child: Center(
          child: Theme(
            data: ThemeData(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
            ),
            child: Column(
              children: [
                IconButton(
                  onPressed: () {
                  },
                  icon: Icon( // 5
                    Iconsax.home,
                    color: Color(0xFFffffff),
                    size: size.width * 0.0763,
                  ),
                ),
                IconButton(
                  onPressed: () {
                  },
                  icon: Icon(
                    Iconsax.message,
                    color: Color(0xFFffffff),
                    size: size.width * 0.0763,
                  ),
                ),
                IconButton(
                  onPressed: () {
                  },
                  icon: Icon(
                    Iconsax.location,
                    color: Color(0xFFffffff),
                    size: size.width * 0.0763,
                  ),
                ),
                IconButton(
                  onPressed: () {
                  },
                  icon: Icon(
                    Iconsax.calendar_1,
                    color: Color(0xFFffffff),
                    size: size.width * 0.0763,
                  ),
                ),
                IconButton(
                  onPressed: () {
                  },
                  icon: Icon(
                    Iconsax.profile_circle,
                    color: Color(0xFFffffff),
                    size: size.width * 0.0763,
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

class SelectionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Returning data selectoin")),


    );
  }
}




