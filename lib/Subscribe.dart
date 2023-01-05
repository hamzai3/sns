import 'dart:convert';
import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:sns/home.dart';
import 'package:sns/login.dart';
import 'package:sns/player.dart';
import 'NoInternet.dart';
import 'package:sns/constants.dart';
import 'forgot.dart';
import 'intros.dart';
import 'register.dart';

class Subscribe extends StatefulWidget {
  @override
  _SubscribeState createState() => _SubscribeState();
}

class _SubscribeState extends State<Subscribe> {
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
  void initState() {
    // TODO: implement initState
    super.initState();

    c.getshared("username").then((value) {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: c.getAppBar("Subscribe"),
        drawer: c.getDrawer(context),
        backgroundColor: Colors.white,
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
                              Expanded(
                                child: Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 17),
                                    child: AutoSizeText(
                                      'Premium Subscription',
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                        fontFamily: c.fontFamily(),
                                        fontSize:
                                            c.getFontSizeLarge(context) - 3,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    )),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                  child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 17),
                                child: AutoSizeText(
                                  'Continue with monthly premium subscription'
                                      .toString(),
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                      fontSize: c.getFontSizeSmall(context),
                                      // fontWeight: FontWeight.w800,
                                      color: c.getColor("grey")),
                                ),
                              )),
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                              top: 30.0,
                              bottom: 30.0,
                              left: MediaQuery.of(context).size.height * 0.02,
                              right: MediaQuery.of(context).size.height * 0.02,
                            ),
                            child: InkResponse(
                              onTap: () async {
                                // if (_formKey.currentState!.validate()) {
                                //   print("Reset");
                                //   // _login();
                                //   Future.delayed(Duration(seconds: 1), () {
                                //     c.showInSnackBar(
                                //         context, "Email sent for reset link");
                                //   });
                                // }
                                c.showInSnackBar(context,
                                    "Preparing Payments, please wait...");
                                try {
                                  await Purchases.purchaseProduct(
                                      "monthly_1999_1m");
                                } on PlatformException catch (e) {
                                  var errorCode =
                                      PurchasesErrorHelper.getErrorCode(e);
                                  if (errorCode !=
                                      PurchasesErrorCode
                                          .purchaseCancelledError) {
                                    c.showInSnackBar(context, e.message!);
                                  }
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
                                    "\$19.99/month",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                      fontSize: c.getFontSizeLabel(context),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      )),
                ),
                Image.asset(
                  "assets/icons/subs.png",
                  width: c.deviceWidth(context) * 0.7,
                  height: c.deviceHeight(context) * 0.3,
                )
              ],
            ))));
  }
}
