import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:tuned_live/services/user_management.dart';

class WelcomePage extends StatefulWidget {
  @override
  _WelcomeState createState() => _WelcomeState();
}

class _WelcomeState extends State<WelcomePage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _email, _password, _name;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: Colors.white,
              image: DecorationImage(
                colorFilter: new ColorFilter.mode(
                    Colors.black.withOpacity(1.0), BlendMode.dstATop),
                image: AssetImage("./lib/assets/welcome_wallpaper-01.png"),
                fit: BoxFit.cover,
              ),
            ),
            child: Text(''),
          ),
          SlidingUpPanel(
            backdropEnabled: true,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24.0),
              topRight: Radius.circular(24.0),
            ),
            panel: Center(
              child: _LogInWidget(),
            ),
            collapsed: Container(
              decoration: BoxDecoration(
                color: Colors.blueGrey[800],
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24.0),
                  topRight: Radius.circular(24.0),
                ),
              ),
              child: Center(
                child: Column(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(top: 12.0),
                      width: 30,
                      height: 5,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.all(Radius.circular(12.0))
                      ),
                    ),
                    SizedBox(height: 26.0),
                    Text(
                      "Welcome to TUNED LIVE",
                      style: TextStyle(color: Colors.white, fontSize: 19.0),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _LogInWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(height: 12.0,),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width: 30,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.all(Radius.circular(12.0))
              ),
            ),
          ],
        ),
        SizedBox(height: 18.0,),
        Align(
          alignment: Alignment.center,
          child: DefaultTabController(
            length: 2,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TabBar(
                  isScrollable: false,
                  labelColor: Theme.of(context).accentColor,
                  unselectedLabelColor: Theme.of(context)
                      .textTheme.caption.color,
                  tabs: <Widget>[
                    Tab(
                      text: "Login",
                    ),
                    Tab(
                      text: "Sign Up",
                    ),
                  ],
                ),
                Container(
                  margin: EdgeInsets.only(top: 10),
                  height: 400,
                  child: TabBarView(
                    children: <Widget>[
                      _LogIn(),
                      _SignUp(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
  
  Widget _LogIn() {
    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(36.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  TextFormField(
                    obscureText: false,
                    onSaved: (input) => _email = input,
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.2),
                        hintText: "Email",
                        border:
                            OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
                  ),
                  SizedBox(height: 25.0),
                  TextFormField(
                    obscureText: true,
                    onSaved: (input) => _password = input,
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.2),
                        hintText: "Password",
                        border:
                            OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
                  ),
                  SizedBox(
                    height: 35.0,
                  ),
                  Material(
                    elevation: 5.0,
                    borderRadius: BorderRadius.circular(30.0),
                    color: Color(0xff01A0C7),
                    child: MaterialButton(
                      minWidth: 100,
                      padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                      onPressed: signIn,
                      child: Text("Login",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    ),
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  FlatButton(
                    child: Text('Forgot Password?', style: TextStyle(color: Colors.black54)),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _SignUp() {
    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(36.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  TextFormField(
                    onSaved: (input) => _name = input,
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                        hintText: "Full Name",
                        border:
                            OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
                  ),
                  SizedBox(height: 25.0),
                  TextFormField(
                    obscureText: false,
                    onSaved: (input) => _email = input,
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.2),
                        hintText: "Email",
                        border:
                            OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
                  ),
                  SizedBox(height: 25.0),
                  TextFormField(
                    obscureText: true,
                    onSaved: (input) => _password = input,
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.2),
                        hintText: "Password",
                        border:
                            OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
                  ),
                  SizedBox(
                    height: 35.0,
                  ),
                  Material(
                    elevation: 5.0,
                    borderRadius: BorderRadius.circular(30.0),
                    color: Color(0xff01A0C7),
                    child: MaterialButton(
                      minWidth: 100,
                      padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                      onPressed: signUp,
                      child: Text("Sign Up",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    ),
                  ),
                  SizedBox(height: 5.0),
                ],
              ),
            ),
          ),
        ],
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

  Future<void> signUp() async {
    final formState = _formKey.currentState;
    //Validate fields
    if(formState.validate()){
      formState.save();
      try {
        FirebaseAuth.instance.createUserWithEmailAndPassword(email: _email, password: _password).then((user) {
          UserManagement().storeNewUser(user, context, _name);
        }).catchError((e) {
          print(e.message);
        });
        //user.sendEmailVerification();
        Navigator.popAndPushNamed(context, '/homeScreen');
      }catch(e) {
        print(e);
      }
    }
  }

}