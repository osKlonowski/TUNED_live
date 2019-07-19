import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:tuned_live/screens/home_page.dart';

class UserManagement {
  storeNewUser(user, context) {
    Firestore.instance.collection('/users').add({
      'email': user.email,
      'uid': user.uid
    }).then((value) {
      print('Successfully Added to Database\n');
      // Navigator.of(context).pop();
      // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage()));
    }).catchError((e) {
      print(e);
    });
  }
}