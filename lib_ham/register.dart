import 'dart:convert';
import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'NoInternet.dart';
import 'constants.dart';
import 'home.dart';
import 'intros.dart';
import 'login.dart';
import 'main.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  Constants c = Constants();
  final _formKey = GlobalKey<FormState>();
  List? data;
  TextEditingController alias = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController pwd = TextEditingController();
  TextEditingController cpwd = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isSubmitted = false;
  // Response? form_response;

  bool terms = false;
  bool hide_password = true, hide_cpassword = true;
  void showInSnackBar(String value) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: AutoSizeText(value,
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: c.getFontSizeLabel(context),
              fontFamily: c.fontFamily(),
              color: Colors.white)),
      duration: Duration(seconds: 2),
      behavior: SnackBarBehavior.floating,
      elevation: 5.0,
    ));
  }

  Response? form_response;
  _login() async {
    setState(() {
      _isSubmitted = true;
      FocusManager.instance.primaryFocus?.unfocus();
    });
    try {
      var dio = Dio();

      // final result = await InternetAddress.lookup('www.google.com');
      // if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        FormData formData = FormData.fromMap({
          "sign_up": "sign_up@sns",
          "username": alias.text.toString(),
          "email": email.text.toString(),
          "password": pwd.text.toString(),
        });
        try {
          var url = c.getBaseUrl() + 'register_api.php';
          print(url);
          form_response = await dio.post(
            url,
            data: formData,
          );
        } on DioError catch (e) {
          print(e.message);
        }
        setState(() {
          print("Response got " + form_response.toString().trim());
          var jsonval = json.decode(form_response.toString());
          data = jsonval["response"];
          if (data![0]['status'] == "failed") {
            if (data![0]['reason'] == "verification_pending") {
              showInSnackBar(
                  "Account verification pending, check registered email for verification link");
            } else {
              showInSnackBar(
                  "Account with this email already exists, try again");
            }
            _isSubmitted = false;
          } else if (data![0]['status'] == "success") {
            showInSnackBar("Account Created, Sign in to continue...");

            Future.delayed(Duration(seconds: 2), () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => LoginPage()));
            });
            _isSubmitted = false;
          }
        });
      // } else {
      //   Navigator.pushAndRemoveUntil(
      //       context,
      //       MaterialPageRoute(builder: (context) => NoInternet()),
      //       ModalRoute.withName('/NoInternet'));
      // }
    } catch (e, s) {
      print("Error " + e.toString() + " Stack " + s.toString());
    }
  }

  var close = 0;
  Future<bool> _exitApp(BuildContext context) async {
    if (close == 0) {
      showInSnackBar("Press back again to close app");
      close++;
    } else {
      exit(0);
    }
    return Future.value(false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        backgroundColor: c.backgroundColor(),
        body: WillPopScope(
            onWillPop: () => _exitApp(context),
            child: SafeArea(
                child: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                  padding: EdgeInsets.fromLTRB(
                                      c.deviceWidth(context) * 0.2,
                                      c.deviceWidth(context) * 0.3,
                                      c.deviceWidth(context) * 0.2,
                                      c.deviceWidth(context) * 0.1),
                                  child: AutoSizeText(
                                    'Register',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontFamily:
                                          c.fontFamily(type: "pacifico"),
                                      fontSize: c.getFontSizeLarge(context) + 5,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  )),
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                              top: 30.0,
                              left: MediaQuery.of(context).size.height * 0.02,
                              right: MediaQuery.of(context).size.height * 0.02,
                            ),
                            child: SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 0.082,
                              width: MediaQuery.of(context).size.width * 8.0,
                              child: TextFormField(
                                keyboardType: TextInputType.text,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    // return 'Mobile number is mandatory';
                                    return 'Full name cannot be empty';
                                  }
                                },
                                controller: alias,
                                style: TextStyle(
                                    fontSize: c.getFontSize(context),
                                    color: c.primaryColor()),
                                decoration: InputDecoration(
                                  hintText: "Full Name",
                                  fillColor: c.primaryColor(),
                                  filled: false, // dont forget this line
                                  hintStyle: TextStyle(
                                      fontSize: c.getFontSize(context),
                                      color: c.primaryColor()),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    borderSide: BorderSide(
                                      color: c.primaryColor(),
                                      width: 0,
                                      style: BorderStyle.none,
                                    ),
                                  ),
                                  contentPadding: EdgeInsets.all(16),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                              left: MediaQuery.of(context).size.height * 0.02,
                              right: MediaQuery.of(context).size.height * 0.02,
                            ),
                            child: SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 0.082,
                              width: MediaQuery.of(context).size.width * 8.0,
                              child: TextFormField(
                                keyboardType: TextInputType.text,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    // return 'Mobile number is mandatory';
                                    return 'Email ID cannot be empty';
                                  }
                                  if (!value.contains("@")) {
                                    // return 'Mobile number is mandatory';
                                    return 'Invalid Email ID';
                                  }
                                },
                                controller: email,
                                style: TextStyle(
                                    fontSize: c.getFontSize(context),
                                    color: c.primaryColor()),
                                decoration: InputDecoration(
                                  hintText: "Email",
                                  fillColor: c.primaryColor(),
                                  filled: false, // dont forget this line
                                  hintStyle: TextStyle(
                                      fontSize: c.getFontSize(context),
                                      color: c.primaryColor()),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    borderSide: BorderSide(
                                      color: c.primaryColor(),
                                      width: 0,
                                      style: BorderStyle.none,
                                    ),
                                  ),
                                  contentPadding: EdgeInsets.all(16),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                              // top: 10.0,
                              left: MediaQuery.of(context).size.height * 0.02,
                              right: MediaQuery.of(context).size.height * 0.02,
                            ),
                            child: SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 0.082,
                              width: MediaQuery.of(context).size.width * 8.0,
                              child: TextFormField(
                                keyboardType: TextInputType.emailAddress,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    // return 'Mobile number is mandatory';
                                    return 'Password cannot be empty';
                                  }
                                },
                                obscureText: hide_password,
                                controller: pwd,
                                style: TextStyle(
                                    fontSize: c.getFontSize(context),
                                    color: c.primaryColor()),
                                decoration: InputDecoration(
                                  suffix: InkWell(
                                    onTap: () {
                                      setState(() {
                                        if (hide_password) {
                                          hide_password = false;
                                        } else {
                                          hide_password = true;
                                        }
                                      });
                                    },
                                    child: Text(
                                      hide_password ? "😑" : "😯",
                                      style: TextStyle(color: c.whiteColor()),
                                    ),
                                  ),
                                  hintText: "Password",
                                  fillColor: c.primaryColor(),
                                  filled: false, // dont forget this line
                                  hintStyle: TextStyle(
                                      fontSize: c.getFontSize(context),
                                      color: c.primaryColor()),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    borderSide: BorderSide(
                                      style: BorderStyle.none,
                                    ),
                                  ),
                                  contentPadding: EdgeInsets.all(16),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                              // top: 10.0,
                              left: MediaQuery.of(context).size.height * 0.02,
                              right: MediaQuery.of(context).size.height * 0.02,
                            ),
                            child: SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 0.082,
                              width: MediaQuery.of(context).size.width * 8.0,
                              child: TextFormField(
                                keyboardType: TextInputType.emailAddress,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    // return 'Mobile number is mandatory';
                                    return 'Confirm Password cannot be empty';
                                  }
                                  if (pwd.text.toString() != value.toString()) {
                                    return 'Incorrect Password, Re-Enter your password';
                                  }
                                },
                                obscureText: hide_cpassword,
                                controller: cpwd,
                                style: TextStyle(
                                    fontSize: c.getFontSize(context),
                                    color: c.primaryColor()),
                                decoration: InputDecoration(
                                  suffix: InkWell(
                                    onTap: () {
                                      setState(() {
                                        if (hide_cpassword) {
                                          hide_cpassword = false;
                                        } else {
                                          hide_cpassword = true;
                                        }
                                      });
                                    },
                                    child: Text(
                                      hide_cpassword ? "😑" : "😯",
                                      style: TextStyle(color: c.whiteColor()),
                                    ),
                                  ),
                                  hintText: "Confirm Password",
                                  fillColor: c.primaryColor(),
                                  filled: false, // dont forget this line
                                  hintStyle: TextStyle(
                                      fontSize: c.getFontSize(context),
                                      color: c.primaryColor()),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    borderSide: BorderSide(
                                      style: BorderStyle.none,
                                    ),
                                  ),
                                  contentPadding: EdgeInsets.all(16),
                                ),
                              ),
                            ),
                          ),
                          CheckboxListTile(
                            title: RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: 'By continuing I agree to the',
                                    style: TextStyle(color: Colors.black),
                                  ),
                                  TextSpan(
                                    text: ' Terms of Service',
                                    style: TextStyle(color: Colors.blue),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        launchUrl(Uri.parse(
                                            'https://docs.flutter.io/flutter/services/UrlLauncher-class.html'));
                                      },
                                  ),
                                  TextSpan(
                                    text: ',\nPrivacy Policy,',
                                    style: TextStyle(color: Colors.blue),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        launchUrl(Uri.parse(
                                            'https://docs.flutter.io/flutter/services/UrlLauncher-class.html'));
                                      },
                                  ),
                                  TextSpan(
                                    text: ' Disclaimer of Liability',
                                    style: TextStyle(color: Colors.blue),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        launchUrl(Uri.parse(
                                            'https://docs.flutter.io/flutter/services/UrlLauncher-class.html'));
                                      },
                                  ),
                                  TextSpan(
                                    text: ' and Intellectual Property Notice',
                                    style: TextStyle(color: Colors.blue),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        launchUrl(Uri.parse(
                                            'https://docs.flutter.io/flutter/services/UrlLauncher-class.html'));
                                      },
                                  ),
                                ],
                              ),
                            ),
                            // Text(
                            //   "By continuing I agree to the Terms of Service,\nPrivacy Policy, Disclaimer of Liability and Intellectual Property Notice",
                            //   style: TextStyle(
                            //       color: Colors.black,
                            //       fontSize: c.getFontSizeSmall(context),
                            //       fontFamily: c.fontFamily()),
                            // ),
                            value: terms,
                            onChanged: (Value) {
                              print("Ok0");
                              setState(() {
                                terms = Value!;
                              });
                            },
                            controlAffinity: ListTileControlAffinity
                                .leading, //  <-- leading Checkbox
                          ),
                          _isSubmitted
                              ? Center(child: CircularProgressIndicator())
                              : Padding(
                                  padding: EdgeInsets.only(
                                    top: 10.0,
                                    bottom: 10.0,
                                    left: MediaQuery.of(context).size.height *
                                        0.02,
                                    right: MediaQuery.of(context).size.height *
                                        0.02,
                                  ),
                                  child: InkResponse(
                                    onTap: () {
                                      if (_formKey.currentState!.validate()) {
                                        print("Login");
                                        if (!terms) {
                                          c.showInSnackBar(context,
                                              "Kindly confirm if you agree to our policies");
                                        } else {
                                          _login();
                                        }
                                      }
                                    },
                                    child: Container(
                                      padding: EdgeInsets.all(13),
                                      decoration: BoxDecoration(
                                        color: c.primaryColor(),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Center(
                                        child: Text(
                                          "Start My Free Trial",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600,
                                            fontFamily: c.fontFamily(),
                                            fontSize:
                                                c.getFontSizeLabel(context) - 3,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                          InkWell(
                            onTap: () {
                              Navigator.of(context).pop();
                              Navigator.push(
                                  context,
                                  CupertinoPageRoute(
                                      builder: (_) => LoginPage()));
                              // CupertinoPageRoute(builder: (context) => AA02Disclaimer())
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text.rich(
                                  TextSpan(
                                    style: TextStyle(
                                        fontSize: c.getFontSizeLabel(context),
                                        fontFamily: c.fontFamily()),
                                    children: [
                                      TextSpan(text: "I have an account? "),
                                      TextSpan(
                                        text: 'Login',
                                        style: TextStyle(
                                            color: c.primaryColor(),
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      )),
                )
              ],
            ))));
  }
}
