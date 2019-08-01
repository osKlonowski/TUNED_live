import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tuned_live/screens/venues_list.dart';
import 'package:tuned_live/services/user_management.dart';

import 'home_page.dart';
//import 'home_page.dart';

class DrawerMenu extends StatefulWidget {
  @override
  _DrawerState createState() => _DrawerState();
}

class _DrawerState extends State<DrawerMenu> {

  @override
  Widget build(BuildContext context) {
    return new Drawer(
      child: new ListView(
        children: <Widget>[
          new FutureBuilder<DocumentSnapshot>(
            future: UserManagement.getUserInfo(),
            builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting: return new Center(child: new CircularProgressIndicator(backgroundColor: Colors.blue[700],));
              default:
                if (snapshot.hasError)
                  return new Text('Error: ${snapshot.error}');
                else
                  return new UserAccountsDrawerHeader(
                    accountName: new Text('${snapshot.data["name"]}', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 23.0)),
                    accountEmail: new Text('${snapshot.data['email']}'),
                    currentAccountPicture: new Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50.0),
                        color: Colors.white,
                      ),
                      child: Icon(Icons.person_outline, size: 45.0,),
                    ),
                    decoration: new BoxDecoration(
                      color: Colors.blue[700],
                    ),
                  );
              }
            },
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
            onTap: () {
              Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) => new VenuesList()));
            },
          ),
          new ListTile(
            title: new Text('Settings'),
            trailing: Icon(Icons.settings),
            onTap: () {
              Navigator.popAndPushNamed(context, '/settingScreen');
            },
          ),
          new ListTile(
            title: new Text('Logout'),
            trailing: Icon(Icons.arrow_left),
            onTap: () {
              FirebaseAuth.instance.signOut().then((value) {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
                Navigator.pushNamed(context, '/loginScreen');
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