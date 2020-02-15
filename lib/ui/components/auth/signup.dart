import 'package:bigwin/redux/actions.dart';
import 'package:bigwin/redux/store.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:loading/loading.dart';
import 'package:loading/indicator/ball_pulse_indicator.dart';
import '../../animations/fade_animation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../utilities/utilities.dart';
import '../../utilities/apiCall.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();

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
      return "Email Address not valid";
    else
      return null;
  }

  bool _isValidForm() {
    return nameController.text.length >= 5 && passwordController.text.length >= 6 &&
        _validateEmail(emailController.text) == null;
  }

  // Redirect after login
  void _redirect() {
    Navigator.of(context).pop();
  }

  Future<http.Response> _signup(String name, String email, String password) async{
    var url = 'http://betwin.isjetokoss.xyz/api/v1/auth/register';
    var response = await http.post(url, 
    body: {
      'name': name, 
      'password': password, 
      'email': email, 
      'password_confirmation': password
    },
    headers: {"X-Requested-With": "XMLHttpRequest"});
    return response;
  }
  
  Future<http.Response> _login(String email, String password) async{
    var url = Utilities.ROOT_URL + '/api/v1/auth/login';
    var response = await http.post(url, 
    body: {
      'password': password, 
      'email': email
    },
    headers: {"X-Requested-With": "XMLHttpRequest"});
    return response;
  }

  // Get the informations for the user
  Future<http.Response> _getUserInfos(String accessToken) async{
    var url = Utilities.ROOT_URL + '/api/v1/auth/user';
    var response = await http.get(url, headers: {"X-Requested-With": "XMLHttpRequest", "Authorization": "Bearer $accessToken"});
    return response;
  }

  // Called when user submit the form
  void _handleSubmit() {
    setState(() { _loading = true; });
    // Signup the user
    _signup(nameController.text, emailController.text, passwordController.text)
    .then((response) {
      if(response.statusCode == 200) {
        // And then login the user
        _login(emailController.text, passwordController.text)
        .then((response) {
            if(response.statusCode == 200) {
              final responseJson = json.decode(response.body);
              String accessToken = responseJson["data"]["access_token"];
              // Get user infos
              _getUserInfos(accessToken)
              .then((data) {
                // Set token on the global state
                store.dispatch(SetToken(token: accessToken));
                // Set user data on the global state
                final userDataJson = json.decode(data.body);
                var userData = userDataJson["data"];
                store.dispatch(SetUserData(userData: userData));
                // Store user data locally
                savePreference(accessToken, data.body);
                // set cloud messenging token
                setFCMToken(accessToken);
                // redirect to the main screen
                _redirect();
              })
              .catchError((onError) {
                _showDialog("Connexion error. Please try again.");
              });
            } else if(response.statusCode == 401) {
              _showDialog("Email Address or Password incorect.");
            }
            setState(() { _loading = false;});
        })
        .catchError((onError) {
          _showDialog("Connexion error. Please try again.");
          setState(() { _loading = false;});
        });
      } else {
        final responseJson = json.decode(response.body);
        _showDialog(responseJson["errors"]["email"][0]);
        setState(() {
          _loading = false;
        });
      }
    })
    .catchError((onError) {
      setState(() {
        _loading = false;
      });
      _showDialog("Connexion error. Please try again.");
    });
  }

  // Save persistant data on disk
  savePreference(String accessToken, String userData) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("token", accessToken);
    await prefs.setString("user", userData);
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
        color: Theme.of(context).accentColor,
        child: ListView(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(left:20, right: 20, bottom: 20, top: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text("SIGNUP", style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.w900),),
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
                  SizedBox(height: 35,),
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
                          // NAME FIELD
                          Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              border: Border(bottom: BorderSide(color: Colors.grey[200]))
                            ),
                            child: TextFormField(
                              controller: nameController,
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                hintText: "Name",
                                hintStyle: TextStyle(color: Colors.grey),
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.only(top: 14),
                                prefixIcon: Icon(
                                  Icons.person_outline,
                                  color: Color.fromRGBO(241, 181, 3, 1),
                                ),
                              ),
                              validator: (String value) {
                                if (value.trim().length < 5) {
                                  return "Min 6 caracters";
                                }
                              },
                            ),
                          ),
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
                                if (value.trim().length < 6) {
                                  return "Password Error, Min 6 caracters";
                                } else {
                                  return "";
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
                      child:  !_loading ? Text("SIGNUP NOW", style: TextStyle(fontSize: 16),) : Loading(indicator: BallPulseIndicator(), size: 60.0, ),
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
                      FadeAnimation(0, Text("You have an account ?", style: TextStyle(color: Theme.of(context).accentColor),)),
                      SizedBox(width: 5,),
                      InkWell(
                        child: FadeAnimation(0, Text("Login Here.", style: TextStyle(color: Theme.of(context).buttonColor, fontSize: 17, fontWeight: FontWeight.w600),)),
                        onTap: () => Navigator.of(context).popAndPushNamed('/login'),
                      ),
                    ],
                  ),
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
