import 'package:alpha_mini_grocery/auth/google_sign_in.dart';
import 'package:alpha_mini_grocery/database/customer_db.dart';
import 'package:alpha_mini_grocery/database/member_db.dart';
import 'package:alpha_mini_grocery/windows/customer_side/all_stores.dart';
import 'package:alpha_mini_grocery/windows/customer_side/customer_signup_page.dart';
import 'package:alpha_mini_grocery/windows/shopkeeper_side/shopkeeper_page.dart';
import 'package:alpha_mini_grocery/windows/shopkeeper_side/signup_page.dart';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class LoginPageShopKeeper extends StatefulWidget {
  const LoginPageShopKeeper({super.key});

  @override
  State<LoginPageShopKeeper> createState() => _LoginPageShopKeeperState();
}

class _LoginPageShopKeeperState extends State<LoginPageShopKeeper> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool _checkBoxValue = false;
  bool loadingScreen = false;
  @override
  Widget build(BuildContext context) {
    return loadingScreen
        ? LoadingAnimationWidget.staggeredDotsWave(
            color: Colors.blueAccent, size: 50)
        : Scaffold(
            resizeToAvoidBottomInset: false,
            body: SingleChildScrollView(
              child: Column(children: [
                Stack(
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.fromLTRB(15.0, 110.0, 0.0, 0.0),
                      child: Text('Alpha',
                          style: GoogleFonts.lato(
                              fontSize: 80.0, fontWeight: FontWeight.bold)),
                    ),
                    Container(
                      padding: const EdgeInsets.fromLTRB(16.0, 175.0, 0.0, 0.0),
                      child: Text('Grocery',
                          style: GoogleFonts.lato(
                              fontSize: 80.0, fontWeight: FontWeight.bold)),
                    ),
                    // Container(
                    //   padding:
                    //       const EdgeInsets.fromLTRB(250.0, 175.0, 0.0, 0.0),
                    //   child: const Text('.',
                    //       style: TextStyle(
                    //           fontSize: 80.0,
                    //           fontWeight: FontWeight.bold,
                    //           color: Colors.blueAccent)),
                    // )
                  ],
                ),
                Container(
                    padding: const EdgeInsets.only(
                        top: 35.0, left: 20.0, right: 20.0),
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(18.0),
                          child: TextField(
                              controller: emailController,
                              style: GoogleFonts.lato(),
                              decoration: const InputDecoration(
                                  prefixIcon: Icon(Icons.email_outlined),
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.always,
                                  labelText: "Enter Your Email",
                                  hintText: "test@abc.com",
                                  border: OutlineInputBorder())),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(18.0),
                          child: TextField(
                              controller: passwordController,
                              obscureText: true,
                              enableSuggestions: false,
                              autocorrect: false,
                              style: GoogleFonts.lato(),
                              decoration: const InputDecoration(
                                  prefixIcon: Icon(Icons.lock_outline),
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.always,
                                  labelText: "Enter Your Password",
                                  hintText: "********",
                                  border: OutlineInputBorder())),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(13.0),
                          child: Row(
                            children: [
                              Checkbox(
                                value: _checkBoxValue,
                                onChanged: (value) {
                                  setState(() {
                                    _checkBoxValue = value!;
                                  });
                                },
                              ),
                              Text("Login as Shopkeeper")
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: InkWell(
                            onTap: () {
                              normalLogin();
                            },
                            child: Container(
                              height: 40.0,
                              child: Material(
                                borderRadius: BorderRadius.circular(12.0),
                                shadowColor: Colors.blueAccent,
                                color: Colors.blue,
                                elevation: 2.0,
                                child: const Center(
                                  child: Text(
                                    'LOGIN',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Montserrat'),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: InkWell(
                            onTap: () {
                              guestLogin();
                            },
                            child: Container(
                              height: 40.0,
                              child: Material(
                                borderRadius: BorderRadius.circular(12.0),
                                shadowColor: Colors.greenAccent,
                                color: Colors.green,
                                elevation: 2.0,
                                child: const Center(
                                  child: Text(
                                    'Continue as Guest',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Montserrat'),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              googleLogin();
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Container(
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.black,
                                        style: BorderStyle.solid,
                                        width: 1.0),
                                    color: Colors.transparent,
                                    borderRadius: BorderRadius.circular(12.0)),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const <Widget>[
                                    Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Center(
                                        child: Image(
                                            height: 20,
                                            width: 20,
                                            image: AssetImage(
                                                'assets/images/google.png')),
                                      ),
                                    ),
                                    Center(
                                      child: Text('Log in with Google',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'Montserrat')),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        Row(children: <Widget>[
                          const Expanded(child: Divider()),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "OR",
                              style: GoogleFonts.lato(),
                            ),
                          ),
                          const Expanded(child: Divider()),
                        ]),
                        InkWell(
                          onTap: () {
                            createANewAccount();
                          },
                          child: Text("Create A New Account",
                              style: GoogleFonts.lato(
                                decoration: TextDecoration.underline,
                              )),
                        )
                      ],
                    )),
              ]),
            ),
          );
  }

  Future<void> googleLogin() async {
    var temp = await GoogleSignInAPI.login();
    var result = null;
    if (_checkBoxValue) {
      await MemberDatabase.findMember(temp!.email).then((value) => {
            if (value == null)
              {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => SignUpPage(loginType: "google")))
              }
            else
              {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ShopKeeperPage(
                              loginType: "google",
                              email: temp!.email,
                            )))
              }
          });
    } else {
      await CustomerDatabase.findCustomer(temp!.email).then((value) => {
            if (value == null)
              {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            CustomerSignUpPage(loginType: "google")))
              }
            else
              {
                print("here,,,,,, $value"),
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AllStoresPage(
                      user: value,
                      loginType: 'google',
                    ),
                  ),
                )
              }
          });
    }
  }

  Future<void> normalLogin() async {
    String email = emailController.text;
    String password = passwordController.text;
    if (_checkBoxValue) {
      setState(() {
        loadingScreen = true;
      });
      await MemberDatabase.findMemberHavingPassword(email, password)
          .then((value) => {
                setState(() {
                  loadingScreen = false;
                }),
                if (value != null)
                  {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ShopKeeperPage(
                                email: email,
                                loginType: "normal",
                              )),
                    )
                  }
                else
                  showToast()
              });
    } else {
      await CustomerDatabase.findCustomerHavingPassword(email, password)
          .then((value) => {
                if (value != null)
                  {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AllStoresPage(
                                loginType: "normal",
                                user: value,
                              )),
                    )
                  }
                else
                  showToast()
              });
    }
  }

  void createANewAccount() {
    final user = null;
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => (_checkBoxValue)
              ? SignUpPage(
                  loginType: "normal",
                )
              : CustomerSignUpPage(
                  loginType: "nomral",
                )),
    );
  }

  void showToast() {
    Fluttertoast.showToast(
        msg: 'Invalid credentials', // Message
        toastLength: Toast.LENGTH_LONG, // toast length
        gravity: ToastGravity.BOTTOM, // position
        backgroundColor: Colors.red, // background color
        textColor: Colors.white // text color
        );
  }

  void guestLogin() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => AllStoresPage(
                user: null,
              )),
    );
  }
}
