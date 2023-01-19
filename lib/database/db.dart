import 'package:alpha_mini_grocery/constants/constants.dart';

import 'package:mongo_dart/mongo_dart.dart';

class Database {
  static Db? db;
  static connect() async {
    db = await Db.create(MONGO_CONN_URL);
    await db?.open();
    print("Connected to the database");
  }
}
