import 'package:bigwin/redux/actions.dart';
import 'package:bigwin/redux/store.dart';
import 'package:bigwin/ui/utilities/utilities.dart';
import 'package:flutter/material.dart';
import '../../animations/fade_animation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:loading/loading.dart';
import 'package:loading/indicator/ball_pulse_indicator.dart';
import 'dart:convert';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool _loading = false;
  bool _isHidden = true;

  void _toggleVisibility() {
    setState(() {
      _isHidden = !_isHidden;
    });
  }

  String _validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value))
      return "Adresse Email incorecte";
    else
      return null;
  }

  bool _isValidForm() {
    return passwordController.text.length > 0 &&
        _validateEmail(emailController.text) == null;
  }

  // Redirect after login
  _redirect() {
    Navigator.of(context).pop();
  }

  // Save persistant data on disk
  savePreference(String accessToken, String userData) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("token", accessToken);
    await prefs.setString("user", userData);
  }

  Future<http.Response> _login(String email, String password) async{
    var url = 'http://betwin.isjetokoss.xyz/api/v1/auth/login';
    var response = await http.post(url, 
    body: {
      'password': password, 
      'email': email
    },
    headers: {"X-Requested-With": "XMLHttpRequest"});
    return response;
  }

  // Get the informations of the user
  Future<http.Response> _getUserInfos(String accessToken) async{
    var url = 'http://betwin.isjetokoss.xyz/api/v1/auth/user';
    var response = await http.get(url, headers: {"X-Requested-With": "XMLHttpRequest", "Authorization": "Bearer $accessToken"});
    return response;
  }

  // Called when user submit the form
  void _handleSubmit() {
    setState(() { _loading = true; });
    String email = emailController.text;
    String password = passwordController.text;
    _login(email, password)
    .then((response) {
        if(response.statusCode == 200) {
          final responseJson = json.decode(response.body);
          String accessToken = responseJson["data"]["access_token"];
          // Get user infos
          _getUserInfos(accessToken)
          .then((data) {
            // Store user data locally
            savePreference(accessToken, data.body);
            // Set token on the global state
            store.dispatch(SetToken(token: accessToken));
            // set cloud messenging token
              Utilities.setFCMToken(accessToken);
            // redirect to the main screen
            _redirect();
          })
          .catchError((onError) {
            _showDialog("Connexion error. Please try again.");
          });
        } else if(response.statusCode == 401) {
          _showDialog("Email Address or Password incorect.");
        }
        setState(() { _loading = false; });
    })
    .catchError((onError) {
      setState(() {_loading = false;});
      _showDialog("Connexion error. Please try again.");
    });
  }

  void _showDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Auth Error"),
          content: new Text(message),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("VIP Mode"),
        backgroundColor: Theme.of(context).accentColor,
        elevation: 0,
      ),
      body: Container(
        color: Color.fromRGBO(28, 28, 28, 1),
        child: ListView(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text("LOGIN", style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.w900),),
                  SizedBox(height: 10,),
                  Text("Subscribe Premium Tips to receive our best betting tips (Higher Odds, Higher Success Rate).", style: TextStyle(color: Colors.white, fontSize: 12.5),),
                ],
              ),
            ),
            SizedBox(height: 15,),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30))
              ),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  SizedBox(height: 45,),
                  FadeAnimation(0, Container(
                    margin: EdgeInsets.only(left: 30, right: 30),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [BoxShadow(
                        color: Color.fromRGBO(0, 0, 0, .2),
                        blurRadius: 20,
                        offset: Offset(0, 10)
                      )]
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          // EMAIL FIELD
                          Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              border: Border(bottom: BorderSide(color: Colors.grey[200]))
                            ),
                            child: TextFormField(
                              controller: emailController,
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                hintText: "Email Address",
                                hintStyle: TextStyle(color: Colors.grey),
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.only(top: 14),
                                prefixIcon: Icon(
                                  Icons.email,
                                  color: Color.fromRGBO(241, 181, 3, 1),
                                ),
                              ),
                              validator: _validateEmail
                            ),
                          ),
                          // PASSWORD FIELD
                          Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              border: Border(bottom: BorderSide(color: Colors.grey[200]))
                            ),
                            child: TextFormField(
                              controller: passwordController,
                              decoration: InputDecoration(
                                hintText: "Password",
                                hintStyle: TextStyle(color: Colors.grey),
                                contentPadding: EdgeInsets.only(top: 14),
                                border: InputBorder.none,
                                prefixIcon: Icon(
                                  Icons.lock,
                                  color: Theme.of(context).buttonColor,
                                ),
                                suffixIcon: IconButton(
                                  color: Colors.grey,
                                  onPressed: _toggleVisibility,
                                  icon: _isHidden
                                      ? Icon(Icons.visibility_off)
                                      : Icon(Icons.visibility),
                                ),
                              ),
                              validator: (String value) {
                                if (value.trim().length < 5) {
                                  return "Password Error, Min 6 caracters";
                                }
                              },
                              obscureText: _isHidden,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )),
                  
                  SizedBox(height: 20,),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 45.0,
                    padding: EdgeInsets.symmetric(horizontal: 30),
                    child: FadeAnimation(0, RaisedButton(
                      child: !_loading ? Text("LOGIN", style: TextStyle(fontSize: 16),) : Loading(indicator: BallPulseIndicator(), size: 60.0, ),
                      color: Theme.of(context).buttonColor,
                      disabledColor: Colors.grey,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)), 
                      onPressed: () {
                        _formKey.currentState.validate();
                        if (_isValidForm()) {
                          _handleSubmit();
                        }
                      },
                    ),),
                  ),
                  SizedBox(height: 30,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      FadeAnimation(0, Text("Not have an account ?", style: TextStyle(color: Theme.of(context).accentColor),)),
                      SizedBox(width: 5,),
                      InkWell(
                    child: FadeAnimation(0, Text(" Signup Here", style: TextStyle(color: Theme.of(context).buttonColor, fontSize: 17, fontWeight: FontWeight.w600),)),
                    onTap: () => Navigator.of(context).popAndPushNamed('/signup'),
                  ),
                    ],
                  ),
                  SizedBox(height: 15,),
                  // InkWell(
                  //   child: FadeAnimation(0, Text("Forgot your password ?", style: TextStyle(color: Theme.of(context).buttonColor),)),
                  //   onTap: null,
                  // ),
                  SizedBox(height: 50,),
                ],
              ),
            ),
          ],
        )
      )
    );
  }
}