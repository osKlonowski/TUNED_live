import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class VenueView extends StatefulWidget {
  DocumentSnapshot snapshot;
  VenueView({Key key, @required this.snapshot}) : super(key: key);

  @override
  _VenueViewState createState() => _VenueViewState();
}

class _VenueViewState extends State<VenueView> {
  GoogleMapController mapController;
  String venueAddress;

  final Marker markerVenue = Marker(
    markerId: MarkerId('VenueName'),
    position: LatLng(
      45.645573,
      -122.657433,
    ),
    infoWindow: InfoWindow(
      title: "Not important",
      snippet: '5 Star Rating',
    ),
    icon: BitmapDescriptor.defaultMarker,
  );

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        backgroundColor: new Color(0xFF151026),
        centerTitle: true,
        elevation: 2.0,
        leading: new GestureDetector(
          child: new Icon(
            Icons.arrow_back,
          ),
          onTap: () {
            Navigator.popAndPushNamed(context, '/homeScreen');
          },
        ),
        title: new Text('TUNED LIVE', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: new IconButton(
              icon: Icon(Icons.star_border),
              onPressed: () {}, //TODO: Add it to Favourites
            )
          )
        ],
      ), //_userName + _userEmail
      body: ListView(
        padding: EdgeInsets.all(12.0),
        children: <Widget>[
          ListTile(
            leading: Icon(Icons.person_pin_circle, size: 35.0),
            title: Text(widget.snapshot['venueName'], style: TextStyle(fontSize: 24.0)),
            subtitle: Text("Located at 5th Avenue", style: TextStyle(fontSize: 18.0)),
          ),
          SizedBox(height: 5.0),
          Align(
            alignment: Alignment.center,
            child: DefaultTabController(
              length: 3,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TabBar(
                    isScrollable: false,
                    labelColor: Theme.of(context).accentColor,
                    unselectedLabelColor: Theme.of(context)
                        .textTheme.caption.color,
                    tabs: <Widget>[
                      Tab(
                        text: "Music",
                      ),
                      Tab(
                        text: "Overview",
                      ),
                      Tab(
                        text: "Reviews",
                      ),
                    ],
                  ),

                  Container(
                    margin: EdgeInsets.only(top: 10),
                    height: MediaQuery.of(context).size.height*2,
                    child: TabBarView(
                      children: <Widget>[
                        musicTab(),
                        overviewTab(),
                        reviewsTab(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget musicTab() {
    return ListView(
      children: <Widget>[
        ListTile(
          title: Text("Yey, Venue Music"),
        )
      ],
    );
  }

  Widget overviewTab() {
    return ListView(
      children: <Widget>[
        Card(
          child: new Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  new Container(
                    margin: EdgeInsets.only(bottom: 10.0),
                    height: 160,
                    width: 380,
                    decoration: BoxDecoration(
                      boxShadow: [new BoxShadow(
                        color: Colors.black38,
                        blurRadius: 5.0,
                      ),]
                    ),
                    child: GoogleMap(
                      initialCameraPosition: CameraPosition(target: LatLng(45.645573, -122.657433), zoom: 16.0, tilt: 50.0), 
                      onMapCreated: _onMapCreated,
                      myLocationEnabled: false, // add a blue dot;
                      scrollGesturesEnabled: true,
                      tiltGesturesEnabled: true,
                      rotateGesturesEnabled: true,
                      compassEnabled: true,
                      mapType: MapType.satellite,
                      markers: {markerVenue},
                    ),
                  ),

                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget reviewsTab() {
    return ListView(
      children: <Widget>[
        Card(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const ListTile(
                leading: Icon(Icons.star),
                title: Text('Firstname Lastname'),
                subtitle: Text('06/07/2017 - New York City'),
              ),
              // ButtonTheme.bar( // make buttons use the appropriate styles for cards
              //   child: ButtonBar(
              //     children: <Widget>[
              //       FlatButton(
              //         child: const Text('BUY TICKETS'),
              //         onPressed: () { /* ... */ },
              //       ),
              //     ],
              //   ),
              // ),
            ],
          ),
        ),
        Card(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const ListTile(
                leading: Icon(Icons.star),
                title: Text('Firstname Lastname'),
                subtitle: Text('06/07/2017 - New York City'),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      mapController = controller;
    });
  }

}


// new Column(
//         children: <Widget>[
//           Row(
//             children: <Widget>[
//               new Container(
//                 margin: EdgeInsets.only(bottom: 10.0),
//                 height: 220,
//                 width: MediaQuery.of(context).size.width,
//                 decoration: BoxDecoration(
//                   boxShadow: [new BoxShadow(
//                     color: Colors.black38,
//                     blurRadius: 5.0,
//                   ),]
//                 ),
//                 child: GoogleMap(
//                   initialCameraPosition: CameraPosition(target: LatLng(45.645573, -122.657433), zoom: 16.0, tilt: 50.0), 
//                   onMapCreated: _onMapCreated,
//                   myLocationEnabled: false, // add a blue dot;
//                   scrollGesturesEnabled: true,
//                   tiltGesturesEnabled: true,
//                   rotateGesturesEnabled: true,
//                   compassEnabled: true,
//                   mapType: MapType.satellite,
//                   markers: {markerVenue},
//                 ),
//               ),
//             ],
//           ),
//           Row(
//             children: <Widget>[
//               Expanded(
//                 flex: 3,
//                 child: Container(
//                   padding: EdgeInsets.all(10.0),
//                   decoration: BoxDecoration(
//                     border: Border(bottom: BorderSide(width: 2.0, color: Colors.green)),
//                   ),
//                   child: Center(
//                     child: Text('Overview'),
//                   ),
//                 ),
//               ),
//               Expanded(
//                 flex: 3,
//                 child: Container(
//                   padding: EdgeInsets.all(10.0),
//                   decoration: BoxDecoration(
//                     border: Border(bottom: BorderSide(width: 2.0, color: Colors.black12)),
//                   ),
//                   child: Center(
//                     child: Text('Photos'),
//                   ),
//                 ),
//               ),
//               Expanded(
//                 flex: 3,
//                 child: Container(
//                   padding: EdgeInsets.all(10.0),
//                   decoration: BoxDecoration(
//                     border: Border(bottom: BorderSide(width: 2.0, color: Colors.black12)),
//                   ),
//                   child: Center(
//                     child: Text('Reviews'),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           Row (
//             children: <Widget>[
//               Container(
//                 height: 80,
//                 padding: EdgeInsets.only(left: 15.0),
//                 child: Align(
//                   alignment: Alignment.centerLeft,
//                   child: Text(widget.snapshot['venueName'], style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 24.0)),
//                 ),
//               ),
//               Container(
//                 padding: EdgeInsets.only(left: 15.0),
//                 child: Row(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Icon(Icons.star, size: 22.0, color: Colors.greenAccent[400]),
//                     Icon(Icons.star, size: 22.0, color: Colors.greenAccent[400]),
//                     Icon(Icons.star, size: 22.0, color: Colors.greenAccent[400]),
//                     Icon(Icons.star, size: 22.0, color: Colors.grey[300]),
//                     Icon(Icons.star, size: 22.0, color: Colors.grey[300]),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//           Container(
//             height: 80,
//             padding: EdgeInsets.only(left: 15.0),
//             child: Align(
//               alignment: Alignment.centerLeft,
//               child: Text('Information', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 24.0)),
//             ),
//           ),
//           Container(
//             height: 120,
//             child: ListView(
//               physics: const NeverScrollableScrollPhysics(),
//               children: <Widget>[
//                 Divider(),
//                 ListTile(
//                   title: new Text('Visit Website'),
//                   leading: Icon(Icons.computer),
//                   onTap: () {},
//                 ),
//                 Divider(),
//                 ListTile(
//                   title: new Text('+31 678 232 211'),
//                   leading: Icon(Icons.phone),
//                   onTap: () {},
//                 ),
//                 Divider(),
//               ],
//             ),
//           ),
//         ],
//       ),