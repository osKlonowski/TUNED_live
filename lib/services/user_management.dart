import 'package:cloud_firestore/cloud_firestore.dart';
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
}