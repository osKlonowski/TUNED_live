//import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'drawer_menu.dart';
import 'home_body.dart';

class HomePage extends StatefulWidget {
  // const HomePage({
  //   Key key,
  //   @required this.user
  // }) : super(key: key);
  //final FirebaseUser user;

  @override
  _HomePageState createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _userName = null; //PASS USER NAME TO DRAWER
  String _userEmail = null; //PASS USER EMAIL TO DRAWER

  Future<void> getUserInfo() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    DocumentReference emailRef = Firestore.instance.collection('users').document(user.email);
    //DocumentReference nameRef = Firestore.instance.collection('users').document(user.name);
    _userEmail = emailRef.toString();
    print(_userEmail);
    //_userName = nameRef.toString();
  }

  @override
  void initState() {
    getUserInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context){
    return new Scaffold(
      appBar: new AppBar(
        backgroundColor: new Color(0xFF151026),
        centerTitle: true,
        elevation: 2.0,
        title: new Text('TUNED LIVE', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: new Icon(Icons.youtube_searched_for)
          )
        ],
      ),
      drawer: new DrawerMenu(userName: "Oski Klonoski", userEmail: _userEmail),
      body: new TunedBody(),
    );
  }
}