//import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tuned_live/screens/login_page.dart';
import 'package:tuned_live/services/user_management.dart';

import 'home_page.dart';
//import 'login_page.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpState createState() => new _SignUpState();
}

class _SignUpState extends State<SignUpPage> {
  String _email, _password;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final emailField = TextFormField(
      obscureText: false,
      onSaved: (input) => _email = input,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Email",
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
    );
    final passwordField = TextFormField(
      obscureText: true,
      onSaved: (input) => _password = input,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Password",
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
    );
    final signUpButton = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Color(0xff01A0C7),
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: signUp,
        child: Text("Login",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );

    return Scaffold(
      body: Form(
        key: _formKey,
        child: Container(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(36.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 120.0,
                  child: Image.asset(
                    "./lib/assets/image_logo.png",
                    fit: BoxFit.contain,
                  ),
                ),
                SizedBox(height: 40.0),
                emailField,
                SizedBox(height: 25.0),
                passwordField,
                SizedBox(
                  height: 35.0,
                ),
                signUpButton,
                SizedBox(
                  height: 5.0,
                ),
                FlatButton(
                  child: Text('Already have an account? Sign In', style: TextStyle(color: Colors.black54)),
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> signUp() async {
    final formState = _formKey.currentState;
    //Validate fields
    if(formState.validate()){
      formState.save();
      try {
        FirebaseAuth.instance.createUserWithEmailAndPassword(email: _email, password: _password).then((user) {
          UserManagement().storeNewUser(user, context);
        }).catchError((e) {
          print(e.message);
        });
        //user.sendEmailVerification();
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage()));
      }catch(e) {
        print(e);
      }
    }
  }
}

