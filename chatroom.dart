import 'package:animationApp/screen/login.dart';
import 'package:animationApp/helper/constants.dart';
import 'package:animationApp/services/auth.dart';
import 'package:animationApp/services/database.dart';
import 'package:animationApp/screen/chat.dart';
import 'package:animationApp/screen/search.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

User loggedInUser;

class ChatRoom extends StatefulWidget {
  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  AuthMethods authMethods = AuthMethods();
  DatabaseMethods database = DatabaseMethods();
  Stream chatRoomStream;

  @override
  void initState() {
    getUserInfo();
    getCurrentUser();
    Firebase.initializeApp();
    super.initState();
  }

  Widget chatRoomBuilder() {
    return StreamBuilder(
        stream: chatRoomStream,
        builder: (context, snapshot) {
          return snapshot.hasData
              ? ListView.builder(
                  itemCount: snapshot.data.documents.length,
                  itemBuilder: (context, index) {
                    return ChatRoomsListTile(
                        snapshot.data.document[index]
                            .data()["chatRoomId"]
                            .toString()
                            .replaceAll("_", "")
                            .replaceAll(Constants.myName, ""),
                        snapshot.data.documents[index].data()["chatRoomId"]);
                  },
                )
              : Container();
        });
  }

  void getCurrentUser() async {
    try {
      // ignore: await_only_futures
      final user = await FirebaseAuth.instance.currentUser;
      if (user != null) {
        loggedInUser = user;
      }
    } catch (e) {
      print(e);
    }
  }

  getUserInfo() async {
    Constants.myName = loggedInUser.email;

    await database.getChatRooms(Constants.myName).then((value) {
      setState(() {
        chatRoomStream = value;
        print("This is name  ${Constants.myName}");
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blue[600],
        title: Text(
          "Users Chat",
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.w700, fontSize: 22),
        ),
        actions: [
          IconButton(
              icon: Icon(Icons.exit_to_app),
              onPressed: () {
                authMethods.signOut();
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => LoginScreen()));
              })
        ],
      ),
      body: chatRoomBuilder(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        focusColor: Colors.black,
        foregroundColor: Colors.black,
        child: Icon(Icons.search),
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => SearchChat()));
        },
      ),
    );
  }
}

class ChatRoomsListTile extends StatelessWidget {
  final String userName;
  final String chatRoomId;
  ChatRoomsListTile(this.userName, this.chatRoomId);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Chat(chatRoomId)));
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
        decoration: BoxDecoration(
            color: Colors.brown, borderRadius: BorderRadius.circular(12)
            // gradient: LinearGradient(
            //   colors: [Color(0xff4b4b4b), Color(0xff3d3d3d)],
            // ),
            ),
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.blueGrey[200],
              child: Text(
                "${userName.substring(0, 1).toUpperCase()}",
                style: TextStyle(color: Colors.black),
              ),
            ),
            SizedBox(
              width: 20,
            ),
            Text(
              userName,
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
              ),
            )
          ],
        ),
      ),
    );
  }
}
