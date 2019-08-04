import 'package:cloud_firestore/cloud_firestore.dart';
import "package:flutter/material.dart";

import 'user_management.dart';

class PersonalInformation extends StatefulWidget {
  @override
  _PersonalState createState() => _PersonalState();
}

class _PersonalState extends State<PersonalInformation> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text('Edit Account'),
        backgroundColor: new Color(0xFF151026),
        centerTitle: true,
        elevation: 2.0,
      ),
      body: new FutureBuilder<DocumentSnapshot>(
        future: UserManagement.getUserInfo(),
        builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting: return new Center(child: new CircularProgressIndicator());
          default:
            if (snapshot.hasError)
              return new Text('Error: ${snapshot.error}');
            else
              return new ListView(
                padding: EdgeInsets.all(12.0),
                shrinkWrap: true,
                children: <Widget> [
                  // ListTile(
                  //   title: Text("Profile Picture"),
                  //   subtitle: Text("URL-link"), //TODO: query from Firebase
                  //   onTap: (){
                  //     Navigator.pushNamed(context, '/editAccountName'); //change
                  //   },
                  // ),
                  ListTile(
                    title: Text("Name", style: TextStyle(fontSize: 15.0, color: Colors.black54),),
                    subtitle: Text('${snapshot.data["name"]}', style: TextStyle(fontSize: 21.0, color: Colors.black),), //TODO: query from Firebase
                    onTap: (){
                      Navigator.pushNamed(context, '/editAccountName');
                    },
                  ),
                  Divider(),
                  ListTile(
                    title: Text("Email", style: TextStyle(fontSize: 15.0, color: Colors.black54),),
                    subtitle: Text('${snapshot.data['email']}', style: TextStyle(fontSize: 21.0, color: Colors.black),), //TODO: query from Firebase
                    onTap: (){
                      Navigator.pushNamed(context, '/editAccountEmail'); //change
                    },
                  ),
                  Divider(),
                  Padding(
                    padding: EdgeInsets.all(2.0),
                    child: SwitchListTile(
                      activeColor: new Color(0xFF151026),
                      value: false,
                      title: Text("Enable Location Services", style: TextStyle(fontSize: 18.0, color: Colors.black)),
                      onChanged: (value) {},
                    ),
                  ),
                  Divider(),
                  Padding(
                    padding: EdgeInsets.all(2.0),
                    child: SwitchListTile(
                      activeColor: new Color(0xFF151026),
                      value: false,
                      title: Text("Enable Notifications", style: TextStyle(fontSize: 18.0, color: Colors.black)),
                      onChanged: (value) {},
                    ),
                  ),
                ],
              );
          }
        },
      ),
    );
  }
}
