import 'package:bigwin/redux/store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_redux/flutter_redux.dart';
import '../redux/actions.dart';
import '../redux/app_state.dart';
import '../ui/utilities/apiCall.dart';
import '../ui/utilities/utilities.dart';
import 'dart:convert';

//Import Screens
import './screens/today_tips.dart';
import './screens/today_combo.dart';
import './screens/old_tips.dart';
import './screens/premium_tips.dart';
import './screens/rate.dart';
import '../ui/components/auth/login.dart';
import '../ui/components/ChoiceMenu.dart';
import '../ui/components/loader.dart';


class Home extends StatefulWidget {

  @override
  _HomeState createState() => _HomeState();
}

// Menu Items
const List<Choice> choicesNonConnected = const <Choice>[
  const Choice(title: 'Language', icon: Icons.directions_car),
];

// Menu Items for connected user
const List<Choice> choicesConnected = const <Choice>[
  const Choice(title: 'Account Infos', icon: Icons.home),
  const Choice(title: 'Payment History', icon: Icons.directions_bike),
  //const Choice(title: 'Language', icon: Icons.directions_car),
  const Choice(title: 'Logout', icon: Icons.directions_bike),
];

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  bool _loading = false;
  int _selectedIndex = 0;

  List<Widget> _tabList = [PremiumTips(), TodayTips(), TodayCombo(), OldTips(), Rate()];

  PageController _pageController;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();


  @override
  void initState() {
    _pageController = PageController();
    // Get user informations
    _getCurrentUser();
    store.dispatch(StartFetchTodayTips());
    store.dispatch(StartFetchComboTips());
    store.dispatch(StartFetchOldTips());
    store.dispatch(StartFetchPremiumTips());
    configureFirebaseMessenging();
    super.initState();
  }

  static Future<dynamic> myBackgroundMessageHandler(Map<String, dynamic> message) {
    if (message.containsKey('data')) {
      // Handle data message
      // final dynamic data = message['data'];
    }

    if (message.containsKey('notification')) {
      // Handle notification message
      // final dynamic notification = message['notification'];
    }
  }

  void configureFirebaseMessenging() {
    _firebaseMessaging.configure(
       onMessage: (Map<String, dynamic> message) async {
         print("onMessage: $message");
        //  _showItemDialog(message);
       },
       onBackgroundMessage: myBackgroundMessageHandler,
       onLaunch: (Map<String, dynamic> message) async {
         print("onLaunch: $message");
        //  _navigateToItemDetail(message);
       },
       onResume: (Map<String, dynamic> message) async {
         print("onResume: $message");
        //  _navigateToItemDetail(message);
       },
     );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _select(Choice choice) {
      if(choice.title == "Logout") {
        _logout(store.state.accessToken);
      } else if(choice.title == "Account Infos") {
        Navigator.of(context).pushNamed("/profile");
      } else if(choice.title == "Language") {

      } else if(choice.title == "Payment History") {

      }
  }

  void _pushToLogin(context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Login()),
    );
  }
  
  void _pushToSubscribe(context) {
    Navigator.pushNamed(context, "/package");
  }
  
  _getCurrentUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // Init user token with data in locastorage
    String accessToken = prefs.getString("token");
    // Init user data with data in locastorage
    var userData = prefs.getString("user");
    if(accessToken != null) {
      // set token on the global state
      store.dispatch(SetToken(token: accessToken));
      // set user data on the global state
      final userDataJson = json.decode(userData);
      store.dispatch(SetUserData(userData: userDataJson["data"]));
      // get user data (the updated value)
      getUserInfos().then((data) {
        final responseJson = json.decode(data.body);
        // Set updated user data on the global state
        store.dispatch(SetUserData(userData: responseJson["data"]));
        // Store updated user data locally
        savePreference(data.body);
        print(data.body);
      }).catchError((onError) {
        Utilities.displayDialog("Connexion error. Please try again.", context);
      });
    }
  }

  // Save persistant data on disk
  savePreference(userData) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("user", userData);
  }

  _logout(String accessToken) async {
    // Clear token on the global state
    store.dispatch(SetToken(token: ""));
    store.dispatch(SetUserData(userData: null));
    // Clear token on the local storage
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove("user");
    prefs.remove("token");
    // setState(() {_loading = true;});
    // try {
    //   var url = 'http://betwin.isjetokoss.xyz/api/v1/auth/logout';
    //   var response = await http.get(url, headers: {"X-Requested-With": "XMLHttpRequest", "Authorization": "Bearer $accessToken"});
    //   final responseJson = json.decode(response.body);
    //   print(response.statusCode);
    //   print(responseJson);
    //   if(responseJson["success"]) {
    //     // Clear token on the global state
    //     store.dispatch(SetToken(null));
    //     setState(() {
    //       _vipUser = null;
    //       _loading = false;
    //     });
    //     // Clear token on the local storage
    //     SharedPreferences prefs = await SharedPreferences.getInstance();
    //     return prefs.clear();
    //   } else {
    //     setState(() {_loading = false;});
    //   }
    // } catch (e) {
    //   print(e);
    //   setState(() {_loading = false;});
    // }
  }

  // Display button for vip or NON Vip user
  Widget _displayMenuButton(accessToken, userData) {
    bool isVipUser = false;
    if(accessToken != "" && userData["current_subscription"] != null) {
      isVipUser = userData["current_subscription"]["active"];
    }
    if(accessToken == "" && !isVipUser) {
      return FlatButton(
            onPressed: () => _pushToLogin(context),
            child: Text("Go to VIP mode", style: TextStyle(fontSize: 13.0, color: Colors.black, fontWeight: FontWeight.w600),),
            color: Theme.of(context).buttonColor,);
    }
    if(accessToken != "" && !isVipUser) {
      return FlatButton(
            onPressed: () => _pushToSubscribe(context),
            child: Text("See Packages", style: TextStyle(fontSize: 13.0, color: Colors.white, fontWeight: FontWeight.w600),),
            color: Color.fromRGBO(19, 213, 45, 1));
    }
    if(accessToken != "" && isVipUser) {
      return IconButton(icon: Icon(Icons.star, color: Theme.of(context).buttonColor,), onPressed: null, );
    }
    return FlatButton(
            onPressed: () => _pushToLogin(context),
            child: Text("Go to VIP mode", style: TextStyle(fontSize: 13.0, color: Colors.black, fontWeight: FontWeight.w600),),
            color: Theme.of(context).buttonColor,);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(28, 28, 28, 1),
        leading: Container(child: Image(image: AssetImage('assets/logo.png')), padding: EdgeInsets.only(top: 9.0, bottom: 9.0, left: 15)),
        title: Text("BIGWIN", style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),),
        actions: <Widget>[
          Container(
            padding: EdgeInsets.only(top: 12.0, bottom: 12.0, right: 10),
            child: StoreConnector<AppState, AppState>(
              converter: (store) => store.state,
              builder: (context, state) {
                return _displayMenuButton(state.accessToken, state.userData);
              },
            )
          ),
          StoreConnector<AppState, AppState>(
            converter: (store) => store.state,
            builder: (context, state) {
              return PopupMenuButton<Choice>(
                onSelected: _select,
                itemBuilder: (BuildContext context) {
                  if(state.accessToken != "") {
                    return choicesConnected.map((Choice choice) {
                      return PopupMenuItem<Choice>(
                        value: choice,
                        child: Text(choice.title),
                      );
                    }).toList();
                  } else {
                    return choicesNonConnected.map((Choice choice) {
                      return PopupMenuItem<Choice>(
                        value: choice,
                        child: Text(choice.title),
                      );
                    }).toList();
                  }
                },
              );
            },
          )
        ],
      ),

      backgroundColor: Color.fromRGBO(35, 35, 35, 1),

      body: _loading ? Loader() : PageView(
        children: _tabList,
        controller: _pageController,
        onPageChanged: (index) => setState(() {
            _selectedIndex = index;
        }),
      ),

      bottomNavigationBar: BottomNavyBar(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        selectedIndex: _selectedIndex,
        showElevation: true,
        backgroundColor: Theme.of(context).primaryColor,
        onItemSelected: (index) => setState(() {
                    _selectedIndex = index;
                    _pageController.animateToPage(index,
                        duration: Duration(milliseconds: 300), curve: Curves.ease);
          }),
          iconSize: 20.0,
        items: [
          BottomNavyBarItem(
            icon: Icon(Ionicons.md_trophy),
            title: Text("Premium", style: TextStyle(fontSize: 12)),
            activeColor: Theme.of(context).primaryColorLight,
            inactiveColor: Colors.white
          ),
          BottomNavyBarItem(
            icon: Icon(Icons.event),
            title: Text("Today's Tips", style: TextStyle(fontSize: 12)),
            activeColor: Theme.of(context).primaryColorLight,
            inactiveColor: Colors.white
          ),
          BottomNavyBarItem(
              icon: Icon(Ionicons.md_cube),
              title: Text("Today's Combo", style: TextStyle(fontSize: 12)),
              activeColor: Theme.of(context).primaryColorLight,
              inactiveColor: Colors.white
          ),
          BottomNavyBarItem(
              icon: Icon(Icons.history),
              title: Text("Old Tips", style: TextStyle(fontSize: 12)),
              activeColor: Theme.of(context).primaryColorLight,
              inactiveColor: Colors.white
          ),
          BottomNavyBarItem(
              icon: Icon(Icons.thumb_up),
              title: Text("Rate Us", style: TextStyle(fontSize: 12)),
              activeColor: Theme.of(context).primaryColorLight,
              inactiveColor: Colors.white
          ),
        ],
      )
    );
  }
}