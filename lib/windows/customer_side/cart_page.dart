import 'package:alpha_mini_grocery/database/order_database.dart';
import 'package:alpha_mini_grocery/models/order.dart';
import 'package:alpha_mini_grocery/widgets/item_widget_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

class CartPage extends StatefulWidget {
  const CartPage(
      {super.key,
      required this.cart,
      required this.storeOwnerEmail,
      required this.customerName,
      required this.customerPhone,
      required this.customerAddress});
  final String customerName;
  final String customerPhone;
  final String customerAddress;
  final String storeOwnerEmail;
  final List<dynamic> cart;
  @override
  State<CartPage> createState() => _CartPageState(
      cart, storeOwnerEmail, customerName, customerPhone, customerAddress);
}

class _CartPageState extends State<CartPage> {
  final String customerName;
  final String customerPhone;
  final String customerAddress;
  final String storeOwnerEmail;
  final List<dynamic> cart;
  double ordertotal = 0;
  bool _checkBoxValue = false;
  TextEditingController nameController = new TextEditingController();
  TextEditingController phoneController = new TextEditingController();
  TextEditingController addressController = new TextEditingController();
  @override
  void initState() {
    super.initState();

    nameController.text = customerName;
    phoneController.text = customerPhone;
    addressController.text = customerAddress;
  }

  _CartPageState(this.cart, this.storeOwnerEmail, this.customerName,
      this.customerPhone, this.customerAddress);
  @override
  Widget build(BuildContext context) {
    ordertotal = 0;
    for (var i = 0; i < cart.length; i++) {
      ordertotal += cart[i]['price'] * cart[i]['orderQuantity'];
    }
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(30.0),
            child: Text("CART",
                style: GoogleFonts.lato(
                    fontSize: 30, fontWeight: FontWeight.bold)),
          ),
          Expanded(
            child: ListView.builder(
                itemCount: cart.length,
                itemBuilder: (BuildContext context, int index) {
                  print(cart[index]);
                  return Stack(children: [
                    ItemWidgetStore(
                      cartOrList: "cart",
                      onTap: () {
                        removeItem(index);
                      },
                      title: cart[index]['name'],
                      category: cart[index]['category'],
                      brand: cart[index]['brand'],
                      id: "",
                      price: cart[index]['price'],
                      quantity: cart[index]['orderQuantity'],
                      imagePath: cart[index]['imageBytes'],
                    ),
                  ]);
                }),
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Expanded(child: Text("Order Total: Rs. $ordertotal")),
            ElevatedButton(
              onPressed: () {
                placeOrder();
              },
              child: Text(
                "Place Order",
                style: GoogleFonts.lato(fontSize: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void removeItem(int index) {
    setState(() {
      cart.removeAt(index);
    });
  }

  void placeOrder() {
    Widget okButton = TextButton(
      child: const Text(
        "Place Order",
        style: TextStyle(color: Colors.green),
      ),
      onPressed: () async {
        if (cart.length == 0) {
          Navigator.pop(context);
        } else {
          String name = nameController.text;
          String phone = phoneController.text;
          String address = addressController.text;
          DateTime orderDateTime = DateTime.now();
          double orderValue = 0;
          for (var i = 0; i < cart.length; i++) {
            orderValue += cart[i]["price"] * cart[i]["orderQuantity"];
          }

          if (_checkBoxValue) orderValue = orderValue - orderValue * 0.20;

          var order = Order(name, phone, address, orderDateTime, orderValue,
              _checkBoxValue, "Pending", storeOwnerEmail, cart);

          await OrderDatabase.insertOrder(order)
              .then((value) => {Navigator.pop(context), navigateToMain()});
        }
      },
    );

    Widget nopeButton = TextButton(
      child: const Text(
        "Cancel",
        style: TextStyle(color: Colors.red),
      ),
      onPressed: () {
        Navigator.pop(context);
      },
    );

    showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              title: const Text("Please enter the following information "),
              content: Container(
                height: 400,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: TextField(
                            controller: nameController,
                            style: GoogleFonts.lato(),
                            decoration: const InputDecoration(
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                                labelText: "Enter Your Name",
                                hintText: "Muhammad Ahmed",
                                border: OutlineInputBorder())),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: TextField(
                            controller: phoneController,
                            style: GoogleFonts.lato(),
                            decoration: const InputDecoration(
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                                labelText: "Enter Your Phone Number",
                                hintText: "03011111111",
                                border: OutlineInputBorder())),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: TextField(
                            controller: addressController,
                            style: GoogleFonts.lato(),
                            decoration: const InputDecoration(
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                                labelText: "Enter Your Address",
                                hintText: "Mian Town RYK",
                                border: OutlineInputBorder())),
                      ),
                      Row(
                        children: [
                          Checkbox(
                            value: _checkBoxValue,
                            onChanged: (value) {
                              setState(() {
                                _checkBoxValue = !_checkBoxValue;
                              });
                            },
                          ),
                          Text("Are you an orphan?")
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                nopeButton,
                okButton,
              ],
            );
          });
        });
  }

  navigateToMain() {
    showToast();
    Navigator.pop(context, "order");
  }

  void showToast() {
    Fluttertoast.showToast(
        msg: 'Order Placed', // Message
        toastLength: Toast.LENGTH_LONG, // toast length
        gravity: ToastGravity.BOTTOM, // position
        backgroundColor: Colors.black, // background color
        textColor: Colors.white // text color
        );
  }
}
