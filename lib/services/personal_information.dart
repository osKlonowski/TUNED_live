import "package:flutter/material.dart";

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
      body: ListView(
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
            subtitle: Text("Oskar Klonowski", style: TextStyle(fontSize: 21.0, color: Colors.black),), //TODO: query from Firebase
            onTap: (){
              Navigator.pushNamed(context, '/editAccountName');
            },
          ),
          Divider(),
          ListTile(
            title: Text("Email", style: TextStyle(fontSize: 15.0, color: Colors.black54),),
            subtitle: Text("osklonowski@gmail.com", style: TextStyle(fontSize: 21.0, color: Colors.black),), //TODO: query from Firebase
            onTap: (){
              Navigator.pushNamed(context, '/editAccountEmail'); //change
            },
          ),
        ],
      ),
    );
  }
}