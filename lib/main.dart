import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './screens/auth_screen.dart';
import './providers/auth.dart';
import './screens/product_detail_screen.dart';
import './screens/cart_screen.dart';
import './screens/product_overview_screen.dart';
import './providers/products.dart';
import './providers/cart.dart';
import './providers/orders.dart';
import './screens/order_screen.dart';
import './screens/user_products_screen.dart';
import './screens/edit_product_screen.dart';
import './screens/splash_screen.dart';
import './helpers/custom_route.dart';

void main() => runApp(MyApp());

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     // It allows us to register a class to whicj you can listen in child
// //widgets and whenever that class updates the widgets that are listening
// // and only this not all child widgets only widgets that are listening
// // will rebuild

//     return ChangeNotifierProvider(
//       //Whenever you create a new object based on a class as we are doing
//       // it here if you do that to provide object to the ChangeNotifierProvider
//       // you should use the create method for efficiency and to avoid bugs
//       //
//       create: (ctx) => Products(),

//       //Whenever we use the existing object like we were doing in the
//       //product_grid where we cycle through a list of products which
//       //already exist it is recommend that you use the value approach
//       //value: Products(),

//       //Only the widgets that are listening will be rebuild not the whole
//       //material app just because something change in product will not
//       //rebuild MaterialApp it will only rebuild widgets which are listening
//       child: MaterialApp(
//         title: 'MyShop',
//         theme: ThemeData(
//           primarySwatch: Colors.purple,
//           accentColor: Colors.deepOrange,
//           fontFamily: 'Lato',
//         ),
//         home: ProductOverviewScreen(),
//         routes: {
//           ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
//         },
//       ),
//     );
//   }
// }

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // ChangeNotifierProvider(
        //   create: (ctx) => Products(),
        // ),
        // ChangeNotifierProvider(
        //   create: (ctx) => Cart(),
        // ),
        // ChangeNotifierProvider(
        //   create: (ctx) => Orders(),
        // ),

        ChangeNotifierProvider.value(
          value: Auth(),
        ),

        ChangeNotifierProxyProvider<Auth, Products>(
          create: (_) => Products(null, null, []),
          update: (ctx, auth, previousProducts) => Products(
              auth.token,
              auth.userId,
              previousProducts == null ? [] : previousProducts.items),
        ),
        ChangeNotifierProvider.value(
          value: Cart(),
        ),
        ChangeNotifierProxyProvider<Auth, Orders>(
          create: (_) => Orders(null, null, []),
          update: (ctx, auth, previousOrders) => Orders(auth.token, auth.userId,
              previousOrders == null ? [] : previousOrders.orders),
        ),
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, _) => MaterialApp(
          title: 'MyShop',
          theme: ThemeData(
            primarySwatch: Colors.purple,
            accentColor: Colors.deepOrange,
            fontFamily: 'Lato',
            //For Custom transition Theme
            pageTransitionsTheme: PageTransitionsTheme(
              builders: {
                TargetPlatform.android: CustomPageTransitionBuilder(),
                TargetPlatform.iOS: CustomPageTransitionBuilder(),
              },
            ),
          ),
          home: auth.isAuth
              ? ProductOverviewScreen()
              : FutureBuilder(
                  future: auth.tryAutoLogin(),
                  builder: (ctx, authResultSnapshot) =>
                      authResultSnapshot.connectionState ==
                              ConnectionState.waiting
                          ? SplashScreen()
                          : AuthScreen(),
                ),
          routes: {
            ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
            CartScreen.routeName: (ctx) => CartScreen(),
            OrderScreen.routeName: (ctx) => OrderScreen(),
            UserProductScreen.routeName: (ctx) => UserProductScreen(),
            EditProductScreen.routeName: (ctx) => EditProductScreen(),
          },
        ),
      ),
    );
  }
}
