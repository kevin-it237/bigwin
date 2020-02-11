import 'package:bigwin/redux/store.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import '../../home.dart';
import '../../../models/package.dart';
import '../../utilities/payment.dart';
import '../../utilities/utilities.dart';
import '../../utilities/apiCall.dart';
import '../../../redux/actions.dart';


final List<String> days = ['01', '02', '03', '04', '05', '06', '07', '08', '09', '10', '11', '12'];
final List<String> years = ['2021', '2022', '2023', '2024', '2025', '2026', '2027', '2028', '2029', '2030'];

class Stripe extends StatefulWidget {
  Stripe({Key key}) : super(key: key);

  @override
  _StripeState createState() => _StripeState();
}

class _StripeState extends State<Stripe> {

  final _formKey = GlobalKey<FormState>();
  final creditCardNumberController = TextEditingController();
  final cvvController = TextEditingController();
  bool _loading = false;
  String dayValue = '01';
  String yearValue = '2021';

  void _pay(context, package) async {
    setState(() { _loading = true;});
    // get user data in state
    int userId = store.state.userData["id"];
    // Call api that made payment
    Payment.payWithStripe(creditCardNumberController.text, dayValue, yearValue, cvvController.text, userId, package.id)
    .then((response) {
      final paymentJson = json.decode(response.body);
      setState(() { _loading = false;});
      if(paymentJson["success"] == false) {
        Utilities.displayDialog(paymentJson["message"], context);
      } else if(paymentJson["success"] == true) {
        // Fetch new user data
        getUserInfos().then((data) {
          final responseJson = json.decode(data.body);
          // Set updated user data on the global state
          store.dispatch(SetUserData(userData: responseJson["data"]));
          // Store updated user data locally
          savePreference(data.body);

          // Redirect to the home page
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (BuildContext context) => Home()));
        }).catchError((onError) {
          Utilities.displayDialog("Connexion error. Please try again.", context);
        });

      }
    })
    .catchError((onError) {
      print(onError);
      setState(() { _loading = false;});
    });
  }

  // Save persistant data on disk
  savePreference(userData) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("user", userData);
  }

  bool _isValidForm() {
    if (creditCardNumberController.text.length <= 0 || cvvController.text.length != 3) {
      return false;
    } else {
      return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final Package args = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        title: Text('Make Payment'),
        backgroundColor: Color.fromRGBO(28, 28, 28, 1),
      ),
      body: Container(
        color: Color.fromRGBO(247, 248, 249, 1),
        padding: EdgeInsets.only(left: 15, right: 15, bottom: 20),
        child: ListView(
          children: <Widget>[
            Card(
              margin: EdgeInsets.only(top: 20),
              color: Theme.of(context).primaryColor,
              child: new Container(
                padding: new EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
                child: new Column(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 5),
                      alignment: Alignment.center,
                      child: Text('Package: ${args.name}', style: TextStyle(fontSize: 15, color: Colors.white),),
                    ),
                    Text('Cost: \$${args.price}', style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10.0),
            Container(
              padding: EdgeInsets.symmetric(vertical: 15),
              alignment: Alignment.center,
              child: Text('Enter your Credit Card information', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),),
            ),
            Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  TextFormField(
                    controller: creditCardNumberController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      hintText: "Credit Card Number",
                      hintStyle: TextStyle(
                        fontSize: 15.0,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                        borderSide: BorderSide(color:  Colors.black26),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      prefixIcon: Icon(Icons.credit_card, color: Theme.of(context).accentColor),
                    ),
                    validator: (String value) {
                      if (value.trim().length <= 0) {
                        return "Required Field";
                      } else {
                        return null;
                      }
                    },
                  ),
                  const SizedBox(height: 10.0),
                  TextFormField(
                    controller: cvvController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      hintText: "Credit Card CVV",
                      hintStyle: TextStyle(
                        fontSize: 15.0,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                        borderSide: BorderSide(color:  Colors.black26),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      prefixIcon: Icon(Icons.credit_card, color: Theme.of(context).accentColor),
                    ),
                    validator: (String value) {
                      if (value.trim().length != 3) {
                        return "Only 3 caracters";
                      } else {
                        return null;
                      }
                    },
                  ),
                  const SizedBox(height: 15.0),
                  Text('Expiration Date', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold), textAlign: TextAlign.left,),
                  const SizedBox(height: 5.0),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      DropdownButton<String>(
                        value: dayValue,
                        icon: Icon(Icons.arrow_downward),
                        iconSize: 24,
                        elevation: 16,
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 16
                        ),
                        underline: Container(
                          height: 2,
                          color: Theme.of(context).primaryColor,
                        ),
                        onChanged: (String newValue) {
                          setState(() {
                            dayValue = newValue;
                          });
                        },
                        items: days.map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          })
                          .toList(),
                      ),
                      SizedBox(width: 30,),
                      DropdownButton<String>(
                        value: yearValue,
                        icon: Icon(Icons.arrow_downward),
                        iconSize: 24,
                        elevation: 16,
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 16
                        ),
                        underline: Container(
                          height: 2,
                          color: Theme.of(context).primaryColor,
                        ),
                        onChanged: (String newValue) {
                          setState(() {
                            yearValue = newValue;
                          });
                        },
                        items: years.map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          })
                          .toList(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10.0),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 2.0),
                    color: Colors.transparent,
                    alignment: _loading ? Alignment.center : null,
                    width: MediaQuery.of(context).size.width,
                    height: 50,
                    child: !_loading ? RaisedButton(
                      onPressed: () {
                        _formKey.currentState.validate();
                        if(_isValidForm()) {
                          _pay(context, args);
                        }
                      }, 
                      color: Theme.of(context).buttonColor,
                      textColor: Colors.white,
                      disabledColor: Colors.grey,
                      padding: const EdgeInsets.all(0.0),
                      shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(3.0)),
                      child: Text(
                        "Pay Now",
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Raleway',
                          fontSize: 16.0,
                        ),
                      ),
                    ): CircularProgressIndicator(strokeWidth: 4, backgroundColor: Theme.of(context).buttonColor,),
                  ),
                ],
              )
            ),
          ],
        )
      )
    );
  }
}