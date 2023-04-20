import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import './cart.dart';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem({
    required this.id,
    required this.amount,
    required this.products,
    required this.dateTime,
  });
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];

  List<OrderItem> get orders {
    return [..._orders];
  }

  final String? authToken;
  final String? userId;

  Orders(this.authToken, this.userId, this._orders);

  // void addOrder(List<CartItem> cartProducts, double total) {
  //   //Add will always add at the end of the list but with insert 0
  //   //we add it at the beginning of the list
  //   //More recent orders are the now will come on the beginning of
  //   //list
  //   _orders.insert(
  //     0,
  //     OrderItem(
  //       id: DateTime.now().toString(),
  //       amount: total,
  //       products: cartProducts,
  //       dateTime: DateTime.now(),
  //     ),
  //   );

  //   notifyListeners();
  // }

  Future<void> fetchAndSetOrders() async {
    final url = Uri.parse(
        'https://shop-953-default-rtdb.firebaseio.com/orders/$userId.json?auth=$authToken');
    final response = await http.get(url);
    final List<OrderItem> loadedOrders = [];
    final extractedData = json.decode(response.body) as Map<String, dynamic>;
    // if (extractedData == null) {
    //   return;
    // }
    extractedData.forEach((orderId, orderData) {
      loadedOrders.add(
        OrderItem(
          dateTime: DateTime.parse(orderData['dateTime']),
          id: orderId,
          amount: orderData['amount'],
          products: (orderData['products'] as List<dynamic>)
              .map(
                (item) => CartItem(
                  id: item['id'],
                  title: item['title'],
                  quantity: item['quantity'],
                  price: item['price'],
                ),
              )
              .toList(),
        ),
      );
    });
    _orders = loadedOrders.reversed.toList();
    notifyListeners();
  }

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    final url = Uri.parse(
        'https://shop-953-default-rtdb.firebaseio.com/orders/$userId.json?auth=$authToken');
    final timestamp = DateTime.now();
    final response = await http.post(
      url,
      body: jsonEncode({
        'amount': total,
        'dateTime': timestamp.toIso8601String(),
        'products': cartProducts
            .map((cp) => {
                  'id': cp.id,
                  'title': cp.title,
                  'quantity': cp.quantity,
                  'price': cp.price,
                })
            .toList(),
      }),
    );

    _orders.insert(
      0,
      OrderItem(
        id: json.decode(response.body)['name'],
        amount: total,
        products: cartProducts,
        dateTime: timestamp,
      ),
    );

    notifyListeners();
  }
  // try {
  //   final response = await http.post(url,
  //       body: jsonEncode({
  //         'id': DateTime.now().toString(),
  //         'amount': total,
  //         'products': cartProducts,
  //         'dateTime': DateTime.now(),
  //       }));

  // final newProduct = Product(
  //   id: json.decode(response.body)['name'],
  //   title: product.title,
  //   description: product.description,
  //   price: product.price,
  //   imageUrl: product.imageUrl,
  //   );
  //   _items.add(newProduct);
  //   notifyListeners();
  // } catch (error) {
  //   print(error);
  //   throw error;
  // }
}
