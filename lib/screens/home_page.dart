//import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:tuned_live/screens/venue_view.dart';
import 'package:tuned_live/services/google_maps.dart';
import 'package:tuned_live/services/user_management.dart';
import 'drawer_menu.dart';
import 'package:geolocator/geolocator.dart';

class HomePage extends StatefulWidget {

  @override
  _HomePageState createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> {

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
            child: new IconButton(icon: Icon(Icons.search), onPressed: () {
              //showSearch(context: context, delegate: DataSearch()); //TODO: FIX
            })
          )
        ],
      ),
      drawer: new DrawerMenu(),
      body: new Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: GoogleMapBox(),
          ),
          new Align(
            alignment: Alignment.bottomLeft,
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 10.0),
              height: 130.0,
              width: MediaQuery.of(context).size.width,
              child: StreamBuilder<QuerySnapshot>(
                stream: Firestore.instance.collection('venues').snapshots(),
                builder: (BuildContext context, 
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                      return new Center(child: new CircularProgressIndicator());
                    default:
                      return new ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: snapshot.data.documents.length,
                        itemBuilder: (context, index) {
                          DocumentSnapshot ds = snapshot.data.documents[index];
                          GeoPoint pos = ds.data['position']['geopoint'];
                          return new Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: _boxes(pos.latitude, pos.longitude, ds['venueName'], ds),
                          );
                        }
                      );
                    }
                },
              ),
            )
          ),
        ],
      ),
    );
  }

  Widget _boxes(double lat, double long, String venueName, DocumentSnapshot ds) {
    // UserManagement.getDistanceToVenue(pos.latitude, pos.longitude);
    String distance = ds.data['distance'];
    String address = ds.data['address'];
    return Container(
      child: new FittedBox(
        child: Material(
            color: Colors.white,
            elevation: 4.0,
            borderRadius: BorderRadius.circular(24.0),
            //shadowColor: Color(0x802196F3),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    // GoogleMapBox._gotoMarker(lat,long);
                  },
                  child: Container(
                    width: 180,
                    height: 200,
                    child: ClipRRect(
                      borderRadius: new BorderRadius.circular(24.0),
                      child: Icon(
                        Icons.play_circle_filled, size: 110.0,
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.push(context, MaterialPageRoute(builder: (context) => VenueView(snapshot: ds)));
                  },
                  child: Container(
                    child: Padding(
                      padding: const EdgeInsets.only(
                        top: 10.0,
                        left: 0.0,
                        bottom: 10.0,
                        right: 25.0
                      ),
                      child: myDetailsContainer(venueName, address, distance),
                    ),
                  ),
                ),
              ],
            )
        ),
      ),
    );
  }

  Widget myDetailsContainer(String venueName, String address, String distance) {

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Container(
              child: Text(venueName,
            style: TextStyle(
                color: Color(0xff6200ee),
                fontSize: 26.0,
                fontWeight: FontWeight.bold),
          )),
        ),
        SizedBox(height:5.0),
        Container(
              child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Container(
                  child: Text(
                '$address', //TODO: Calculate the real distance for each user
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: 22.0,
                ),
              )),
            ],
          )),
          SizedBox(height:5.0),
        Container(
            child: Text(
          "$distance km",
          style: TextStyle(
              color: Colors.black54,
              fontSize: 20.0,
              fontWeight: FontWeight.bold),
        )),
      ],
    );
  }

  // Widget _showDialog() {
  //   return AlertDialog(
  //     title: new Text("Location Permission"),
  //     content: new Text("This app needs location permission while you use the app"),
  //     actions: <Widget>[
  //       new FlatButton(
  //         child: new Text("Give Permission"),
  //         onPressed: isLocationGranted() ? null : () => _askPermission,
  //       ),
  //       new FlatButton(
  //         child: new Text("Close"),
  //         onPressed: () {
  //           Navigator.of(context).pop();
  //         },
  //       ),
  //     ],
  //   );
  // }
}