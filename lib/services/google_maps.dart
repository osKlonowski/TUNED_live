import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rxdart/rxdart.dart';
import 'coordinatesToAddress.dart';
import 'user_management.dart';

//45.6216 -122.678

class GoogleMapBox extends StatefulWidget {
  @override
  _GoogleMapState createState() => _GoogleMapState();
}

class _GoogleMapState extends State<GoogleMapBox> {
  GoogleMapController mapController;
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  PermissionStatus _status;
  Location location = new Location();
  LocationData currentUserLocation;
  double zoomVal = 14.0;
  Firestore firestore = Firestore.instance;
  Geoflutterfire geo = Geoflutterfire();  
  BehaviorSubject<double> radius = BehaviorSubject(seedValue: 400.0); //TODO: Adjust this value to account for number of venues guerried in the area.
  Stream<dynamic> query; 
  StreamSubscription subscription;
  bool moveUserLocation = true;
  var venues;

  @override
  void initState(){ 
    super.initState();
    PermissionHandler().checkPermissionStatus(PermissionGroup.locationWhenInUse)
    .then(_updateStatus);
    // ! This constantly updates User Position...
    // location.onLocationChanged().listen((location) async {
    //   if(moveUserLocation = true) {
    //     mapController?.animateCamera(
    //       CameraUpdate.newCameraPosition(
    //         CameraPosition(
    //           target: LatLng(
    //             location.latitude,
    //             location.longitude,
    //           ),
    //           zoom: zoomVal,
    //           tilt: 50.0,
    //         ),
    //       ),
    //     );
    //   }
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        GoogleMap(
          initialCameraPosition: CameraPosition(target: LatLng(52.3241925, 20.8934305), zoom: 12.0, tilt: 50.0,), //! 49.2827, -123.1207
          onMapCreated: _onMapCreated,
          myLocationEnabled: true, // add a blue dot;
          scrollGesturesEnabled: true,
          tiltGesturesEnabled: true,
          rotateGesturesEnabled: true,
          compassEnabled: true,
          markers: Set<Marker>.of(markers.values),
        ),
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Align(
            alignment: Alignment.topRight,
            child: Column(
              children: <Widget>[
                Container(
                  width: 45.0,
                  height: 45.0,
                  child: new RawMaterialButton(
                    fillColor: Color(0xFF151026),
                    shape: new CircleBorder(),
                    elevation: 2.0,
                    child: new Icon(
                      Icons.gps_fixed,
                      color: Colors.white,
                    ),
                  onPressed: getLocationOnce,
                )),
                SizedBox(height: 10.0),
                Container(
                  width: 45.0,
                  height: 45.0,
                  child: new RawMaterialButton(
                    fillColor: Color(0xFF151026),
                    shape: new CircleBorder(),
                    elevation: 2.0,
                    child: new Icon(
                      Icons.zoom_in,
                      color: Colors.white,
                      size: 28.0,
                    ),
                  onPressed: () {
                    zoomVal++;
                    _plus(zoomVal);
                    _updateQuery(radius.value); // ? Zoom change, increase or decrease radius value
                  },
                )),
                SizedBox(height: 10.0),
                Container(
                  width: 45.0,
                  height: 45.0,
                  child: new RawMaterialButton(
                    fillColor: Color(0xFF151026),
                    shape: new CircleBorder(),
                    elevation: 2.0,
                    child: new Icon(
                      Icons.zoom_out,
                      color: Colors.white,
                      size: 28.0,
                    ),
                  onPressed: () {
                    zoomVal--;
                    _minus(zoomVal);
                    _updateQuery(radius.value); // ? Zoom change, increase or decrease radius value
                  },
                )),
                // ! This button is unneccessary in the future. It's goona be on the website.
                // FloatingActionButton(
                //   heroTag: "AddGeoPointBtn",
                //   onPressed: _addGeoPoint,
                //   materialTapTargetSize: MaterialTapTargetSize.padded,
                //   backgroundColor: new Color(0xFF151026),
                //   child: const Icon(Icons.add_location, size: 33.0),
                // ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      mapController = controller;
    });
    _startQuery();
  }

  // ! This function adds GeoPoint of the venue, put on site.
  // Future<DocumentReference> _addGeoPoint() async {
  //   var pos = await location.getLocation();
  //   GeoFirePoint point = geo.point(latitude: pos.latitude, longitude: pos.longitude);
  //   Address address = await GetAddress.getAddress(LatLng(pos.latitude, pos.longitude)); //TODO: FIXTHIS
  //   return firestore.collection('venues').add({
  //     'position': point.data,
  //     'venueName': address.featureName.toString(), 
  //     'emailAddress': 'melkweg@gmail.com',
  //     'address': address.addressLine.toString()
  //   });
  // }

  _startQuery() async {
    var pos = await location.getLocation();
    double lat = pos.latitude;
    double lng = pos.longitude;
    mapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: LatLng(lat, lng), zoom: zoomVal, tilt: 50.0)));
    
    var ref = Firestore.instance.collection('venues');
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

  void _updateMarkers(List<DocumentSnapshot> documentList) {
    markers.clear();
    documentList.forEach((DocumentSnapshot document) async {
      GeoPoint pos = document.data['position']['geopoint'];
      double distance = document.data['distance'];
      String name = document.data['venueName'];
      Address val = await GetAddress.getAddress(LatLng(pos.latitude, pos.longitude));
      double far = await UserManagement.getDistanceToVenue(pos.latitude, pos.longitude);
      far = far/1000;
      Firestore.instance.collection('venues').document(document.documentID).updateData({'address': val.locality});
      Firestore.instance.collection('venues').document(document.documentID).updateData({'distance': far.toStringAsFixed(2)});

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
          _gotoMarker(pos.latitude, pos.longitude); //TODO: Show the horizontall tab of the venue.
        },
      );

      setState(() {
        markers[markerId] = marker;
      });
    });
  }

  _updateQuery(value) {
    setState(() {
      radius.add(value);
    });
  } // * This updates the radius value after zoom change, doesn't reload the venues.

  Future<void> getLocationOnce() async {
    try {
      currentUserLocation = await location.getLocation();
      print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
      print(currentUserLocation.latitude);
      print(currentUserLocation.longitude);
    } catch (e) {
      print(e);
      currentUserLocation = null;
    }
    _gotoLocation(currentUserLocation.latitude, currentUserLocation.longitude);
  }

  void _gotoLocation(double lat, double long) {
    zoomVal = 14.0;
    mapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: LatLng(lat, long), zoom: zoomVal, tilt: 50.0)));
  }
  
  void _gotoMarker(double lat, double long) {
    //var currZoom = mapController.cameraPosition().zoom; // ? FIX THIS
    mapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: LatLng(lat, long), zoom: zoomVal, tilt: 50.0)));
  }

  void _updateStatus(PermissionStatus status) {
    if (status != _status){
      setState(() {
        _status = status;
      });
    }
  }

  Future<void> _minus(double zoomVal) async {
    var pos = await location.getLocation();
    mapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: LatLng(pos.latitude, pos.longitude), zoom: zoomVal, tilt:50.0)));
  }
  Future<void> _plus(double zoomVal) async {
    var pos = await location.getLocation();
    mapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: LatLng(pos.latitude, pos.longitude), zoom: zoomVal, tilt:50.0)));
  }

  @override
  dispose() {
    subscription.cancel();
    super.dispose();
  }

}






  // bool isLocationGranted() {
  //   if (_status == PermissionStatus.granted){
  //     return true;
  //   } else {
  //     return false;
  //   }
  // }

  // void _askPermission() {
  //   PermissionHandler().requestPermissions([PermissionGroup.locationWhenInUse])
  //     .then(_onStatusRequested);
  // }

  // void _onStatusRequested(Map<PermissionGroup, PermissionStatus> statuses){
  //   final status = statuses[PermissionGroup.locationWhenInUse];
  //   if (status != PermissionStatus.granted){
  //     PermissionHandler().openAppSettings();
  //   } else {
  //     _updateStatus(status);
  //   }
  // }