import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import '../../../redux/app_state.dart';

class PaymentHistory extends StatelessWidget {
  const PaymentHistory({Key key}) : super(key: key);



  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(
          title: Text('Payment History'),
          backgroundColor: Color.fromRGBO(28, 28, 28, 1),
        ),
        body: StoreConnector<AppState, AppState>(
          converter: (store) => store.state,
          builder: (context, state) {
            if(state.userData["subscriptions"] != null) {
              return Container(
                  color: Color.fromRGBO(247, 248, 249, 1),
                  padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
                  child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: state.userData["subscriptions"].length,
                      itemBuilder: (BuildContext context, int index) {
                        return PackageHistoryCard(state.userData["subscriptions"][index]);
                      })
              );
            } else {
              return Container(
                alignment: Alignment.center,
                child: Text('No subscription'),
              );
            }
          },
        )
    );
  }
}

class PackageHistoryCard extends StatelessWidget {
  final Map<String, dynamic> payment;
  PackageHistoryCard(this.payment);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5.0),
      ),
      color: Color.fromRGBO(28, 28, 28, 1),
      margin: EdgeInsets.only(top: 15),
      elevation: 7,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          // SECOND Column
          Container(
            padding: EdgeInsets.only(top: 15, bottom: 15, left: 10, right: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                // ODDS
                Expanded(
                  flex: 25,
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: Theme.of(context).buttonColor,
                        borderRadius: new BorderRadius.all(Radius.circular(5.0))),
                    height: 75,
                    child: Text("\$"+payment["plan"]["price"].toString(), style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w900,color: Colors.white),),
                  ),
                ),
                // Paris infos
                Expanded(
                  flex: 75,
                  child:  Container(
                    padding: EdgeInsets.only(left: 12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Text(payment["plan"]["name"], style: TextStyle(fontSize: 18.0,color: Colors.white, fontWeight: FontWeight.w600)),
                            SizedBox(width: 10,),
                            Container(
                              child: payment["active"] ? Text( "(Active)", style: TextStyle(fontSize: 18.5,color: Colors.green, fontWeight: FontWeight.bold)) :
                              Text("(Expired)", style: TextStyle(fontSize: 18.5,color: Colors.redAccent, fontWeight: FontWeight.bold)),
                            ),
                          ],),
                        Container(
                          margin: EdgeInsets.only(top: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text("Pay with " + payment["payment_method"], style: TextStyle(fontSize: 15.0,color: Colors.white)),
                            ],),),
                        Container(
                          margin: EdgeInsets.only(top: 10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text("Start Date: " + payment["plan_period_start"], style: TextStyle(fontSize: 11.0,color: Colors.white)),
                              SizedBox(height: 8,),
                              Text("End Date: " + payment["plan_period_end"], style: TextStyle(fontSize: 11.0,color: Colors.white)),
                            ],),)
                      ],),
                  ),
                )
              ],),)
        ],
      ),
    );
  }
}
