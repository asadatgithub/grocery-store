import 'package:alpha_mini_grocery/constants/constants.dart';
import 'package:alpha_mini_grocery/models/items.dart';
import 'package:alpha_mini_grocery/models/order.dart';

import 'package:mongo_dart/mongo_dart.dart';

import 'db.dart';

class OrderDatabase {
  static Future<Map<String, dynamic>?> insertOrder(Order order) async {
    return await Database.db
        ?.collection(ORDER_COLLECTION)
        .insert(order.toMap());
  }

  static Future<dynamic> getOrders(String email) async {
    var result = await Database.db
        ?.collection(ORDER_COLLECTION)
        .find({"storeOwnerEmail": email}).toList();
    return result;
  }

  static Future<dynamic> getCustomerOrders(String phone) async {
    var result = await Database.db
        ?.collection(ORDER_COLLECTION)
        .find({"phone": phone}).toList();
    return result;
  }

  static Future<void> markAsDelivered(data, Order order) async {
    await Database.db
        ?.collection(ORDER_COLLECTION)
        .update({"_id": data}, order.toMap());
  }

  static Future<void> cancelOrder(data, Order order) async {
    await Database.db
        ?.collection(ORDER_COLLECTION)
        .update({"orderDateTime": data}, order.toMap());
  }
}
