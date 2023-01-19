import 'package:alpha_mini_grocery/auth/google_sign_in.dart';
import 'package:alpha_mini_grocery/database/member_db.dart';
import 'package:alpha_mini_grocery/database/order_database.dart';
import 'package:alpha_mini_grocery/models/order.dart';
import 'package:alpha_mini_grocery/widgets/item_widget_store.dart';
import 'package:alpha_mini_grocery/widgets/order_widget.dart';
import 'package:alpha_mini_grocery/widgets/title_widget.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key, this.user, this.loginType});
  final user;
  final loginType;
  @override
  State<OrdersPage> createState() => _OrdersPageState(user, loginType);
}

class _OrdersPageState extends State<OrdersPage> {
  final user;
  final loginType;
  @override
  void initState() {
    super.initState();
  }

  _OrdersPageState(this.user, this.loginType);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: (user != null)
              ? Column(
                  children: [
                    TitleWidget(
                      name: user['name'],
                      photoURL: user['photoURL'],
                      loginType: loginType,
                    ),
                    Expanded(
                        child: FutureBuilder(
                            future:
                                OrderDatabase.getCustomerOrders(user["phone"]),
                            builder:
                                (BuildContext context, AsyncSnapshot snapshot) {
                              if (snapshot.data == null) {
                                return Center(
                                    child: LoadingAnimationWidget
                                        .staggeredDotsWave(
                                            color: Colors.blueAccent,
                                            size: 50));
                              } else if (snapshot.data.length == 0) {
                                return Center(
                                  child: Text("No Orders Yet ",
                                      style: GoogleFonts.lato(fontSize: 16)),
                                );
                              } else {
                                return ListView.builder(
                                    itemCount: snapshot.data.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      print(snapshot.data[index]);
                                      return Stack(children: [
                                        InkWell(
                                          onTap: () {
                                            // gotoStore(
                                            //     snapshot.data[index]["email"]);
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.all(16.0),
                                            child: OrderWidget(
                                                widgetFor: "customer",
                                                onTapMarkAsDelivered: () async {
                                                  var order = Order(
                                                      snapshot.data[index]
                                                          ["customerName"],
                                                      snapshot.data[index]
                                                          ["phone"],
                                                      snapshot.data[index]
                                                          ["address"],
                                                      snapshot.data[index]
                                                          ["orderDateTime"],
                                                      double.parse(snapshot
                                                          .data[index]
                                                              ["orderValue"]
                                                          .toString()),
                                                      snapshot.data[index]
                                                          ["isCustomerOrphan"],
                                                      "Cancelled",
                                                      snapshot.data[index]
                                                          ["storeOwnerEmail"],
                                                      snapshot.data[index]
                                                          ["orderItems"]);
                                                  await OrderDatabase.cancelOrder(
                                                          snapshot.data[index]
                                                              ["orderDateTime"],
                                                          order)
                                                      .then((value) =>
                                                          {setState(() {})});
                                                },
                                                onTapViewDetails: () {
                                                  showDetails(
                                                      snapshot.data[index]);
                                                },
                                                customerName:
                                                    snapshot.data[index]
                                                        ["customerName"],
                                                customerAddress: snapshot
                                                    .data[index]["address"],
                                                orderValue: double.parse(
                                                    snapshot.data[index]
                                                            ["orderValue"]
                                                        .toString()),
                                                orderId: "AMG123",
                                                orderDateTime:
                                                    snapshot.data[index]
                                                        ["orderDateTime"],
                                                orderStatus:
                                                    snapshot.data[index]
                                                        ["orderStatus"]),
                                          ),
                                        )
                                      ]);
                                    });
                              }
                            }))

                    // OrderWidget(
                    //     onTapMarkAsDelivered: () {},
                    //     onTapViewDetails: () {},
                    //     customerName: "Ahmed",
                    //     customerAddress: "Mian Town, RYK",
                    //     orderValue: 100.0,
                    //     orderId: "AMG123",
                    //     orderDateTime: DateTime.now(),
                    //     orderStatus: "Delivered")
                  ],
                )
              : Column()),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        //color of the BottomAppBar
        color: Colors.white,
        child: Container(
          margin: const EdgeInsets.only(left: 12.0, right: 12.0),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                iconSize: 27.0,
                icon: Icon(Icons.home, color: Colors.blue),
              ),
              IconButton(
                onPressed: () {},
                iconSize: 27.0,
                icon: Icon(Icons.list_alt_sharp, color: Colors.blue.shade900),
              ),
              IconButton(
                onPressed: () {
                  Widget okButton = TextButton(
                    child: const Text(
                      "Yes, Logout",
                      style: TextStyle(color: Colors.red),
                    ),
                    onPressed: () {
                      GoogleSignInAPI.googleSignIn.signOut();
                      Navigator.of(context).pushNamedAndRemoveUntil(
                          '/', (Route<dynamic> route) => false);
                    },
                  );

                  Widget nopeButton = TextButton(
                    child: const Text("Stay here"),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  );

                  AlertDialog alert = AlertDialog(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    title: const Text("Logout"),
                    content: const Text("Are you sure you want to logout?"),
                    actions: [
                      nopeButton,
                      okButton,
                    ],
                  );
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return alert;
                    },
                  );
                },
                iconSize: 27.0,
                icon: Icon(Icons.logout, color: Colors.blue),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void showDetails(data) {
    Widget ok = TextButton(
      child: const Text("Got it"),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    print(data);
    AlertDialog alert = AlertDialog(
      title: const Text("Order Details"),
      content: SingleChildScrollView(
        child: Container(
            child: Column(
          children: [
            for (var i = 0; i < data["orderItems"].length; i++)
              ItemWidgetStore(
                  imagePath: data["orderItems"][i]["imageBytes"],
                  title: data["orderItems"][i]["name"],
                  price: data["orderItems"][i]["price"],
                  quantity: data["orderItems"][i]["orderQuantity"],
                  id: "id",
                  brand: data["orderItems"][i]["brand"],
                  category: data["orderItems"][i]["category"],
                  onTap: () {},
                  cartOrList: "test")
          ],
        )),
      ),
      actions: [
        ok,
      ],
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
