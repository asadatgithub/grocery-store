import 'package:alpha_mini_grocery/constants/constants.dart';
import 'package:alpha_mini_grocery/models/items.dart';

import 'package:mongo_dart/mongo_dart.dart';

import 'db.dart';

class ItemDatabase {
  static Future<void> insert(Item item) async {
    // await Database.connect();
    await Database.db?.collection(ITEM_COLLECTION).insert(item.toMap());
  }

  static Future<dynamic> getItems(String email) async {
    return await Database.db
        ?.collection(ITEM_COLLECTION)
        .find({"memberEmail": email}).toList();
  }

  static Future<dynamic> update(Object id, Item item) async {
    //  await Database.connect();
    var u = await Database.db?.collection(ITEM_COLLECTION).findOne({"_id": id});
    u!["name"] = item.name;
    u["brand"] = item.brand;
    u["category"] = item.category;
    u["price"] = item.price;
    u["quantity"] = item.quantity;
    u["imageBytes"] = item.imageBytes;
    print(u);
    await Database.db?.collection(ITEM_COLLECTION).save(u!);
  }

  static Future<void> delete(Object id) async {
    // await Database.connect();
    await Database.db?.collection(ITEM_COLLECTION).deleteOne({"_id": id});
  }
}
