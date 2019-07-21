import 'package:flutter/material.dart';
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tuned_live/screens/home_page.dart';

import 'signup_page.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginState createState() => new _LoginState();
}

class _LoginState extends State<LoginPage> {
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

    final loginButon = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Color(0xff01A0C7),
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: signIn,
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
                  height: 50.0,
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
                loginButon,
                SizedBox(
                  height: 5.0,
                ),
                FlatButton(
                  child: Text('Forgot Password?', style: TextStyle(color: Colors.black54)),
                  onPressed: () {
                    print("Hello World!"); // Send an email password reset.
                  },
                ),
                FlatButton(
                  child: Text('Don\'t have an account yet? Sign Up', style: TextStyle(color: Colors.blue[400])),
                  onPressed: () {
                    Navigator.popAndPushNamed(context, '/signUpScreen');
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> signIn() async {
    final formState = _formKey.currentState;
    //Validate fields => if they're empty, show an alertDialog to fill up the fields.
    if(formState.validate()){
      formState.save();
      try {
        FirebaseAuth.instance.signInWithEmailAndPassword(email: _email, password: _password).then((FirebaseUser user) {
          Navigator.popAndPushNamed(context, '/homeScreen'); //Handle empty fields
        }).catchError((e) {
          print(e.message);
        });
      }catch(e) {
        print(e);
      }
    }
  }

}


  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(
  //       title: Text('Login Sign Up Page'),
  //     ),
  //     body: Form(
  //       key: _formKey,
  //       // Implement Key
  //       child: Column(
  //         children: <Widget>[
  //           TextFormField(
  //             keyboardType: TextInputType.emailAddress,
  //             validator: (input) {
  //               if(input.isEmpty){
  //                 return "Please type an Email";
  //               }
  //             },
  //             onSaved: (input) => _email = input,
  //             decoration: InputDecoration(
  //               hintText: 'Email',
  //               contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
  //               border: OutlineInputBorder(
  //                 borderRadius: BorderRadius.circular(32.0)
  //               )
  //             ),
  //           ),
  //           TextFormField(
  //             validator: (input) {
  //               if(input.length < 6){
  //                 return "Your password needs to be at least 6 characters";
  //               }
  //             },
  //             onSaved: (input) => _password = input,
  //             decoration: InputDecoration(
  //               hintText: 'Password',
  //               contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
  //               border: OutlineInputBorder(
  //                 borderRadius: BorderRadius.circular(32.0)
  //               )
  //             ),
  //             obscureText: true,
  //           ),
  //           new Container(
  //             width: 320.0,
  //             height: 60.0,   
  //             alignment: FractionalOffset.center,
  //             decoration: new BoxDecoration(
  //               color: const Color.fromRGBO(247, 64, 106, 1.0),
  //               borderRadius: new BorderRadius.all(const Radius.circular(30.0)),
  //             ),
  //             child: new Text(
  //               "Sign In",
  //               style: new TextStyle(
  //                 color: Colors.white,
  //                 fontSize: 20.0,
  //                 fontWeight: FontWeight.w300,
  //                 letterSpacing: 0.3,
  //               ),
  //             ),
  //           ),      
  //           FlatButton(
  //             child: Text('Forgot Password?', style: TextStyle(color: Colors.black54)),
  //             onPressed: () {
  //               print("Hello World!");
  //             },
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }