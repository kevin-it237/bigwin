import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../components/loader.dart';

class Profile extends StatefulWidget {
  Profile({Key key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String _name;
  String _email;
  bool _loading = true;

  @override
  void initState() {
    _getUserData();
    super.initState();
  }

  // Get user data from localstorage
  void _getUserData() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String user =  prefs.getString("user");
    final userJson = json.decode(user);
    setState(() {
      _name = userJson["data"]["name"];
      _email = userJson["data"]["email"];
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "User Account",
          style: TextStyle(fontSize: 18.0),
        ),
        backgroundColor: Theme.of(context).accentColor,
      ),
      backgroundColor: Colors.white,
      body: !_loading ? SafeArea(
        child: ListView(
          padding: EdgeInsets.only(top: 30),
          children: <Widget>[
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 80,
                    backgroundImage: AssetImage('assets/user-logo.png'),
                  ),
                  SizedBox(height: 20,),
                  Text(
                    "BIGWIN ACCOUNT",
                    style: TextStyle(
                      fontSize: 20,
                      fontFamily: 'SourceSansPro',
                      color: Theme.of(context).buttonColor,
                      letterSpacing: 2.5,
                      fontWeight: FontWeight.w800
                    ),
                  ),
                  SizedBox(
                    height: 30.0,
                    width: 200,
                    child: Divider(
                      color: Colors.teal[100],
                    ),
                  ),
                  Card(
                      color: Colors.white,
                      margin:
                          EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
                      child: ListTile(
                        leading: Icon(
                          Icons.account_circle,
                          color: Theme.of(context).buttonColor,
                        ),
                        title: Text(
                          _name,
                          style:
                              TextStyle(fontSize: 17.0),
                        ),
                      )),
                  Card(
                    color: Colors.white,
                    margin:
                        EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
                    child: ListTile(
                      leading: Icon(
                        Icons.mail,
                        color: Theme.of(context).buttonColor,
                      ),
                      title: Text(
                        _email,
                        style: TextStyle(fontSize: 17.0),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        )
      ): Loader(),
    );
  }
}