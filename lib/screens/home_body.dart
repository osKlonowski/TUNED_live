import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tuned_live/services/coordinatesToAddress.dart';
// import 'package:tuned_live/screens/venue_container.dart';
import 'venue_view.dart';

class TunedBody extends StatefulWidget {

  @override
  State createState() => TunedBodyBuilder();
}

class TunedBodyBuilder extends State<TunedBody> {
  PermissionStatus _status;
  Location location = new Location();
  LocationData currentUserLocation;
  bool _showAlertPermission = true;
  double zoomVal = 12.0;

  Firestore firestore = Firestore.instance;
  Geoflutterfire geo = Geoflutterfire();  

  BehaviorSubject<double> radius = BehaviorSubject(seedValue: 200.0);
  Stream<dynamic> query;

  StreamSubscription subscription;

  @override
  void initState(){ 
    super.initState();
    PermissionHandler().checkPermissionStatus(PermissionGroup.locationWhenInUse)
    .then(_updateStatus);
    // location.onLocationChanged().listen((value) {
    //   mapController.animateCamera(CameraUpdate.newCameraPosition(
    //     CameraPosition(
    //       target: LatLng(value.latitude, value.longitude),
    //       zoom: 12.0
    //     )
    //   )); //FIX THIS!!!
    // });
    //venueQuery();
  }

  GoogleMapController mapController;
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

  @override
  Widget build(BuildContext context) {
    return new Stack(
      children: [
        Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: GoogleMap(
            initialCameraPosition: CameraPosition(target: LatLng(49.2827, -123.1207), zoom: 12.0, tilt: 50.0,), 
            onMapCreated: _onMapCreated,
            myLocationEnabled: true, // add a blue dot;
            scrollGesturesEnabled: true,
            tiltGesturesEnabled: true,
            rotateGesturesEnabled: true,
            compassEnabled: true,
            markers: Set<Marker>.of(markers.values),
          ),
        ),
        _zoomminusfunction(),
        _zoomplusfunction(),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Align(
            alignment: Alignment.topRight,
            child: Column(
              children: <Widget>[
                FloatingActionButton(
                  heroTag: "UserLocationBtn",
                  onPressed: getLocationOnce,
                  materialTapTargetSize: MaterialTapTargetSize.padded,
                  backgroundColor: new Color(0xFF151026),
                  child: const Icon(Icons.person_outline, size: 33.0),
                ),
                SizedBox(height: 16.0),
                FloatingActionButton(
                  heroTag: "AddGeoPointBtn",
                  onPressed: _addGeoPoint,
                  materialTapTargetSize: MaterialTapTargetSize.padded,
                  backgroundColor: new Color(0xFF151026),
                  child: const Icon(Icons.add_location, size: 33.0),
                ),
                SizedBox(height: 16.0),
              ],
            ),
          ),
        ),
        new Align(
          alignment: Alignment.bottomLeft,
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 10.0),
            height: 140.0,
            width: MediaQuery.of(context).size.width,
            child: StreamBuilder<QuerySnapshot>(
              stream: Firestore.instance.collection('venues').snapshots(),
              builder: (BuildContext context, 
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return new Center(child: new CircularProgressIndicator());
                  default:
                    return new ListView.separated(
                      separatorBuilder: (BuildContext context, int index) => const Divider(),
                      scrollDirection: Axis.horizontal,
                      itemCount: snapshot.data.documents.length,
                      itemBuilder: (context, index) {
                        DocumentSnapshot ds = snapshot.data.documents[index];
                        GeoPoint pos = ds.data['position']['geopoint'];
                        String distance = ds.data['distance'];
                        return new Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: _boxes(pos.latitude, pos.longitude, ds['venueName'], distance, ds),
                        );
                      }
                    );
                  }
              },
            ),
          )
        ),
      ],
    );
  }

  Widget _zoomminusfunction() {
    return Positioned(
      top: 80,
      left: 10,
      child: FloatingActionButton(
        heroTag: "zoomOutBtn",
        onPressed: () {
          zoomVal--;
          _minus(zoomVal);
          _updateQuery(radius.value + 50);
        },
        materialTapTargetSize: MaterialTapTargetSize.padded,
        backgroundColor: new Color(0xFF151026),
        child: const Icon(Icons.zoom_out, color: Colors.white, size: 33.0),
      ),
    );
  }
  Widget _zoomplusfunction() {
    return Positioned(
      top: 15,
      left: 10,
      child: FloatingActionButton(
        heroTag: "zoomInBtn",
        onPressed: () {
          zoomVal++;
          _plus(zoomVal);
          _updateQuery(radius.value - 50);
        },
        materialTapTargetSize: MaterialTapTargetSize.padded,
        backgroundColor: new Color(0xFF151026),
        child: const Icon(Icons.zoom_in, color: Colors.white, size: 33.0),
      ),
    );
  }

  Widget _boxes(double lat, double long, String venueName, String distance, DocumentSnapshot ds) {
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
                    _gotoMarker(lat,long);
                  },
                  child: Container(
                  width: 180,
                  height: 200,
                  child: ClipRRect(
                    borderRadius: new BorderRadius.circular(24.0),
                    child: Icon(
                      Icons.play_circle_filled, size: 120.0,
                    ),
                  ),),
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
                      child: myDetailsContainer(venueName, distance),
                    ),
                  ),
                ),
              ],
            )
        ),
      ),
    );
  }

  Widget myDetailsContainer(String venueName, String distance) {
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
                '$distance km',
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
          "Opens 17:00 Thu",
          style: TextStyle(
              color: Colors.black54,
              fontSize: 18.0,
              fontWeight: FontWeight.bold),
        )),
      ],
    );
  }
  
  Future<DocumentReference> _addGeoPoint() async {
    var pos = await location.getLocation();
    GeoFirePoint point = geo.point(latitude: pos.latitude, longitude: pos.longitude);
    Address address = await GetAddress.getAddress(LatLng(pos.latitude, pos.longitude)); //TODO: FIXTHIS
    return firestore.collection('venues').add({
      'position': point.data,
      'venueName': address.featureName.toString(),
      'emailAddress': 'melkweg@gmail.com',
      'address': address.addressLine.toString()
    });
  }

  void _updateMarkers(List<DocumentSnapshot> documentList){
    markers.clear();
    documentList.forEach((DocumentSnapshot document) {
      GeoPoint pos = document.data['position']['geopoint'];
      double distance = document.data['distance'];
      String name = document.data['venueName'];

      Firestore.instance.collection('venues').document(document.documentID).updateData({'distance': distance.toStringAsFixed(2)});

      var markerId = MarkerId(LatLng(pos.latitude, pos.longitude).toString());

      final Marker marker = Marker(
        markerId: markerId,
        position: LatLng(
          pos.latitude,
          pos.longitude,
        ),
        infoWindow: InfoWindow(
          title: name,
          snippet: '$distance km from you.'
        ),
        onTap: () {
          print("Hello World!");
        },
      );

      setState(() {
        markers[markerId] = marker;
      });
    });
  }

  _startQuery() async {
    //getLocationOnce();
    var pos = await location.getLocation();
    double lat = pos.latitude;
    double lng = pos.longitude;
    mapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: LatLng(lat, lng), zoom: 14, tilt: 50.0)));
    
    var ref = firestore.collection('venues');
    GeoFirePoint center = geo.point(latitude: lat, longitude: lng);

    subscription = radius.switchMap((rad) {
      return geo.collection(collectionRef: ref).within(
        center: center,
        radius: rad,
        field: 'position',
        strictMode: true,
      );
    }).listen(_updateMarkers);
  }

  _updateQuery(value) {
    setState(() {
      radius.add(value);
    });
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

  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      mapController = controller;
    });
    _startQuery();
  }

  Future<void> getLocationOnce() async {
    zoomVal = 12.0;
    try {
      currentUserLocation = await location.getLocation();
    } catch (e) {
      print(e);
      currentUserLocation = null;
    }
    _gotoLocation(currentUserLocation.latitude, currentUserLocation.longitude);
  }

  void _updateStatus(PermissionStatus status) {
    if (status != _status){
      setState(() {
        _status = status;
      });
    }
    if (_status == PermissionStatus.granted){
      _showAlertPermission = false;
    } else {
      _showAlertPermission = true;
    }
  }

  bool isLocationGranted() {
    if (_status == PermissionStatus.granted){
      return true;
    } else {
      return false;
    }
  }
  void _askPermission() {
    PermissionHandler().requestPermissions([PermissionGroup.locationWhenInUse])
      .then(_onStatusRequested);
  }
  void _onStatusRequested(Map<PermissionGroup, PermissionStatus> statuses){
    final status = statuses[PermissionGroup.locationWhenInUse];
    if (status != PermissionStatus.granted){
      PermissionHandler().openAppSettings();
    } else {
      _updateStatus(status);
    }
  }
  Future<void> _gotoLocation(double lat,double long) async {
    mapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: LatLng(lat, long), zoom: 14, tilt: 50.0)));
  }
  Future<void> _gotoMarker(double lat,double long) async {
    mapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: LatLng(lat, long), zoom: 18, tilt: 50.0)));
  }
  Future<void> _minus(double zoomVal) async {
    var pos = await location.getLocation();
    mapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: LatLng(pos.latitude, pos.longitude), zoom: zoomVal)));
  }
  Future<void> _plus(double zoomVal) async {
    var pos = await location.getLocation();
    mapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: LatLng(pos.latitude, pos.longitude), zoom: zoomVal)));
  }

  @override
  dispose() {
    subscription.cancel();
    super.dispose();
  }

}


