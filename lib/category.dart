import 'dart:convert';
import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sns/PageManager.dart';
import 'package:sns/login.dart';
import 'package:sns/songs.dart';
import 'NoInternet.dart';
import 'bottomNav.dart';
import 'constants.dart';
import 'register.dart';
import 'package:intro_slider/intro_slider.dart';
import 'package:path_provider/path_provider.dart';

class Category extends StatefulWidget {
  final sublimals;
  Category({this.sublimals});
  @override
  _CategoryState createState() => _CategoryState();
}

class _CategoryState extends State<Category> {
  Constants c = Constants();
  final _formKey = GlobalKey<FormState>();
  TextEditingController email = TextEditingController();
  TextEditingController pwd = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isSubmitted = false;
  // Response? form_response;
  List<String> topics = [];
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

  List<ContentConfig> listContentConfig = [];
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

  Response? form_response;

  Category(token) async {
    print("Token i have is $token");
    try {
      var dio = Dio();
      // final result = await InternetAddress.lookup('google.com');
      // if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      FormData formData = new FormData.fromMap({
        "category_list": "category_list@sns",
        "token": token,
        "id": widget.sublimals,
      });
      try {
        form_response = await dio.post(
          c.getBaseUrl() + 'category_by_sublimal_api.php',
          data: formData,
        );
      } on DioError catch (e) {
        print(e.message);
      }
      decodeCategory(form_response.toString());
      c.setshared("Category", form_response.toString());
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

  late List data_Category, temp_data = [];
  decodeCategory(js) {
    print("Category are $js");
    setState(() {
      var jsonval = json.decode(js);
      data_Category = jsonval["response"][0]['cat_list'];
      if (jsonval["response"][0]['status'] == "failed") {
        setState(() {
          isLoading = false;
          no_posts = true;
        });
      } else if (jsonval["response"][0]['status'] == "success") {
        setState(() {
          isLoading = false;
        });
      }
    });
  }

  var user_id, alias;
  int selectedTopics = 0;
  bool isLoading = true, no_posts = false;
  var _token;
  void initState() {
    super.initState();
    c.getshared("token").then((token) {
      if (token != '' && token != null && token != ' ' && token != 'null') {
        setState(() {
          _token = token;
        });
        c.getshared("Category").then((value) {
          // print("CatVal $value");
          if (value != '' && value != null && value != ' ' && value != 'null') {
            decodeCategory(value);
          }
          Category(token);
        });
      } else {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => LoginPage()));
      }
    });
  }

  Songs(token) async {}

  // decodeSongs(js) {
  //   try {
  //     print("Songs $no_posts are $js");

  //     var jsonval = json.decode(js);
  //     data_Songs = jsonval["response"][0]['song_list'];

  //     if (jsonval["response"][0]['status'] == "failed") {
  //       setState(() {
  //         isLoading = false;
  //         no_posts = true;
  //       });
  //     } else if (jsonval["response"][0]['status'] == "success") {
  //       setState(() {
  //         isLoading = false;
  //         songData.add(data_Songs[0]);
  //         initPlayer();
  //       });
  //     }
  //   } catch (e) {
  //     setState(() {
  //       isLoading = false;
  //       no_posts = true;
  //     });
  //   }
  // }

  loadSong(cat_id) async {
    // print("Token i have is $_token");
    try {
      var dio = Dio();
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        FormData formData = new FormData.fromMap({
          "fetch_songs_by_category": "fetch_songs_by_category@sns",
          "token": _token,
          "cat_id": cat_id,
        });
        try {
          form_response = await dio.post(
            c.getBaseUrl() + 'fetch_songs_by_category.php',
            data: formData,
          );
        } on DioError catch (e) {
          print(e.message);
        }
        var jsonval = json.decode(form_response.toString());
        var data_Songs = jsonval["response"][0]['song_list'];
        // Navigator.push(
        //     context,
        //     CupertinoPageRoute(
        //         builder: (_) => Songs(
        //               cat_id: cat_id,
        //             )));
        Navigator.push(
            context,
            CupertinoPageRoute(
                builder: (_) => AudioManager(
                      index: 0,
                      allData: data_Songs,
                      maxlength: data_Songs.length,
                    )));
      } else {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => NoInternet()),
            ModalRoute.withName('/NoInternet'));
      }
    } catch (e, s) {
      print("Error " + e.toString() + " Stack " + s.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: c.getAppBar("Sound N Soulful"),
      drawer: c.getDrawer(context),
      backgroundColor: Colors.white,
      body: SafeArea(
          child: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 12, 10, 0),
            child: AutoSizeText(
              "Category",
              textAlign: TextAlign.start,
              style: TextStyle(
                  fontSize: c.getFontSizeLabel(context) + 8,
                  fontWeight: FontWeight.w800,
                  color: c.getColor("grey")),
            ),
          ),
          c.getDivider(10.0),
          Center(
            child: isLoading
                ? Container()
                : no_posts
                    ? Center(
                        child: Text("No category found in this subliminal"),
                      )
                    : Container(
                        color: Colors.white,
                        child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: data_Category.length,
                            physics: NeverScrollableScrollPhysics(),
                            itemBuilder: (BuildContext context, int i) {
                              return GestureDetector(
                                onTap: () {
                                  loadSong(data_Category[i]['cat_id']);
                                },
                                child: Container(
                                  decoration: const BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(
                                        color: Colors.grey,
                                        width: 0.20,
                                      ),
                                    ),
                                  ),
                                  child: ListTile(
                                    contentPadding: EdgeInsets.all(8),
                                    leading: ClipRRect(
                                      borderRadius: BorderRadius.circular(2.0),
                                      child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        child: CachedNetworkImage(
                                          width: c.deviceWidth(context) * 0.2,
                                          height:
                                              c.deviceHeight(context) * 0.15,
                                          imageUrl: data_Category[i]
                                                  ['base_url'] +
                                              "" +
                                              data_Category[i]['image_path'],
                                          placeholder: (context, url) =>
                                              const Padding(
                                            padding: EdgeInsets.all(58.0),
                                            child: CircularProgressIndicator(),
                                          ),
                                          fit: BoxFit.cover,
                                          errorWidget: (context, url, error) =>
                                              const Icon(Icons.circle_outlined),
                                        ),
                                      ),
                                    ),
                                    title: AutoSizeText(
                                      data_Category[i]['cat_name'],
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                          fontFamily: c.fontFamily(),
                                          // fontWeight: FontWeight.w800,
                                          color: c.getColor("grey")),
                                    ),
                                    trailing: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Icon(Icons.arrow_forward_ios),
                                    ),
                                  ),
                                ),
                              );
                            }),
                      ),
          ),
          c.getDivider(300.0),
        ],
      )),
      // bottomNavigationBar: BottomNav(currentPage: 0),
    );
  }
}
