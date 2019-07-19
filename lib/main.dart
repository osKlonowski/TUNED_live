//import 'dart:async';
import 'package:flutter/material.dart';
import 'screens/welcome_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        title: 'TUNED LIVE',
        debugShowCheckedModeBanner: false,
        theme: new ThemeData(
          //primarySwatch: Colors.blue[700],
          primaryIconTheme: IconThemeData(color: Colors.white)
        ),
        home: new WelcomePage(),
    );
  }
}