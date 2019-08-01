import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tuned_live/screens/home_page.dart';
import 'package:tuned_live/screens/login_page.dart';
import 'package:tuned_live/screens/settings_page.dart';
import 'package:tuned_live/screens/signup_page.dart';
import 'package:tuned_live/services/edit_account_email.dart';
import 'package:tuned_live/services/edit_account_name.dart';
import 'package:tuned_live/services/personal_information.dart';
import 'screens/welcome_page.dart';

void main() => SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then((_) {
  runApp(MyApp());
});


class MyApp extends StatelessWidget {

  Future<FirebaseUser> getCurrentUser() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();

    if (user != null) {
      return user;
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        title: 'TUNED LIVE',
        debugShowCheckedModeBanner: false,
        theme: new ThemeData(
          //primarySwatch: Colors.blue[700],
          primaryIconTheme: IconThemeData(color: Colors.white)
        ),
        home: FutureBuilder<FirebaseUser>(
          future: getCurrentUser(),
          builder: (BuildContext context, AsyncSnapshot<FirebaseUser> snapshot) {
              switch (snapshot.connectionState) {
                  case ConnectionState.none:
                  case ConnectionState.waiting: 
                    return CircularProgressIndicator();
                  default: 
                    if (snapshot.hasError)
                        return Text('Error: ${snapshot.error}');
                    else
                      if(snapshot.data == null)
                          return WelcomePage();
                      else 
                          return HomePage();
              }
          }
        ),
        routes: <String, WidgetBuilder> {
          '/loginScreen': (BuildContext context) => new LoginPage(),
          '/signUpScreen' : (BuildContext context) => new SignUpPage(),
          '/homeScreen' : (BuildContext context) => new HomePage(),
          '/welcomeScreen' : (BuildContext context) => new WelcomePage(),
          '/settingScreen' : (BuildContext context) => new SettingsPage(),
          '/personalInformation' : (BuildContext context) => new PersonalInformation(),
          '/editAccountName' : (BuildContext context) => new EditName(),
          '/editAccountEmail' : (BuildContext context) => new EditEmail(),
        },
    );
  }
}