import 'package:alpha_mini_grocery/auth/google_sign_in.dart';
import 'package:alpha_mini_grocery/database/item_db.dart';
import 'package:alpha_mini_grocery/database/member_db.dart';
import 'package:alpha_mini_grocery/widgets/item_widget.dart';
import 'package:alpha_mini_grocery/widgets/title_widget.dart';

import 'package:alpha_mini_grocery/windows/shopkeeper_side/item_edit_page.dart';
import 'package:alpha_mini_grocery/windows/shopkeeper_side/item_page.dart';
import 'package:alpha_mini_grocery/windows/shopkeeper_side/orders_page.dart';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class ShopKeeperPage extends StatefulWidget {
  final String email;
  final String loginType;
  const ShopKeeperPage(
      {super.key, required this.email, required this.loginType});

  @override
  State<ShopKeeperPage> createState() => _ShopKeeperPageState(email, loginType);
}

class _ShopKeeperPageState extends State<ShopKeeperPage> {
  final String email;
  final String loginType;
  var user = null;
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _asyncMethod();
    });
  }

  _ShopKeeperPageState(this.email, this.loginType);
  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: (user != null)
            ? Column(children: [
                TitleWidget(
                  name: user['name'],
                  photoURL: user['photoURL'],
                  loginType: loginType,
                ),
                Expanded(
                  child: FutureBuilder(
                    future: ItemDatabase.getItems(user['email']),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (snapshot.data == null) {
                        return Center(
                            child: LoadingAnimationWidget.staggeredDotsWave(
                                color: Colors.blueAccent, size: 50));
                      } else if (snapshot.data.length == 0) {
                        return Center(
                          child: Text("No Items added yet. Click + icon to add",
                              style: GoogleFonts.lato(fontSize: 16)),
                        );
                      } else {
                        return ListView.builder(
                          itemCount: snapshot.data.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Stack(children: [
                              ItemWidget(
                                  onEditTap: () async {
                                    final reLoadPage = await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => ItemEditPage(
                                                user: user,
                                                brand: snapshot.data[index]
                                                    ['brand'],
                                                category: snapshot.data[index]
                                                    ['category'],
                                                id: snapshot.data[index]['_id'],
                                                imageBytes: snapshot.data[index]
                                                    ['imageBytes'],
                                                name: snapshot.data[index]
                                                    ['name'],
                                                price: snapshot.data[index]
                                                    ['price'],
                                                quantity: snapshot.data[index]
                                                    ['quantity'],
                                              )),
                                    ).then((value) {
                                      setState(() {
                                        // refresh state
                                      });
                                    });
                                  },
                                  onTap: () async {
                                    Widget okButton = TextButton(
                                      child: const Text(
                                        "Yes, Delete",
                                        style: TextStyle(color: Colors.red),
                                      ),
                                      onPressed: () async {
                                        await ItemDatabase.delete(
                                                snapshot.data[index]["_id"])
                                            .then((value) => {
                                                  setState(() {
                                                    Navigator.pop(context);
                                                  })
                                                });
                                      },
                                    );

                                    Widget nopeButton = TextButton(
                                      child: const Text("No, Don't Delete"),
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                    );
                                    String item = snapshot.data[index]['name'];
                                    AlertDialog alert = AlertDialog(
                                      icon: Icon(Icons.delete),
                                      title: Text("Delete Item: $item"),
                                      content: const Text(
                                          "Are you sure you want to delete this item?"),
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
                                  brand: snapshot.data[index]['brand'],
                                  category: snapshot.data[index]['category'],
                                  id: snapshot.data[index]['_id'],
                                  imagePath: snapshot.data[index]['imageBytes'],
                                  title: snapshot.data[index]['name'],
                                  price: snapshot.data[index]['price'],
                                  quantity: snapshot.data[index]['quantity']),
                            ]);
                          },
                        );
                      }
                    },
                  ),
                )
              ])
            : Column(),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation
          .endFloat, //specify the location of the FAB
      floatingActionButton: FloatingActionButton.extended(
        label: Text(
          "Add New Item",
          style: GoogleFonts.lato(),
        ),
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ItemPage(user: user)),
          ).then((value) {
            setState(() {});
          });
        },
        tooltip: "Add Item",
        elevation: 4.0,
        icon: Container(
          child: const Icon(Icons.add),
        ),
      ),
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
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => OrdersPage(
                              email: email,
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
    var temp = await MemberDatabase.findMember(this.email);

    setState(() {
      this.user = temp;
    });
  }
}
