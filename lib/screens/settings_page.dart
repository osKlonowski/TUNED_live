import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<SettingsPage> {

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: new Text("Settings"),
        backgroundColor: new Color(0xFF151026),
        centerTitle: true,
        elevation: 2.0,
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: new IconButton(icon: Icon(Icons.arrow_back), onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
              Navigator.pushNamed(context, '/loginScreen');
            })
          )
        ],
      ),
      backgroundColor: Colors.white,
      body: Center(
        child: ListView(
          shrinkWrap: true,
          children: <Widget> [
            Container(
              decoration: new BoxDecoration(
                boxShadow: [new BoxShadow(
                  color: Colors.black12,
                  blurRadius: 3.0,
                ),]
              ),
              child: Card(
                margin: EdgeInsets.all(10.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.fromLTRB(10.0, 10.0, 20.0, 5.0),
                      child: const ListTile(
                        title: Text('Account Settings', style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold)),
                        subtitle: Text('Manage information about you, your preferences and account settings.'),
                      )
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
                      child: SwitchListTile(
                        activeColor: new Color(0xFF151026),
                        value: false,
                        title: Text("Enable Location Services"),
                        onChanged: (value) {},
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
                      child: SwitchListTile(
                        activeColor: new Color(0xFF151026),
                        value: false,
                        title: Text("Enable Notifications"),
                        onChanged: (value) {},
                      ),
                    ),
                    ListTile(
                      contentPadding: EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 5.0),
                      leading: Icon(Icons.person_outline, size: 32.0),
                      title: Text('Personal Information'),
                      subtitle: Text('Update your name, profile picture, and email address.'),
                    ),
                    ListTile(
                      contentPadding: EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 5.0),
                      leading: Icon(Icons.language, size: 32.0),
                      title: Text('Language'),
                      subtitle: Text('Let us know your language and translation preferences.'),
                    ),
                    ListTile(
                      contentPadding: EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 5.0),
                      leading: Icon(Icons.credit_card, size: 32.0),
                      title: Text('Payments'),
                      subtitle: Text('Let us know your language and translation preferences.'),
                    ),
                    Divider(),
                    Padding(
                      padding: EdgeInsets.fromLTRB(10.0, 10.0, 20.0, 5.0),
                      child: const ListTile(
                        title: Text('Security Settings', style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold)),
                        subtitle: Text('Change your password and take other actions to add more secuirty to your account.'),
                      )
                    ),
                    ListTile(
                      contentPadding: EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 5.0),
                      leading: Icon(Icons.lock, size: 32.0),
                      title: Text('Security and Login'),
                      subtitle: Text('Change your password or add your fingerprint.'),
                    ),
                    ListTile(
                      contentPadding: EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 5.0),
                      leading: Icon(Icons.settings, size: 32.0),
                      title: Text('Apps and Websites'),
                      subtitle: Text('Manage the information your share with other apps and users.'),
                    ),
                    // ButtonTheme.bar( // make buttons use the appropriate styles for cards
                    //   child: ButtonBar(
                    //     children: <Widget>[
                    //       FlatButton(
                    //         child: const Text('BUY TICKETS'),
                    //         onPressed: () { /* ... */ },
                    //       ),
                    //       FlatButton(
                    //         child: const Text('LISTEN'),
                    //         onPressed: () { /* ... */ },
                    //       ),
                    //     ],
                    //   ),
                    // ),
                  ],
                ),
              ),
            ),
          ],
        ),
      )
    );
  }


}