import 'package:bigwin/models/package.dart';
import 'package:flutter/material.dart';
import '../../models/package.dart';

class PackageCard extends StatelessWidget {
  final Package package;

  PackageCard(this.package);

  void _pushToPayment(context) {
    Navigator.pushNamed(context, "/payment", 
    arguments: Package(id: this.package.id, name: this.package.name, price: this.package.price, interval: this.package.interval, categoryTip: this.package.categoryTip),);
  }

  Image setPackageImage(Package package) {
    String packageName = package.name.toLowerCase();
    if(packageName == "bigwyn discovered") {
      return Image(image: AssetImage('assets/1.png'), width: 85,);
    } else if(packageName == "bigwyn pro") {
      return Image(image: AssetImage('assets/2.png'), width: 85,);
    } else if(packageName == "bigwyn ultra") {
      return Image(image: AssetImage('assets/3.png'), width: 85,);
    } else if(packageName == "bigwyn mega") {
      return Image(image: AssetImage('assets/4.png'), width: 85,);
    } else {
      return Image(image: AssetImage('assets/logo.png'), width: 85,);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: package.name.toLowerCase() == "bigwyn discovered" ? 20: 0, bottom: 8, left: 13, right: 13),
      child: Card(
        elevation: 1.5,
        child: Row(
          children: <Widget>[
            Expanded(
              flex: 20,
              child: Container(
                padding: EdgeInsets.only(left: 10),
                alignment: Alignment.center,
                height: 120,
                child: setPackageImage(package),
              ),
            ),
            SizedBox(width: 18,),
            Expanded(
              flex: 40,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(package.name, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18,),textAlign: TextAlign.left,),
                  SizedBox(height: 5,),
                  Text("Unlock premium service for "+package.intervalCount.toString()+ " " +package.interval+ "(s).", style: TextStyle(fontSize: 12,),textAlign: TextAlign.left,),
                ],
              ),
            ),
            Expanded(
              flex: 40,
              child: Container(
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(top: 5),
                      padding: EdgeInsets.only(bottom: 15, top: 5),
                      child: Text("\$" + package.price.toStringAsFixed(2), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18,),textAlign: TextAlign.left,),
                    ),
                    Container(
                      padding: EdgeInsets.only(bottom: 15, top: 5, left: 20, right: 20),
                      height: 48.0,
                      child: RaisedButton(
                        child: Text("Select", style: TextStyle(fontSize: 13),),
                        color: Theme.of(context).buttonColor,
                        disabledColor: Colors.grey,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                        onPressed: () => _pushToPayment(context),
                      ),
                    ),
                  ],
                )
              ),
            ),
          ],
        ),
      ),
    );
  }
}