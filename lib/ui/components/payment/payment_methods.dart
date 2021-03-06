import 'package:flutter/material.dart';
import '../../../models/package.dart';

class PaymentMethods extends StatelessWidget {
  const PaymentMethods({Key key}) : super(key: key);

  void _payWithStripe(context, package) {
     Navigator.pushNamed(context, "/stripe", 
    arguments: Package(id: package.id, name: package.name, price: package.price, interval: package.interval, intervalCount: package.intervalCount, categoryTip: package.categoryTip),);
  }

  @override
  Widget build(BuildContext context) {

    final Package args = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        title: Text('Complete subscription'),
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
                padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
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
            Container(
              padding: EdgeInsets.symmetric(vertical: 15),
              alignment: Alignment.center,
              child: Text('Choose your payment method.'),
            ),
            // Card(
            //   elevation: 2.0,
            //   child: ListTile(
            //     leading: Image(image: AssetImage('assets/orange.jpg'), width: 70),
            //     title: Text('Orange Money'),
            //     subtitle: Text(
            //       'Pay by Orange Money'
            //     ),
            //     trailing: Icon(Icons.arrow_right),
            //     onTap: () => _pay(context),
            //     isThreeLine: true,
            //   ),
            // ),
            // Card(
            //   margin: EdgeInsets.only(top: 10),
            //   elevation: 2.0,
            //   child: ListTile(
            //     leading: Image(image: AssetImage('assets/momo.jpg'), width: 70),
            //     title: Text('MTN Mobile Money'),
            //     subtitle: Text(
            //       'Pay by MTN Mobile Money'
            //     ),
            //     trailing: Icon(Icons.arrow_right),
            //     onTap: () => _pay(context),
            //     isThreeLine: true,
            //   ),
            // ),
            Card(
              margin: EdgeInsets.only(top: 10),
              elevation: 2.0,
              child: ListTile(
                leading: Image(image: AssetImage('assets/stripe.jpg'), width: 70),
                title: Text('Stripe Gateway'),
                subtitle: Text(
                  'Pay with Stripe'
                ),
                trailing: Icon(Icons.arrow_right),
                onTap: () => _payWithStripe(context, args),
                isThreeLine: true,
              ),
            ),
          ],
        )
      )
    );
  }
}