import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'venue_view.dart';

class VenueContainer extends StatefulWidget {
  // final QuerySnapshot snapshot;
  // const VenueContainer({Key key, @required this.snapshot}): super(key: key);
  // taking in parameters
  @override
  _VenueContainerState createState() => _VenueContainerState();
}

class _VenueContainerState extends State<VenueContainer> {

  @override
  Widget build(BuildContext context) {
    return new StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('venues').snapshots(),
      builder: (BuildContext context, 
                AsyncSnapshot<QuerySnapshot> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return new Center(child: new CircularProgressIndicator());
          default:
            return new ListView.separated(
              separatorBuilder: (
                BuildContext context, int index) => const Divider(),
              itemCount: snapshot.data.documents.length,
              itemBuilder: (context, index) {
                DocumentSnapshot ds = snapshot.data.documents[index];
                //you can add extra code here
                return Container(
                  height: 100,
                  decoration: 
                    BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0), 
                      color: new Color(0xFF151026)
                    ),
                  padding: EdgeInsets.only(left: 10.0, right: 10.0),
                  child:
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget> [
                      Expanded (
                        flex: 2,
                        child: new InkWell(
                          onTap: () {
                            Navigator.of(context).pop();
                            Navigator.push(context, MaterialPageRoute(builder: (context) => VenueView(snapshot: ds)));
                          },
                          child: Padding(   
                              padding: EdgeInsets.all(2.0),
                              child: const Icon(Icons.play_circle_filled, color: Colors.white, size: 55.0)
                              )
                        ),
                      ),
                      Expanded (
                        flex: 6,
                        child: new Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            new Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(ds['venueName'], style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 24.0)),
                              ]
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.star, size: 22.0, color: Colors.greenAccent[400]),
                                Icon(Icons.star, size: 22.0, color: Colors.greenAccent[400]),
                                Icon(Icons.star, size: 22.0, color: Colors.greenAccent[400]),
                                Icon(Icons.star, size: 22.0, color: Colors.white),
                                Icon(Icons.star, size: 22.0, color: Colors.white),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Expanded (
                        flex: 2,
                        child: new Center (child: Text('${ds['distance']}km', style: TextStyle(color: Colors.white))),
                      ),
                    ],
                  ),
                );
              }
            );
          }
      },
    );
  }

}