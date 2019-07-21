import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tuned_live/screens/venue_container.dart';
//import 'package:geolocator/geolocator.dart';
//import 'venue_container.dart';

class TunedBody extends StatefulWidget {
  @override
  State createState() => TunedBodyBuilder();
}

class TunedBodyBuilder extends State<TunedBody> {
  PermissionStatus _status;
  MapType _currentMapType = MapType.normal;
  bool _showAlertPermission = true;
  Location location = new Location();
  LocationData currentUserLocation;
  double globalRadius;

  Firestore firestore = Firestore.instance;
  Geoflutterfire geo = Geoflutterfire();

  final List<String> entries = <String>['A', 'B', 'C', 'D'];
  final List<String> distances = <String>['120', '350', '600', '810'];
  final List<int> colorCodes = <int>[600, 500, 100, 100];

  BehaviorSubject<double> radius = BehaviorSubject(seedValue: 100.0);
  Stream<dynamic> query;

  StreamSubscription subscription;

  @override
  void initState(){
    super.initState();
    PermissionHandler().checkPermissionStatus(PermissionGroup.locationWhenInUse)
    .then(_updateStatus);
    // getLocationOnce();
    location.onLocationChanged().listen((value) {
      //_updateQuery(globalRadius);
      // setState(() {
      //   currentUserLocation = value;
      // });
      mapController.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(value.latitude, value.longitude),
          zoom: 12.0
        )
      ));
    });
    //venueQuery();
  }

  GoogleMapController mapController;
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

  @override
  Widget build(BuildContext context) {
    return new Stack(
      children: [
        GoogleMap(
          initialCameraPosition: CameraPosition(target: LatLng(45.645573, -122.657433), zoom: 12.0), 
          onMapCreated: _onMapCreated,
          myLocationEnabled: true, // add a blue dot;
          scrollGesturesEnabled: true,
          tiltGesturesEnabled: true,
          rotateGesturesEnabled: true,
          compassEnabled: true,
          mapType: _currentMapType,
          markers: Set<Marker>.of(markers.values),
        ),
        _showAlertPermission ? _showDialog : Text(''), //Not sure if this works
        Positioned (
          top: 35.0,
          child: Align (
            alignment: Alignment.topCenter,
            child: Slider(
              min: 100.0,
              max: 500.0,
              divisions: 4,
              value: radius.value,
              label: 'Radius ${radius.value}km',
              activeColor: Colors.green,
              inactiveColor: Colors.green.withOpacity(0.2),
              onChanged: (value) {
                globalRadius = value;
                _updateQuery(value);
              }
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Align(
            alignment: Alignment.topRight,
            child: Column(
              children: <Widget>[
                FloatingActionButton(
                  onPressed: _onMapTypeButtonPressed,
                  materialTapTargetSize: MaterialTapTargetSize.padded,
                  backgroundColor: new Color(0xFF151026),
                  child: const Icon(Icons.map, size: 33.0),
                ),
                SizedBox(height: 16.0),
                FloatingActionButton(
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
        new Positioned(
          child: Align(
            alignment: FractionalOffset.bottomCenter,
            child: Container(
              height: 250,
              margin: EdgeInsets.all(15.0),
              padding: EdgeInsets.all(7.0),
              decoration: BoxDecoration(borderRadius: 
                BorderRadius.only(
                  topRight: Radius.circular(10.0),
                  bottomRight: Radius.circular(10.0),
                  bottomLeft: Radius.circular(10.0), 
                  topLeft: Radius.circular(10.0)), 
                  color: Colors.white),
              child: VenueContainer(),
            ),
          ),
        ),
      ],
    );
  }

  Future<DocumentReference> _addGeoPoint() async {
    var pos = await location.getLocation();
    GeoFirePoint point = geo.point(latitude: pos.latitude, longitude: pos.longitude);
    return firestore.collection('venues').add({
      'position': point.data,
      'venueName': 'Melkweg',
      'emailAddress': 'melkweg@gmail.com'
    });
  }

  void venueQuery() {
    Firestore.instance.collection('venues').snapshots().listen((data) =>
        data.documents.forEach((doc) {
          print('${doc.data['venueName']}');
          print(doc["venueName"]);
        }));
  }

  double distanceCalc(DocumentSnapshot document) {
    return document.data['distance'];
  }

  void _updateMarkers(List<DocumentSnapshot> documentList){
    markers.clear();
    documentList.forEach((DocumentSnapshot document) {
      GeoPoint pos = document.data['position']['geopoint'];
      double distance = document.data['distance'];
      String name = document.data['venueName'];

      Firestore.instance.collection('venues').document(document.documentID).updateData({'distance': distance});

      var markerId = MarkerId(LatLng(pos.latitude, pos.longitude).toString());

      final Marker marker = Marker(
        markerId: markerId,
        position: LatLng(
          pos.latitude,
          pos.longitude,
        ),
        infoWindow: InfoWindow(
          title: name,
          snippet: '$distance kilometers from you'
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
    var pos = await location.getLocation();
    double lat = pos.latitude;
    double lng = pos.longitude;
    
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
    final zoomMap = {
      100.0: 12.0,
      200.0: 10.0,
      300.0: 7.0,
      400.0: 6.0,
      500.0: 5.0
    };

    final zoom = zoomMap[value];
    mapController.moveCamera(CameraUpdate.zoomTo(zoom));

    setState(() {
      radius.add(value);
    });
  }

  void _showDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text("Location Permission"),
          content: new Text("This app needs location permission while you use the app"),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Give Permission"),
              onPressed: isLocationGranted() ? null : () => _askPermission,
            ),
            new FlatButton(
              child: new Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    _startQuery();
    setState(() {
      mapController = controller;
    });
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
  
  void _onMapTypeButtonPressed() {
    setState(() {
      _currentMapType = _currentMapType == MapType.normal
          ? MapType.satellite
          : MapType.normal;
    });
  }

  @override
  dispose() {
    subscription.cancel();
    super.dispose();
  }

}


