import 'package:alpha_mini_grocery/auth/google_sign_in.dart';
import 'package:alpha_mini_grocery/database/customer_db.dart';
import 'package:alpha_mini_grocery/database/member_db.dart';
import 'package:alpha_mini_grocery/widgets/item_widget_store.dart';
import 'package:alpha_mini_grocery/widgets/order_widget.dart';
import 'package:alpha_mini_grocery/widgets/store_widget.dart';
import 'package:alpha_mini_grocery/widgets/title_widget.dart';
import 'package:alpha_mini_grocery/windows/customer_side/cart_page.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../database/item_db.dart';

class StoreItemsPage extends StatefulWidget {
  const StoreItemsPage(
      {super.key,
      required this.email,
      required this.loginType,
      required this.storeEmail});
  final String email;
  final String loginType;
  final String storeEmail;
  @override
  State<StoreItemsPage> createState() =>
      _StoreItemsPageState(email, loginType, storeEmail);
}

class _StoreItemsPageState extends State<StoreItemsPage> {
  final String email;
  final String loginType;
  final String storeEmail;
  var cart = [];
  TextEditingController _controller = new TextEditingController(text: "1");
  var user = null;
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _asyncMethod();
    });
  }

  _StoreItemsPageState(this.email, this.loginType, this.storeEmail);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Column(
        children: [
          (user == null)
              ? const TitleWidget(
                  name: "Guest",
                  photoURL: "",
                  loginType: "guest",
                )
              : TitleWidget(
                  name: user['name'],
                  photoURL: user['photoURL'],
                  loginType: loginType,
                ),
          Expanded(
              child: FutureBuilder(
                  future: ItemDatabase.getItems(storeEmail),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.data == null) {
                      return Center(
                          child: LoadingAnimationWidget.staggeredDotsWave(
                              color: Colors.blueAccent, size: 50));
                    } else if (snapshot.data.length == 0) {
                      return Center(
                        child: Text("No stores available",
                            style: GoogleFonts.lato(fontSize: 16)),
                      );
                    } else {
                      return ListView.builder(
                          itemCount: snapshot.data.length,
                          itemBuilder: (BuildContext context, int index) {
                            print(snapshot.data[index]);
                            return Stack(children: [
                              ItemWidgetStore(
                                cartOrList: "store",
                                onTap: () {
                                  addToCart(snapshot.data[index]);
                                },
                                title: snapshot.data[index]['name'],
                                category: snapshot.data[index]['category'],
                                brand: snapshot.data[index]['brand'],
                                id: "",
                                price: snapshot.data[index]['price'],
                                quantity: snapshot.data[index]['quantity'],
                                imagePath: snapshot.data[index]['imageBytes'],
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
                  setState(() {});
                },
                iconSize: 27.0,
                icon: Icon(Icons.home, color: Colors.blue.shade900),
              ),
              IconButton(
                onPressed: () async {
                  if (cart.length == 0) {
                    Fluttertoast.showToast(
                        msg: 'Cart is currently empty', // Message
                        toastLength: Toast.LENGTH_LONG, // toast length
                        gravity: ToastGravity.BOTTOM, // position
                        backgroundColor: Colors.black, // background color
                        textColor: Colors.white // text color
                        );
                  } else {
                    var result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CartPage(
                                customerAddress:
                                    (user == null) ? "" : this.user["address"],
                                customerName:
                                    (user == null) ? "" : this.user["name"],
                                customerPhone:
                                    (user == null) ? "" : this.user["phone"],
                                cart: cart,
                                storeOwnerEmail: storeEmail,
                              )),
                    ).then((value) {
                      if (value == "order") {
                        Navigator.pop(context);
                      }
                    });
                  }
                },
                iconSize: 27.0,
                icon: Icon(Icons.shopping_cart_outlined, color: Colors.blue),
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

  Future<void> _asyncMethod() async {
    if (email != "") {
      var temp = await CustomerDatabase.findCustomer(this.email);
      setState(() {
        this.user = temp;
      });
    }
  }

  void addToCart(data) {
    Widget okButton = TextButton(
      child: const Text(
        "Add to cart",
        style: TextStyle(color: Colors.green),
      ),
      onPressed: () {
        int numberofitems = int.parse(_controller.text);
        if (numberofitems > data["quantity"]) {
          Fluttertoast.showToast(
              msg: 'Item not available in this quantity', // Message
              toastLength: Toast.LENGTH_LONG, // toast length
              gravity: ToastGravity.BOTTOM, // position
              backgroundColor: Colors.red, // background color
              textColor: Colors.white // text color
              );
        } else {
          data["orderQuantity"] = numberofitems;
          cart.add(data);
          Fluttertoast.showToast(
              msg: "Added to the cart", // Message
              toastLength: Toast.LENGTH_LONG, // toast length
              gravity: ToastGravity.BOTTOM, // position
              backgroundColor: Colors.black, // background color
              textColor: Colors.white // text color
              );
        }
        Navigator.pop(context);
      },
    );

    Widget nopeButton = TextButton(
      child: const Text(
        "Do not add",
        style: TextStyle(color: Colors.red),
      ),
      onPressed: () {
        Navigator.pop(context);
      },
    );

    AlertDialog alert = AlertDialog(
      title: const Text("How many items do you want to add? "),
      content: TextField(
        keyboardType: TextInputType.number,
        controller: _controller,
      ),
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
  }
}
