import 'dart:convert';
import 'dart:io';

import 'package:alpha_mini_grocery/auth/google_sign_in.dart';
import 'package:alpha_mini_grocery/database/customer_db.dart';
import 'package:alpha_mini_grocery/database/item_db.dart';
import 'package:alpha_mini_grocery/database/member_db.dart';
import 'package:alpha_mini_grocery/models/customer.dart';
import 'package:alpha_mini_grocery/models/members.dart';
import 'package:alpha_mini_grocery/windows/customer_side/all_stores.dart';
import 'package:alpha_mini_grocery/windows/shopkeeper_side/shopkeeper_page.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

class CustomerSignUpPage extends StatefulWidget {
  String loginType;

  CustomerSignUpPage({
    super.key,
    this.loginType = "google",
  });

  @override
  State<CustomerSignUpPage> createState() =>
      _CustomerSignUpPageState(loginType: loginType);
}

class _CustomerSignUpPageState extends State<CustomerSignUpPage> {
  var user = null;
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _asyncMethod();
    });
  }

  String loginType;
  _CustomerSignUpPageState({
    required this.loginType,
  });
  TextEditingController fullnameController = new TextEditingController();
  TextEditingController emailController = new TextEditingController();
  TextEditingController phoneController = new TextEditingController();
  TextEditingController customerAddressController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  File? _image;

  final picker = ImagePicker();

  Future getImage(String type) async {
    final pickedFile = await picker.getImage(
        source: ImageSource.gallery, maxHeight: 200, maxWidth: 200);
    setState(() {
      if (type == "profile") {
        _image = File(pickedFile!.path);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (this.user != null) {
      fullnameController.text = this.user.displayName!;
      emailController.text = this.user.email!;
    }
    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text("CREATE CUSTOMER ACCOUNT",
                style: GoogleFonts.lato(
                    fontSize: 30, fontWeight: FontWeight.bold)),
          ),
          Padding(
              padding: const EdgeInsets.all(24.0),
              child: InkWell(
                onTap: () {
                  (loginType != "google")
                      ? getImage("profile")
                      : setState(() {});
                },
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.grey),
                    // borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                  ),
                  height: 200,
                  width: MediaQuery.of(context).size.width,
                  child: (loginType == "google")
                      ? Stack(
                          alignment: Alignment.center,
                          children: [
                            CircleAvatar(
                                radius: 100,
                                backgroundImage: (this.user != null)
                                    ? NetworkImage(this.user.photoUrl!)
                                    : null)
                          ],
                        )
                      : (_image == null)
                          ? Icon(Icons.camera_alt_outlined)
                          : Stack(
                              alignment: Alignment.center,
                              children: [
                                CircleAvatar(
                                    radius: 100,
                                    backgroundImage: FileImage(_image!))
                              ],
                            ),
                ),
              )),
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: TextField(
                controller: fullnameController,
                style: GoogleFonts.lato(),
                decoration: const InputDecoration(
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    labelText: "Your Full Name",
                    hintText: "Muhammad Ahmed",
                    border: OutlineInputBorder())),
          ),
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: TextField(
                controller: emailController,
                style: GoogleFonts.lato(),
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    labelText: "Your Email",
                    hintText: "test@abc.com",
                    border: OutlineInputBorder())),
          ),
          (loginType != "google")
              ? Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: TextField(
                      controller: passwordController,
                      obscureText: true,
                      enableSuggestions: false,
                      autocorrect: false,
                      style: GoogleFonts.lato(),
                      decoration: const InputDecoration(
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          labelText: "Enter a Password",
                          hintText: "********",
                          border: OutlineInputBorder())),
                )
              : const Padding(padding: EdgeInsets.all(0)),
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: TextField(
                controller: phoneController,
                keyboardType: TextInputType.number,
                style: GoogleFonts.lato(),
                decoration: const InputDecoration(
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    labelText: "Your Phone",
                    hintText: "03011231234",
                    border: OutlineInputBorder())),
          ),
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: TextField(
                controller: customerAddressController,
                style: GoogleFonts.lato(),
                decoration: const InputDecoration(
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    labelText: "Your Address",
                    hintText: "Gulshan Usman, Rahim Yar Khan",
                    border: OutlineInputBorder())),
          ),
        ]),
      )),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ElevatedButton(
          onPressed: () {
            createAccount();
          },
          child: Text(
            "Create Account",
            style: GoogleFonts.lato(fontSize: 20),
          ),
        ),
      ),
    );
  }

  Future<void> createAccount() async {
    String fullName = fullnameController.text;
    String email = emailController.text;
    String phone = phoneController.text;
    String customerAddress = customerAddressController.text;
    String imageBytes = (loginType == "google")
        ? this.user.photoUrl!
        : base64Encode(_image!.readAsBytesSync());
    String password = (loginType == "google") ? "" : passwordController.text;
    bool isOrphan = false;
    Widget okButton = TextButton(
      child: const Text(
        "Yes",
        style: TextStyle(color: Colors.red),
      ),
      onPressed: () {
        isOrphan = true;
      },
    );

    Widget nopeButton = TextButton(
      child: const Text("No"),
      onPressed: () {
        Navigator.pop(context);
      },
    );

    AlertDialog alert = AlertDialog(
      title: Text("Orphan Check"),
      content: const Text("Are you an orphan (We have discount for orphans?"),
      actions: [
        nopeButton,
        okButton,
      ],
    );
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    ).then((value) async => {
          await CustomerDatabase.insertCustomer(Customer(fullName, email,
                  imageBytes, customerAddress, password, phone, "id", isOrphan))
              .then((value) => {
                    showToast(value),
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AllStoresPage(
                            loginType: loginType,
                            user: value,
                          ),
                        ))
                  })
        });
  }

  Future<void> _asyncMethod() async {
    if (loginType == "google") {
      var temp = await GoogleSignInAPI.login();
      setState(() {
        user = temp;
      });

      await CustomerDatabase.findCustomer(user.email!).then((value) => {
            if (value != null)
              {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AllStoresPage(
                        loginType: loginType,
                        user: value,
                      ),
                    ))
              }
          });
    }
  }

  void showToast(value) {
    Fluttertoast.showToast(
        msg: 'Account created $value', // Message
        toastLength: Toast.LENGTH_LONG, // toast length
        gravity: ToastGravity.BOTTOM, // position
        backgroundColor: Colors.black, // background color
        textColor: Colors.white // text color
        );
  }
}
