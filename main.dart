import 'package:animationApp/screen/chatroom.dart';
import 'package:animationApp/screen/login.dart';
import 'package:animationApp/screen/Register.dart';
import 'package:animationApp/screen/search.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:splashscreen/splashscreen.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: "screen",
      routes: {
        "reg": (context) => RegisterScreen(),
        "login": (context) => LoginScreen(),
        "screen": (context) => MyApp(),
        "chat": (context) => ChatRoom(),
        // "current": (context) => Current(),
      },
    ),
  );
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return new SplashScreen(
      seconds: 8,
      navigateAfterSeconds: new LoginScreen(),
      title: new Text(
        'Welcome!',
        style: new TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 30.0,
            color: Colors.black,
            decorationColor: Colors.black),
      ),
      image: new Image.asset('images/chat1.jpg'),
      //backgroundGradient: new LinearGradient(colors: [Colors.cyan, Colors.blue], begin: Alignment.topLeft, end: Alignment.bottomRight),
      backgroundColor: Colors.white,
      styleTextUnderTheLoader: new TextStyle(),
      photoSize: 150.0,
      //onClick: () => print("Your storage"),
      loaderColor: Colors.green,
    );
  }
}
