import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tuned_live/screens/welcome_page.dart';

import 'home_page.dart';
//import 'home_page.dart';

class DrawerMenu extends StatefulWidget {
  final String userName;
  final String userEmail;

  const DrawerMenu({Key key, @required this.userName, @required this.userEmail}): super(key: key);

  @override
  _DrawerState createState() => _DrawerState(userName, userEmail);
}

class _DrawerState extends State<DrawerMenu> {
  String userName;
  String userEmail;
  _DrawerState(this. userName, this. userEmail);
  // widget.userName
  // widget.userEmail

  @override
  Widget build(BuildContext context) {
    return new Drawer(
      child: new ListView(
        children: <Widget>[
          new UserAccountsDrawerHeader(
            accountName: new Text("${widget.userName}", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 23.0)),
            accountEmail: new Text("${widget.userEmail}"),
            currentAccountPicture: new GestureDetector(
              //onTap: () => print('Something'),
              child: new CircleAvatar(
                backgroundImage: new NetworkImage("https://cdn3.iconfinder.com/data/icons/avatars-15/64/_Ninja-2-512.png"),
              )
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
                // Navigator.of(context).pop();
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => new WelcomePage()));
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
          // new ListTile(
          //   title: new Text('Close'),
          //   trailing: Icon(Icons.cancel),
          //   //onTap: () => Navigator.of(context).pop, //Doesn't work right now
          // ),
        ],
      ),
    );
  }
}