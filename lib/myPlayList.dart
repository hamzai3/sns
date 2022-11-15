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

class MyPlaylist extends StatefulWidget {
  MyPlaylist();
  @override
  _MyPlaylistState createState() => _MyPlaylistState();
}

class _MyPlaylistState extends State<MyPlaylist> {
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

  MyPlaylist(
    token,
    id,
  ) async {
    print("Token i have is $token");
    try {
      var dio = Dio();
      // final result = await InternetAddress.lookup('google.com');
      // if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      FormData formData = new FormData.fromMap({
        "fetch_playlist": "fetch_playlist@sns",
        "token": token,
        "id": id,
      });
      try {
        form_response = await dio.post(
          c.getBaseUrl() + 'playlist_fetch.php',
          data: formData,
        );
      } on DioError catch (e) {
        print(e.message);
      }
      decodeMyPlaylist(form_response.toString());
      c.setshared("MyPlaylist", form_response.toString());
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

  late List data_MyPlaylist, temp_data = [];
  decodeMyPlaylist(js) {
    print("MyPlaylist are $js");
    setState(() {
      var jsonval = json.decode(js);
      data_MyPlaylist = jsonval["response"][0]['playlist'];
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
      setState(() {
        _token = token;
      });
      if (token != '' && token != null && token != ' ' && token != 'null') {
        c.getshared("MyPlaylist").then((value) {
          // print("CatVal $value");
          if (value != '' && value != null && value != ' ' && value != 'null') {
            decodeMyPlaylist(value);
          }
          c.getshared("user_id").then((user_id) {
            // print("CatVal $value");
            if (user_id != '' &&
                user_id != null &&
                user_id != ' ' &&
                user_id != 'null') {
              MyPlaylist(token, user_id);
            }
          });
        });
      } else {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => LoginPage()));
      }
    });
  }

  loadSong(id) async {
    // print("Token i have is $_token");
    try {
      var dio = Dio();
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        FormData formData = new FormData.fromMap({
          "fetch_playlist_songs": "fetch_playlist_songs@sns",
          "token": _token,
          "id": id,
        });
        try {
          form_response = await dio.post(
            c.getBaseUrl() + 'playlist_fetch.php',
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
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(15, 12, 10, 0),
            child: AutoSizeText(
              "My Playlist",
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
                        child: Text("No Playlist found"),
                      )
                    : Container(
                        padding: EdgeInsets.all(10),
                        color: Colors.white,
                        child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: data_MyPlaylist.length,
                            physics: NeverScrollableScrollPhysics(),
                            itemBuilder: (BuildContext context, int i) {
                              return GestureDetector(
                                onTap: () {
                                  loadSong(data_MyPlaylist[i]['playlist_id']);
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
                                    title: AutoSizeText(
                                      c.capitalize(data_MyPlaylist[i]['name']),
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w800,
                                          fontFamily: c.fontFamily(),
                                          color: c.getColor("grey")),
                                    ),
                                    trailing: const Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Icon(Icons.arrow_forward_ios),
                                    ),
                                  ),
                                ),
                              );
                            }),
                      ),
          ),
        ],
      )),
    );
  }
}
