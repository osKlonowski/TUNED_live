//import 'dart:async';
import 'package:flutter/material.dart';
import 'package:tuned_live/screens/home_page.dart';
import 'package:tuned_live/screens/login_page.dart';
import 'package:tuned_live/screens/signup_page.dart';
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
        routes: <String, WidgetBuilder> {
          '/loginScreen': (BuildContext context) => new LoginPage(),
          '/signUpScreen' : (BuildContext context) => new SignUpPage(),
          '/homeScreen' : (BuildContext context) => new HomePage(),
          // '/screen4' : (BuildContext context) => new Screen4()
        },
    );
  }
}