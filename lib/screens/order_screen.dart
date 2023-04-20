import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/orders.dart' show Orders;
import '../widgets/order_item.dart';
import '../widgets/app_drawer.dart';

class OrderScreen extends StatefulWidget {
  static const routeName = '/order-screen';

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  // var _isLoading = false;

  // @override
  // void initState() {
  // *********1********
  // Future.delayed(Duration.zero).then((_) async {
  //   setState(() {
  //     _isLoading = true;
  //   });
  //   await Provider.of<Orders>(context, listen: false).fetchAndSetOrders();
  //   setState(() {
  //     _isLoading = false;
  //   });
  // });

  //**********2 */
  //_isLoading=true;
  // Provider.of<Orders>(context, listen: false).fetchAndSetOrders();.then((_){
  //    setState((){
  //       _isLoading=false;
  //   });
  // });

  // super.initState();
  // }

  ///////////////////BEST APPROACH FOR FUTURE-BUILDER///////////////
  ///By using this approach you ensure that no new future is created just
  ///because your widgets rebuilds
  ///If you had a scenenrio that a widget can be rebuild and you don't want
  ///to fetch new order just because something else changed then using this
  ///approach is better and ensures that no necessary http requests are send
  ///therefore this is considered to be a good practise
  late Future _ordersFuture;

  Future _obtainOrdersFuture() {
    return Provider.of<Orders>(context, listen: false).fetchAndSetOrders();
  }

  @override
  void initState() {
    _ordersFuture = _obtainOrdersFuture();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // final orderData = Provider.of<Orders>(context);
    //If we will not comment it out it will go in infinte loop

    return Scaffold(
      appBar: AppBar(
        title: Text('Your Orders'),
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
          // future:
          //     Provider.of<Orders>(context, listen: false).fetchAndSetOrders(),
          future: _ordersFuture,
          builder: (ctx, dataSnapshot) {
            if (dataSnapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else {
              if (dataSnapshot.error != null) {
                //....
                //Do error handling stuff
                return Center(
                  child: Text('An error occured!'),
                );
              } else {
                return Consumer<Orders>(
                  builder: (ctx, orderData, child) => ListView.builder(
                    itemCount: orderData.orders.length,
                    itemBuilder: (ctx, i) => OrderItem(orderData.orders[i]),
                  ),
                );
              }
            }
          }),
    );
  }
}
