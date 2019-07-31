import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
// import 'package:flutter/material.dart';
// import 'package:tuned_live/screens/home_page.dart';

class UserManagement {
  storeNewUser(user, context, name) {
    Firestore.instance.collection('/users').document(user.uid).setData({
      'name': name,
      'email': user.email,
      'uid': user.uid
    }).then((value) {
      print('Successfully Added to Database\n');
    }).catchError((e) {
      print(e);
    });
  }

  static Future<DocumentSnapshot> getUserInfo() async {
    final FirebaseUser user = await FirebaseAuth.instance.currentUser();
    var uid = user.uid;
    DocumentSnapshot result = await Firestore.instance.collection('users').document(uid).get();
    return result;
  }

  static Future<double> getDistanceToVenue(double lat1, double lng1) async {
    Location location = new Location();
    LocationData userLocation = await location.getLocation();
    LatLng pos = LatLng(userLocation.latitude, userLocation.longitude);
    double distanceInMeters = await Geolocator().distanceBetween(lat1, lng1, pos.latitude, pos.longitude);
    return distanceInMeters;
  }
}