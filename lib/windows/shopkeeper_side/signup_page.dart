import 'dart:convert';
import 'dart:io';

import 'package:alpha_mini_grocery/auth/google_sign_in.dart';
import 'package:alpha_mini_grocery/database/item_db.dart';
import 'package:alpha_mini_grocery/database/member_db.dart';
import 'package:alpha_mini_grocery/models/members.dart';
import 'package:alpha_mini_grocery/windows/shopkeeper_side/shopkeeper_page.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';

class SignUpPage extends StatefulWidget {
  String loginType;

  SignUpPage({
    super.key,
    this.loginType = "google",
  });

  @override
  State<SignUpPage> createState() => _SignUpPageState(loginType: loginType);
}

class _SignUpPageState extends State<SignUpPage> {
  var user = null;
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _asyncMethod();
    });
  }

  String loginType;
  _SignUpPageState({
    required this.loginType,
  });
  TextEditingController fullnameController = new TextEditingController();
  TextEditingController emailController = new TextEditingController();
  TextEditingController phoneController = new TextEditingController();
  TextEditingController storeNameController = new TextEditingController();
  TextEditingController storeAddressController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  File? _image;
  File? _storeImage;

  final picker = ImagePicker();

  Future getImage(String type) async {
    final pickedFile = await picker.getImage(
        source: ImageSource.gallery, maxHeight: 200, maxWidth: 200);
    setState(() {
      if (type == "profile") {
        _image = File(pickedFile!.path);
      } else {
        _storeImage = File(pickedFile!.path);
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
            child: Text("CREATE SHOPKEEPER ACCOUNT",
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
                controller: storeNameController,
                style: GoogleFonts.lato(),
                decoration: const InputDecoration(
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    labelText: "Your Store Name",
                    hintText: "Ahmed Superstore",
                    border: OutlineInputBorder())),
          ),
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: TextField(
                controller: storeAddressController,
                style: GoogleFonts.lato(),
                decoration: const InputDecoration(
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    labelText: "Your Store Address",
                    hintText: "Channab Commercial, Rahim Yar Khan",
                    border: OutlineInputBorder())),
          ),
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: InkWell(
              onTap: () {
                getImage("store");
              },
              child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                  ),
                  height: 200,
                  width: MediaQuery.of(context).size.width,
                  child: InputDecorator(
                    decoration: InputDecoration(
                      labelText: 'Your Store Image',
                      hoverColor: Colors.grey,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    child: (_storeImage != null)
                        ? Image.file(_storeImage!)
                        : const Center(child: Text("Capture Store Image")),
                  )),
            ),
          )
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
    String storeName = storeNameController.text;
    String storeAddress = storeAddressController.text;
    String storeImage = (_storeImage != null)
        ? base64Encode(_storeImage!.readAsBytesSync())
        : "";
    String imageBytes = (loginType == "google")
        ? this.user.photoUrl!
        : base64Encode(_image!.readAsBytesSync());
    String password = (loginType == "google") ? "" : passwordController.text;
    var member = Member(fullName, email, imageBytes, storeName, storeAddress,
        "id", phone, storeImage, password);

    await MemberDatabase.insertMember(member).then((value) => {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => ShopKeeperPage(
                email: email,
                loginType: loginType,
              ),
            ),
          )
        });
  }

  Future<void> _asyncMethod() async {
    if (this.loginType == "google") {
      var temp = await GoogleSignInAPI.login();
      setState(() {
        this.user = temp;
      });
      var result = await MemberDatabase.findMember(this.user.email!);
      var email = result['email'];
      if (result != null) {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => ShopKeeperPage(
                email: email,
                loginType: 'google',
              ),
            ));
      }
    }
  }

  void showToast() {
    Fluttertoast.showToast(
        msg: 'Account created', // Message
        toastLength: Toast.LENGTH_LONG, // toast length
        gravity: ToastGravity.BOTTOM, // position
        backgroundColor: Colors.black, // background color
        textColor: Colors.white // text color
        );
  }
}
