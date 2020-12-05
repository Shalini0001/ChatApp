import 'package:animationApp/helper/helperFunction.dart';
import 'package:animationApp/services/database.dart';
import 'package:animationApp/screen/chat.dart';
import 'package:animationApp/widgets/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

User loggedInUser;
//String _myName;

class SearchChat extends StatefulWidget {
  @override
  _SearchChatState createState() => _SearchChatState();
}

class _SearchChatState extends State<SearchChat> {
  DatabaseMethods databaseMethods = DatabaseMethods();
  TextEditingController searchTextEditingController = TextEditingController();

  QuerySnapshot searchSnapshot;
  // final _myName = loggedInUser.email;
  sendToChatroom({String userEmail}) {
    if (userEmail != loggedInUser.email) {
      print(userEmail);
      print(loggedInUser.email);
      String chatRoomId = getChatRoomId(userEmail, loggedInUser.email);
      List<String> users = [userEmail, loggedInUser.email];
      Map<String, dynamic> chatRoomMap = {
        "users": users,
        "chatRoomId": chatRoomId
      };
      DatabaseMethods().createChatRoom(chatRoomId, chatRoomMap);
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => Chat(chatRoomId)));
    }
  }

  Widget searchList() {
    return searchSnapshot != null
        ? ListView.builder(
            itemBuilder: (context, index) {
              return SearchTile(
                userName: searchSnapshot.docs[index].get("username"),
                userEmail: searchSnapshot.docs[index].get("email"),
              );
            },
            shrinkWrap: true,
            itemCount: searchSnapshot.docs.length,
          )
        : Container();
  }

  // ignore: non_constant_identifier_names
  Widget SearchTile({String userName, String userEmail}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 8),
      decoration: BoxDecoration(
          color: Colors.grey[300], borderRadius: BorderRadius.circular(15)),
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                userName,
                //style: mediumWhiteTextStyle(),
              ),
              Text(
                userEmail,
                //style: mediumWhiteTextStyle(),
              ),
            ],
          ),
          Spacer(),
          CircleAvatar(
            radius: 25,
            backgroundColor: Colors.grey,
            child: IconButton(
              onPressed: () {
                sendToChatroom(userEmail: userEmail);
              },
              icon: Icon(Icons.send),
              color: Colors.blue,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    Firebase.initializeApp();
    getCurrentUser();

    // getUserInfo();
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

  /*getUserInfo() async {
    _myName = loggedInUser.email;
    setState(() {});
    print(_myName);
  }*/

  initiateSearch() {
    databaseMethods
        .getUserByUsername(searchTextEditingController.text)
        .then((value) {
      setState(() {
        searchSnapshot = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context),
      body: Container(
        child: Column(
          children: [
            Container(
              color: Colors.blueGrey[100],
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      //style: whiteTextStyle(),
                      controller: searchTextEditingController,
                      decoration: InputDecoration(
                          hintText: "Search ",
                          hintStyle:
                              TextStyle(color: Colors.black, fontSize: 20),
                          border: InputBorder.none),
                    ),
                  ),
                  IconButton(
                    iconSize: 25,
                    color: Colors.blue,
                    icon: Icon(Icons.search),
                    onPressed: () {
                      print(loggedInUser.email);
                      initiateSearch();
                    },
                  )
                ],
              ),
            ),
            searchList(),
          ],
        ),
      ),
    );
  }
}

getChatRoomId(String a, String b) {
  if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
    return "$b\_$a";
  } else
    return "$a\_$b";
}
