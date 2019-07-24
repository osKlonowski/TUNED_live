import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tuned_live/screens/welcome_page.dart';

import 'home_page.dart';
//import 'home_page.dart';

class DrawerMenu extends StatefulWidget {
  @override
  _DrawerState createState() => _DrawerState();
}

class _DrawerState extends State<DrawerMenu> {

  // Future<QuerySnapshot> getUserInfo() async {
  //   final FirebaseUser user = await FirebaseAuth.instance.currentUser();
  //   var uid = user.uid;
  //   var query = Firestore.instance.collection('fields').where('uid', isEqualTo: uid).snapshots();
  //   return query.first;
  // }

  // @override
  // void initState() {
  //   getUserInfo().then((result) {
  //     setState(() {
        
  //     });
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return new Drawer(
      child: new ListView(
        children: <Widget>[
          // new FutureBuilder<QuerySnapshot>(
          //   future: getUserInfo(),
          //   builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          //     switch (snapshot.connectionState) {
          //       case ConnectionState.waiting: return new Text('Awaiting result...');
          //     default:
          //       var doc = snapshot.data;
          //       if (snapshot.hasError)
          //         return new Text('Error: ${snapshot.error}');
          //       else
          //         return new UserAccountsDrawerHeader(
          //           accountName: new Text('${doc["name"]}', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 23.0)),
          //           accountEmail: new Text('${doc['email']}'),
          //           currentAccountPicture: new CircleAvatar(
          //             backgroundImage: new NetworkImage("https://cdn3.iconfinder.com/data/icons/avatars-15/64/_Ninja-2-512.png"),
          //           ),
          //           decoration: new BoxDecoration(
          //             image: new DecorationImage(
          //               fit: BoxFit.fill,
          //               image: new NetworkImage("https://static.photocdn.pt/images/articles/2017_1/iStock-545347988.jpg"),
          //             )
          //           ),
          //         );
          //     }
          //   },
          // ),
          UserAccountsDrawerHeader(
            accountName: new Text('userName', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 23.0)),
            accountEmail: new Text('userEmail'),
            currentAccountPicture: new CircleAvatar(
              backgroundImage: new NetworkImage("https://cdn3.iconfinder.com/data/icons/avatars-15/64/_Ninja-2-512.png"),
            ),
            decoration: new BoxDecoration(
              image: new DecorationImage(
                fit: BoxFit.fill,
                image: new NetworkImage("https://static.photocdn.pt/images/articles/2017_1/iStock-545347988.jpg"),
              )
            ),
          ),
          new ListTile(
            title: new Text('Home'),
            trailing: Icon(Icons.arrow_right),
            onTap: () {
              Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) => new HomePage()));
            },
          ),
          new ListTile(
            title: new Text('All Venues'),
            trailing: Icon(Icons.casino),
            // onTap: () {
            //   Navigator.of(context).pop;
            //   Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) => new SettingsPage()));
            // },
          ),
          new ListTile(
            title: new Text('Settings'),
            trailing: Icon(Icons.settings),
            // onTap: () {
            //   Navigator.of(context).pop;
            //   Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) => new SettingsPage()));
            // },
          ),
          new ListTile(
            title: new Text('Logout'),
            trailing: Icon(Icons.arrow_left),
            onTap: () {
              FirebaseAuth.instance.signOut().then((value) {
                Navigator.popAndPushNamed(context, '/loginScreen');
              }).catchError((e) {
                print(e.message);
              });
            },
          ),
          //FIX CLOSE FUNC
          new Divider(),
          new Padding(
            padding: EdgeInsets.only(left: 10.0, right: 10.0),
            child: new Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                new Text('Legal'),
                new Text('v1.0', style: TextStyle(color: Colors.black.withOpacity(0.4))),
              ],
            ),
          ),
        ],
      ),
    );
  }
}