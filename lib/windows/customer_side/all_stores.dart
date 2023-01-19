import 'package:alpha_mini_grocery/auth/google_sign_in.dart';
import 'package:alpha_mini_grocery/database/customer_db.dart';
import 'package:alpha_mini_grocery/database/member_db.dart';
import 'package:alpha_mini_grocery/widgets/order_widget.dart';
import 'package:alpha_mini_grocery/widgets/store_widget.dart';
import 'package:alpha_mini_grocery/widgets/title_widget.dart';
import 'package:alpha_mini_grocery/windows/customer_side/orders_page.dart';
import 'package:alpha_mini_grocery/windows/customer_side/store_items.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../database/item_db.dart';

class AllStoresPage extends StatefulWidget {
  final user;
  final loginType;
  const AllStoresPage({super.key, this.user, this.loginType});

  @override
  State<AllStoresPage> createState() =>
      _AllStoresPageState(loginType: loginType, user: user);
}

class _AllStoresPageState extends State<AllStoresPage> {
  final user;
  final loginType;
  @override
  void initState() {
    super.initState();
  }

  _AllStoresPageState({this.user, this.loginType});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Column(
        children: [
          (user != null)
              ? TitleWidget(
                  name: user['name'],
                  photoURL: user['photoURL'],
                  loginType: loginType,
                )
              : const TitleWidget(
                  name: "Guest",
                  photoURL: "",
                  loginType: "guest",
                ),
          Expanded(
              child: FutureBuilder(
                  future: MemberDatabase.getMembers(),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.data == null) {
                      return Center(
                          child: LoadingAnimationWidget.staggeredDotsWave(
                              color: Colors.blueAccent, size: 50));
                    } else if (snapshot.data.length == 0) {
                      return Center(
                        child: Text(
                            "No stores available for shopping. Come back later :)",
                            style: GoogleFonts.lato(fontSize: 16)),
                      );
                    } else {
                      return ListView.builder(
                          itemCount: snapshot.data.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Stack(children: [
                              StoreWidget(
                                onTap: () {
                                  gotoStore(snapshot.data[index]["email"]);
                                },
                                title: snapshot.data[index]['storeName'],
                                address: snapshot.data[index]['storeAddress'],
                                imagePath: snapshot.data[index]['storeImage'],
                              ),
                            ]);
                          });
                    }
                  }))
        ],
      )),
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
                icon: Icon(Icons.home, color: Colors.blue.shade900),
              ),
              IconButton(
                onPressed: () async {
                  if (user == null) {
                    Fluttertoast.showToast(
                        msg: 'Please signin to view your orders', // Message
                        toastLength: Toast.LENGTH_LONG, // toast length
                        gravity: ToastGravity.BOTTOM, // position
                        backgroundColor: Colors.red, // background color
                        textColor: Colors.white // text color
                        );
                    return;
                  }
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => OrdersPage(
                              user: user,
                              loginType: loginType,
                            )),
                  ).then((value) {
                    setState(() {});
                  });
                },
                iconSize: 27.0,
                icon: Icon(Icons.list_alt_sharp, color: Colors.blue),
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

  void gotoStore(data) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => (user == null)
                ? StoreItemsPage(
                    email: "",
                    loginType: "guest",
                    storeEmail: data,
                  )
                : StoreItemsPage(
                    email: user["email"],
                    loginType: loginType,
                    storeEmail: data)));
  }
}
