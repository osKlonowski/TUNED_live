import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'drawer_menu.dart';

class VenueView extends StatefulWidget {

  @override
  _VenueViewState createState() => _VenueViewState();
}

class _VenueViewState extends State<VenueView> {
  GoogleMapController mapController;
  final Set<Marker> _markers = {};

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
            child: new Icon(Icons.youtube_searched_for)
          )
        ],
      ), //_userName + _userEmail
      body: new Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              new Container(
                margin: EdgeInsets.only(bottom: 10.0),
                height: 220,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  boxShadow: [new BoxShadow(
                    color: Colors.black38,
                    blurRadius: 5.0,
                  ),]
                ),
                child: GoogleMap(
                  initialCameraPosition: CameraPosition(target: LatLng(45.645573, -122.657433), zoom: 18.0), 
                  onMapCreated: _onMapCreated,
                  myLocationEnabled: false, // add a blue dot;
                  scrollGesturesEnabled: true,
                  tiltGesturesEnabled: true,
                  rotateGesturesEnabled: true,
                  compassEnabled: true,
                  mapType: MapType.satellite,
                  markers: _markers,
                ),
              ),
            ],
          ),
          Row(
            children: <Widget>[
              Expanded(
                flex: 3,
                child: Container(
                  padding: EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    border: Border(bottom: BorderSide(width: 2.0, color: Colors.green)),
                  ),
                  child: Center(
                    child: Text('Overview'),
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: Container(
                  padding: EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    border: Border(bottom: BorderSide(width: 2.0, color: Colors.black12)),
                  ),
                  child: Center(
                    child: Text('Photos'),
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: Container(
                  padding: EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    border: Border(bottom: BorderSide(width: 2.0, color: Colors.black12)),
                  ),
                  child: Center(
                    child: Text('Reviews'),
                  ),
                ),
              ),
            ],
          ),
          Container(
            height: 80,
            padding: EdgeInsets.only(left: 15.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text('Venue Name', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 24.0)),
            ),
          ),
          Container(
            padding: EdgeInsets.only(left: 15.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.star, size: 22.0, color: Colors.greenAccent[400]),
                Icon(Icons.star, size: 22.0, color: Colors.greenAccent[400]),
                Icon(Icons.star, size: 22.0, color: Colors.greenAccent[400]),
                Icon(Icons.star, size: 22.0, color: Colors.grey[300]),
                Icon(Icons.star, size: 22.0, color: Colors.grey[300]),
              ],
            ),
          ),
          Container(
            height: 80,
            padding: EdgeInsets.only(left: 15.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text('Information', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 24.0)),
            ),
          ),
          Container(
            height: 120,
            child: ListView(
              physics: const NeverScrollableScrollPhysics(),
              children: <Widget>[
                Divider(),
                ListTile(
                  title: new Text('Visit Website'),
                  leading: Icon(Icons.computer),
                  onTap: () {},
                ),
                Divider(),
                ListTile(
                  title: new Text('+31 678 232 211'),
                  leading: Icon(Icons.phone),
                  onTap: () {},
                ),
                Divider(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      mapController = controller;
    });
    addMarkerVenue();
  }

  void addMarkerVenue() {
    setState(() {
      _markers.add(Marker(
        markerId: MarkerId('VenueName'),
        position: LatLng(
          45.645573,
          -122.657433,
        ),
        infoWindow: InfoWindow(
          title: 'Venue Name',
          snippet: '5 Star Rating',
        ),
        icon: BitmapDescriptor.defaultMarker,
      ));
    });
  }
}