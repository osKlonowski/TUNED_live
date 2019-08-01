import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'venue_view.dart';

class VenuesList extends StatefulWidget {
  @override
  _VenueListState createState() => _VenueListState();
}

class _VenueListState extends State<VenuesList> {
  TextEditingController editingController = TextEditingController();

  // @override
  // void initState() {
  //   super.initState();
  // }

  String venueQuery = "";

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        backgroundColor: new Color(0xFF151026),
        centerTitle: true,
        elevation: 2.0,
        title: new Text('TUNED LIVE', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                onChanged: (value) {
                  setState(() {
                    venueQuery = value;
                  });
                },
                controller: editingController,
                decoration: InputDecoration(
                    labelText: "Search",
                    hintText: "Search",
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(25.0)))),
              ),
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: Firestore.instance.collection('venues').snapshots(),
                builder: (BuildContext context, 
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                      return new Center(child: new CircularProgressIndicator());
                    default:
                      return new ListView.builder(
                        scrollDirection: Axis.vertical,
                        itemCount: snapshot.data.documents.length,
                        itemBuilder: (context, index) {
                          DocumentSnapshot ds = snapshot.data.documents[index];
                          if(ds['venueName'].toLowerCase().contains(venueQuery.toLowerCase()) || venueQuery == null || venueQuery == ""){
                            return makeCard(ds['venueName'], ds);
                          }
                        }
                      );
                    }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget makeCard(String venueName, DocumentSnapshot ds) {
    return Card(
      elevation: 8.0,
      margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
      child: GestureDetector(
        onTap: () {
          // Navigator.push(context, MaterialPageRoute(builder: (context) => VenueView(snapshot: ds)));
        },
        child: Container(
          decoration: BoxDecoration(color: Colors.blue[700], borderRadius: BorderRadius.circular(5.0)),
          child: ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            leading: Container(
              padding: EdgeInsets.only(right: 12.0),
              decoration: new BoxDecoration(
                  border: new Border(
                      right: new BorderSide(width: 1.0, color: Colors.white24))),
              child: Icon(Icons.card_membership, color: Colors.white),
            ),
            title: Text(
              venueName, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 21.0),
            ),
            // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),
            subtitle: Row(
              children: <Widget>[
                Icon(Icons.linear_scale, color: Colors.yellowAccent),
                Text(" Address", style: TextStyle(color: Colors.white))
              ],
            ),
            trailing: Icon(Icons.keyboard_arrow_right, color: Colors.white, size: 30.0),
          ),
        ),
      ),
    );
  }

}