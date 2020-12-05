import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_storage/firebase_storage.dart';

class RegisterScreen extends StatefulWidget {
  RegisterScreen({Key key}) : super(key: key);
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final GlobalKey<FormState> _registerFormKey = GlobalKey<FormState>();
  var fs = FirebaseFirestore.instance;
  String username;
  String email;
  String password;
  String confirmPassword;
  @override
  initState() {
    super.initState();
  }

  String emailValidator(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value)) {
      return 'Email format is invalid';
    } else {
      return null;
    }
  }

  String pwdValidator(String value) {
    if (value.length < 8) {
      return 'Password must be longer than 8 characters';
    } else {
      return null;
    }
  }

  String nameValidator(String value) {
    if (value.length < 3) {
      return "Please enter a valid last name.";
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
            gradient: LinearGradient(begin: Alignment.topCenter, colors: [
          Colors.blue[900],
          Colors.blue[500],
          Colors.blue[200]
        ])),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 40,
            ),
            Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Register",
                    style: TextStyle(color: Colors.white, fontSize: 40),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
            Expanded(
              child: Center(
                child: Container(
                  margin: const EdgeInsets.all(10.0),
                  height: double.infinity,
                  width: double.infinity,
                  color: Colors.white,
                  child: SingleChildScrollView(
                    child: Form(
                      key: _registerFormKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                      color: Color.fromRGBO(225, 95, 27, .3),
                                      blurRadius: 20,
                                      offset: Offset(0, 10))
                                ]),
                            child: Column(
                              children: <Widget>[
                                Container(
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      border: Border(
                                          bottom:
                                              BorderSide(color: Colors.grey))),
                                  child: TextFormField(
                                    keyboardType: TextInputType.name,
                                    onChanged: (value) {
                                      username = value;
                                    },
                                    validator: nameValidator,
                                    autocorrect: false,
                                    decoration: InputDecoration(
                                        hintStyle: TextStyle(fontSize: 20),
                                        filled: true,
                                        hintText: "Enter Username",
                                        hoverColor: Colors.white,
                                        border: InputBorder.none),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      border: Border(
                                          bottom:
                                              BorderSide(color: Colors.grey))),
                                  child: TextFormField(
                                    keyboardType: TextInputType.emailAddress,
                                    onChanged: (value) {
                                      email = value;
                                    },
                                    validator: emailValidator,
                                    autocorrect: false,
                                    decoration: InputDecoration(
                                        hintStyle: TextStyle(fontSize: 20),
                                        filled: true,
                                        hintText: "Enter Email",
                                        hoverColor: Colors.white,
                                        border: InputBorder.none),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      border: Border(
                                          bottom:
                                              BorderSide(color: Colors.grey))),
                                  child: TextFormField(
                                    obscureText: true,
                                    onChanged: (value) {
                                      password = value;
                                    },
                                    validator: pwdValidator,
                                    autocorrect: false,
                                    decoration: InputDecoration(
                                        hintStyle: TextStyle(fontSize: 20),
                                        filled: true,
                                        hintText: "Enter Password",
                                        hoverColor: Colors.white,
                                        border: InputBorder.none),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      border: Border(
                                          bottom:
                                              BorderSide(color: Colors.grey))),
                                  child: TextFormField(
                                    obscureText: true,
                                    onChanged: (value) {
                                      confirmPassword = value;
                                    },
                                    validator: pwdValidator,
                                    autocorrect: false,
                                    decoration: InputDecoration(
                                        hintStyle: TextStyle(fontSize: 20),
                                        filled: true,
                                        hintText: "Re Enter Password",
                                        hoverColor: Colors.white,
                                        border: InputBorder.none),
                                  ),
                                ),
                                SizedBox(
                                  height: 40,
                                ),
                                Container(
                                  height: 50,
                                  margin: EdgeInsets.symmetric(horizontal: 50),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                  child: (Material(
                                    color: Colors.blue,
                                    borderRadius: BorderRadius.circular(10),
                                    elevation: 10,
                                    child: MaterialButton(
                                      minWidth: 200,
                                      height: 60,
                                      child: Text(
                                        'Register',
                                        style: new TextStyle(
                                            fontSize: 20.0,
                                            color: Colors.white),
                                      ),
                                      onPressed: () {
                                        if (_registerFormKey.currentState
                                            .validate()) {
                                          if (password == confirmPassword) {
                                            FirebaseAuth.instance
                                                .createUserWithEmailAndPassword(
                                                    email: email,
                                                    password: password)
                                                .then((currentUser) => Firestore
                                                    .instance
                                                    .collection("Users")
                                                    .document(email)
                                                    .setData({
                                                      "username": username,
                                                      "email": email,
                                                    })
                                                    .then((result) => {
                                                          Navigator.pushNamed(
                                                              context, "login")
                                                        })
                                                    .catchError(
                                                        (err) => print(err)))
                                                .catchError(
                                                    (err) => print(err));
                                          } else {
                                            showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return AlertDialog(
                                                    title: Text("Error"),
                                                    content: Text(
                                                        "The passwords do not match"),
                                                    actions: <Widget>[
                                                      FlatButton(
                                                        child: Text("Close"),
                                                        onPressed: () {
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                      )
                                                    ],
                                                  );
                                                });
                                          }
                                        }
                                      },
                                    ),
                                  )),
                                ),
                                SizedBox(
                                  height: 40,
                                ),
                                Text("If you already have an account"),
                                FlatButton(
                                  child: Text("Login here!"),
                                  onPressed: () {
                                    Navigator.pushNamed(context, "login");
                                  },
                                ),
                                SizedBox(
                                  height: 40,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
