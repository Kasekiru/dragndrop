import 'package:flutter/material.dart';
import 'package:flutter_application_1/analytic_helper.dart';
import 'package:http/http.dart';

class Pertemuan6Page extends StatefulWidget {
  Pertemuan6Page({super.key});

  @override
  State<Pertemuan6Page> createState() => _Pertemuan6PageState();
}

class _Pertemuan6PageState extends State<Pertemuan6Page> {
  AnalyticHelper fbAnalytics = AnalyticHelper();

  String appInstance = 'appinstance?';

  @override
  Widget build(BuildContext context) {
    // set session timeout for every session 1 min,
    // functional to login back -> set longer if want to log out
    fbAnalytics.testSessionTimeout();

    return Scaffold(
      appBar: AppBar(
        title: Text('Analytics Test'),
      ),
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                  onPressed: () {
                    fbAnalytics.testEventLog('send_event');
                  },
                  child: Text('send event')),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () {
                  fbAnalytics.testEventLog('send_error');
                },
                child: Text('send_error'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () {
                  fbAnalytics.testSetUserId('agung');
                },
                child: Text('Send User Id'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () {
                  fbAnalytics.testUserProperty();
                },
                child: Text('send property'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () async {
                  var response = await fbAnalytics.testAppInstance();
                  setState(() {
                    appInstance = response ?? 'null';
                  });
                },
                child: Text('$appInstance'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () async {
                  fbAnalytics.testResetAnalytics();
                },
                child: Text('reset analytics'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () async {
                  fbAnalytics.testAddPayment('Gopay', 20000);
                },
                child: Text('set Pay 20000 with Gopay'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () async {
                  fbAnalytics.testAddToCart([
                    Items(
                        name: 'milk',
                        price: 10000,
                        sales_price: 9000,
                        amount: 2),
                  ]);
                },
                child: Text('add 2 milk to cart'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () async {
                  fbAnalytics.testPurchase();
                },
                child: Text('purchase from cart'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
