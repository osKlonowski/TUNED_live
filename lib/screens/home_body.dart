import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:rxdart/rxdart.dart';
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
    location.onLocationChanged().listen((value) {
      setState(() {
        currentUserLocation = value;
      });
      mapController.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(value.latitude, value.longitude),
          zoom: 12.0
        )
      ));
    });
    venueQuery();
  }

  GoogleMapController mapController;
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

  @override
  Widget build(BuildContext context) {
    return new Stack(
      children: [
        GoogleMap(
          initialCameraPosition: CameraPosition(target: LatLng(currentUserLocation.latitude, currentUserLocation.longitude), zoom: 12.0),
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
              onChanged: _updateQuery,
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
              padding: EdgeInsets.all(5.0),
              decoration: BoxDecoration(borderRadius: 
                BorderRadius.only(
                  topRight: Radius.circular(10.0),
                  bottomRight: Radius.circular(10.0),
                  bottomLeft: Radius.circular(10.0), 
                  topLeft: Radius.circular(10.0)), 
                  color: Colors.white),
              child: StreamBuilder<QuerySnapshot>(
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
                              children: [
                              new InkWell(
                                onTap: () {
                                  //Navigator.of(context).pop;
                                  print("Play Music!");
                                },
                                child: Padding(
                                    padding: EdgeInsets.all(2.0),
                                    child: const Icon(Icons.play_circle_filled, color: Colors.white, size: 45.0)
                                    )
                              ),
                              new Column(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  new Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(ds['venueName'], style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
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
                              Text('${ds['venueName']}m', style: TextStyle(color: Colors.white)),
                              ],
                            ),
                          );
                        }
                      );
                    }
                },
              ),
            ),
          ),
          // child: new StreamBuilder<QuerySnapshot>(
          //   stream: Firestore.instance.collection('venues').snapshots(),
          //   builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          //     if (snapshot.hasError)
          //       return new Text('Error: ${snapshot.error}');
          //     switch (snapshot.connectionState) {
          //       case ConnectionState.waiting: return new CircularProgressIndicator();
          //       default:
          //         //return VenueContainer();
          //         return new ListView(
          //           children: snapshot.data.documents.map((DocumentSnapshot document) {
          //             return new Container(
          //               height: 100,
          //               decoration: 
          //                 BoxDecoration(
          //                   borderRadius: BorderRadius.circular(10.0), 
          //                   color: new Color(0xFF151026)
          //                 ),
          //               padding: EdgeInsets.only(left: 10.0, right: 10.0),
          //               child:       
          //               Row(
          //                 mainAxisAlignment: MainAxisAlignment.spaceAround,
          //                 children: [
          //                 new InkWell(
          //                   onTap: () {
          //                     //Navigator.of(context).pop;
          //                     print("Play Music!");
          //                   },
          //                   child: Padding(
          //                       padding: EdgeInsets.all(2.0),
          //                       child: const Icon(Icons.play_circle_filled, color: Colors.white, size: 45.0)
          //                       )
          //                 ),
          //                 new Column(
          //                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //                   children: [
          //                     new Row(
          //                       mainAxisAlignment: MainAxisAlignment.center,
          //                       children: [
          //                         Text('${document.data['venueName']}', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          //                       ]
          //                     ),
          //                     Row(
          //                       mainAxisSize: MainAxisSize.min,
          //                       children: [
          //                         Icon(Icons.star, size: 22.0, color: Colors.greenAccent[400]),
          //                         Icon(Icons.star, size: 22.0, color: Colors.greenAccent[400]),
          //                         Icon(Icons.star, size: 22.0, color: Colors.greenAccent[400]),
          //                         Icon(Icons.star, size: 22.0, color: Colors.white),
          //                         Icon(Icons.star, size: 22.0, color: Colors.white),
          //                       ],
          //                     ),
          //                   ],
          //                 ),
          //                 Text('250m', style: TextStyle(color: Colors.white)),
          //                 ],
          //               ),
          //             );
          //           }).toList(),
          //         );
          //     }
          //   },
          // ),
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

  void _updateMarkers(List<DocumentSnapshot> documentList){
    print(documentList);
    markers.clear();
    documentList.forEach((DocumentSnapshot document) {
      GeoPoint pos = document.data['position']['geopoint'];
      double distance = document.data['distance'];
      String name = document.data['venueName'];

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

      // setState(() {
      //   _markers.add(Marker(
      //     markerId: MarkerId(LatLng(pos.latitude, pos.longitude).toString()),
      //     position: LatLng(pos.latitude, pos.longitude),
      //     infoWindow: InfoWindow(
      //       title: '${document.data['venueName']}',
      //       snippet: '$distance kilometers from you',
      //       onTap: () => print('Clicked the marker description.'),
      //     ),
      //     icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow),
      //   ));
      // });
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
    //_animateToUser();
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


