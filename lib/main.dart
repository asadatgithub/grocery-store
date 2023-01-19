import 'package:alpha_mini_grocery/database/customer_db.dart';
import 'package:alpha_mini_grocery/database/db.dart';
import 'package:alpha_mini_grocery/database/member_db.dart';

import 'package:alpha_mini_grocery/windows/login_page.dart';
import 'package:flutter/material.dart';

import 'database/item_db.dart';
import 'database/order_database.dart';

Future<void> main() async {
  // WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp();
  // await Database.connect();
  // await OrderDatabase.connect();
  await Database.connect();
  // await CustomerDatabase.connect();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AMG',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => LoginPageShopKeeper(),
      },
    );
  }
}
