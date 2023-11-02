import 'package:firebase_analytics/firebase_analytics.dart';

class AnalyticHelper {
  FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  List<AnalyticsEventItem>? listEventItem;

  Future<void> testEventLog(_value) async {
    await analytics.logEvent(
      name: '${_value}_click',
      parameters: {'value': _value},
    );
    print('send event $_value');
  }

  Future<void> testSetUserId(_value) async {
    await analytics.setUserId(id: '$_value');
    print('setUserId $_value');
  }

  Future<void> testUserProperty() async {
    await analytics.setUserProperty(name: 'regular', value: 'indeed');
    print('setUserProperty succeeded');
  }

  // Sets the duration of inactivity that terminates the current session.
  // The default value is 1800000 milliseconds (30 minutes).
  Future<void> testSessionTimeout() async {
    await analytics.setSessionTimeoutDuration(Duration(minutes: 60));
    print('session set timeout 60 min');
  }

  // Retrieves the app instance id from the service, or null if consent has been denied.
  Future<String?> testAppInstance() async {
    var result = await analytics.appInstanceId;
    print(result);
    print(result.runtimeType);
    return result;
  }

  // Clears all analytics data for this app from the device and resets the app instance id.
  Future<void> testResetAnalytics() async {
    await analytics.resetAnalyticsData();
    listEventItem = null;
    print('analytics reset');
  }

  // This event signifies that a user has submitted their payment information to your app.
  Future<void> testAddPayment(String paymentType, double value) async {
    await analytics.logAddPaymentInfo(
        paymentType: paymentType, currency: 'Rupiah', value: value);
    print('payment type : $paymentType');
    print('currency     : Rupiah');
    print('amount       : $value');
  }

  // This event signifies that an item was added to a cart for purchase.
  // Note: If you supply the [value] parameter, you must also supply the [currency] parameter so that revenue metrics can be computed accurately.
  Future<void> testAddToCart(List<Items> items) async {
    double tmpVal = 0;
    List<AnalyticsEventItem> tmp = listEventItem ?? [];
    for (var el in items) {
      tmp.add(AnalyticsEventItem(
        itemName: el.name,
        price: el.price,
        currency: 'Rupiah',
        discount: el.sales_price,
        quantity: el.amount,
      ));
      tmpVal = tmpVal + (el.price * el.amount);
    }
    listEventItem = tmp;
    await analytics.logAddToCart(items: tmp, value: tmpVal, currency: 'Rupiah');
    print('log Add to Cart');
    print(tmp);
    print(tmpVal);
  }

  Future<void> testPurchase() async {
    await analytics.logPurchase(currency: 'Rupiah', items: listEventItem);
    print('Purchase !!!');
    print('items purchased: $listEventItem');
    listEventItem = null;
    print('emptying list event item');
  }
}

class Items {
  Items({
    required this.name,
    required this.price,
    required this.sales_price,
    required this.amount,
  });
  String name;
  double price;
  double sales_price;
  int amount;
}
