import 'package:alpha_mini_grocery/constants/constants.dart';
import 'package:alpha_mini_grocery/database/db.dart';
import 'package:alpha_mini_grocery/models/items.dart';

import 'package:mongo_dart/mongo_dart.dart';

import '../models/customer.dart';

class CustomerDatabase {
  static Future<Map<String, dynamic>> insertCustomer(Customer customer) async {
    final result = await Database.db
        ?.collection(CUSTOMER_COLLECTION)
        .insertOne(customer.toMap());
    return {...customer.toMap()};
  }

  static Future<Stream<Map<String, dynamic>>?> getCustomer(String email) async {
    var result = await Database.db
        ?.collection(CUSTOMER_COLLECTION)
        .find({"email": email});
    return result;
  }

  static Future<dynamic> findCustomer(String email) async {
    var res = await Database.db
        ?.collection(CUSTOMER_COLLECTION)
        .findOne({"email": email});

    return res;
  }

  static Future<dynamic> findCustomerHavingPassword(
      String email, String password) async {
    var res = await Database.db
        ?.collection(CUSTOMER_COLLECTION)
        .findOne({"email": email, "password": password});

    return res;
  }
}
