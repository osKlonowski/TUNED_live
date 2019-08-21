import 'package:flutter/material.dart';

class EditName extends StatefulWidget {
  @override
  _EditNameState createState() => _EditNameState();
}

class _EditNameState extends State<EditName> {
  String _name;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text('Edit Name'),
        backgroundColor: new Color(0xFF151026),
        centerTitle: true,
        elevation: 2.0,
      ),
      body: Column(
        children: <Widget>[
          new Padding(
            padding: EdgeInsets.fromLTRB(25.0, 35.0, 25.0, 0.0),
            child: TextFormField(
              decoration: InputDecoration(labelText: 'Account Name', hintText: 'Full Name'),
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please enter a name';
                } 
                return 'Thanks';
              },
              onSaved: (value) {
                setState(() {
                  _name = value;
                });
              },
            ),
          ),
          SizedBox(height: 15.0),
          Material(
            elevation: 5.0,
            borderRadius: BorderRadius.circular(2.0),
            color: Color(0xFF151026),
            child: MaterialButton( 
              minWidth: MediaQuery.of(context).size.width - 90,
              padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
              onPressed: () {
                //Firestore.instance.collection('users').document(uid).updateData({'name': _name}); 
              },
              child: Text("Update",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      )
    );
  }
}