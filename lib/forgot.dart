import 'dart:convert';
import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sns/home.dart';
import 'package:sns/login.dart';
import 'package:sns/player.dart';
import 'NoInternet.dart';
import 'package:sns/constants.dart';
import 'forgot.dart';
import 'intros.dart';
import 'register.dart';

class ForgotPage extends StatefulWidget {
  @override
  _ForgotPageState createState() => _ForgotPageState();
}

class _ForgotPageState extends State<ForgotPage> {
  Constants c = Constants();
  final _formKey = GlobalKey<FormState>();
  List? data;
  TextEditingController email = TextEditingController();
  TextEditingController pwd = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isSubmitted = false;
  // Response? form_response;

  bool hide_password = true;
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
      print("trying");
      _isSubmitted = true;
      FocusManager.instance.primaryFocus?.unfocus();
    });
    try {
      var dio = Dio();

      // final result = await InternetAddress.lookup('www.google.com');
      // if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      FormData formData = FormData.fromMap({
        "sign_in": "sign_in@sns",
        "email": email.text.toString(),
        "password": pwd.text.toString(),
      });
      print(formData);
      try {
        form_response = await dio.post(
          c.getBaseUrl() + 'login_api.php',
          data: formData,
        );
        print(form_response);
      } on DioError catch (e) {
        print(e.message);
      }
      setState(() {
        print("Response got in login " + form_response.toString().trim());
        var jsonval = json.decode(form_response.toString());
        data = jsonval["response"];
        if (data![0]['status'] == "failed") {
          if (data![0]['reason'] == "verification_pending") {
            showInSnackBar(
                "Account verification pending, check registered email for verification link");
          } else {
            showInSnackBar("Invalid email id or password, try again.");
          }
          _isSubmitted = false;
        } else if (data![0]['status'] == "success") {
          showInSnackBar("Sign in completed please wait...");
          c.setshared("user_id", data![0]['id']);
          c.setshared("username", data![0]['username']);
          c.setshared("email", data![0]['email']);
          c.setshared("token", data![0]['token']);
          Future.delayed(Duration(seconds: 2), () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => Intros()));
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
                          Padding(
                            padding: const EdgeInsets.all(28.0),
                            child: Image.asset(
                              "assets/sns.gif",
                              width: 200,
                            ),
                          ),
                          Row(
                            children: [
                              Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 17),
                                  child: AutoSizeText(
                                    'Reset password',
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      fontFamily: c.fontFamily(),
                                      fontSize: c.getFontSizeLarge(context),
                                      fontWeight: FontWeight.w800,
                                    ),
                                  )),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                  child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 17),
                                child: AutoSizeText(
                                  'Enter the email associated with your account and we’ll send an email with instructions to reset your password.'
                                      .toString(),
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                      fontSize: c.getFontSizeSmall(context) - 2,
                                      // fontWeight: FontWeight.w800,
                                      color: c.getColor("grey")),
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
                              child: Container(
                                padding: EdgeInsets.fromLTRB(1, 10, 1, 5),
                                margin: EdgeInsets.fromLTRB(1, 5, 1, 5),
                                decoration: c.neuroMorphicDecor(),
                                child: TextFormField(
                                  keyboardType: TextInputType.emailAddress,
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
                                        color: Colors.white,
                                      ),
                                    ),
                                    errorBorder: new OutlineInputBorder(
                                      borderSide: new BorderSide(
                                          color: Colors.white, width: 0.001),
                                    ),
                                    focusedErrorBorder: new OutlineInputBorder(
                                      borderSide: new BorderSide(
                                          color: Colors.white, width: 0.001),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(25.0),
                                      borderSide: BorderSide(
                                        color: Colors.white,
                                        width: 0.001,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20),
                                      borderSide: BorderSide(
                                        color: Colors.white,
                                        width: 0.0,
                                      ),
                                    ),
                                    contentPadding: EdgeInsets.all(16),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          _isSubmitted
                              ? Center(child: CircularProgressIndicator())
                              : Padding(
                                  padding: EdgeInsets.only(
                                    top: 30.0,
                                    bottom: 30.0,
                                    left: MediaQuery.of(context).size.height *
                                        0.02,
                                    right: MediaQuery.of(context).size.height *
                                        0.02,
                                  ),
                                  child: InkResponse(
                                    onTap: () {
                                      if (_formKey.currentState!.validate()) {
                                        print("Reset");
                                        // _login();
                                        Future.delayed(Duration(seconds: 1),
                                            () {
                                          c.showInSnackBar(context,
                                              "Email sent for reset link");
                                        });
                                      }
                                      // Future.delayed(const Duration(seconds: 0), () {
                                      //   Navigator.of(context).pop();
                                      //   Navigator.push(
                                      //       context,
                                      //       CupertinoPageRoute(
                                      //           builder: (_) => Intros()));
                                      // });
                                    },
                                    child: Container(
                                      padding: EdgeInsets.all(13),
                                      decoration: BoxDecoration(
                                        gradient: c.btnGradient(),
                                        color: c.primaryColor(),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Center(
                                        child: Text(
                                          "Reset",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600,
                                            fontSize:
                                                c.getFontSizeLabel(context),
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
                                      TextSpan(text: "Don't have an account? "),
                                      TextSpan(
                                        text: 'Register',
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
