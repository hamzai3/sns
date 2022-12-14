import 'dart:convert';
import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:just_audio/just_audio.dart';
import 'package:sns/PLaylistPlayer.dart';
import 'package:sns/PageManager.dart';
import 'package:sns/SamplePlay.dart';
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

  showAlert(BuildContext context, id) {
    // print(no_postsPlay);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Edit Playlist Name",
                  style: TextStyle(
                      color: c.primaryColor(), fontWeight: FontWeight.w800),
                ),
                GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Icon(
                      Icons.close,
                      color: Colors.grey,
                    ))
              ],
            ),
            content: TextFormField(
              keyboardType: TextInputType.text,
              // obscureText: hide_password,
              controller: pwd,
              style: TextStyle(
                  fontSize: c.getFontSize(context), color: c.primaryColor()),
              autofocus: true,
              decoration: InputDecoration(
                hintText: "Enter Playlist Name",
                fillColor: c.primaryColor(),
                filled: false, // dont forget this line
                suffixIcon: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      c.getshared("token").then((token) {
                        setState(() {
                          _token = token;
                          savePlayList(token, id, pwd.text);
                        });
                      });
                    },
                    child: Icon(Icons.edit)),
                hintStyle: TextStyle(
                    fontSize: c.getFontSize(context), color: c.primaryColor()),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(
                    style: BorderStyle.none,
                  ),
                ),
                contentPadding: EdgeInsets.all(16),
              ),
            ),
          );
        });
      },
    );
  }

  showConfirm(BuildContext context, id) {
    // print(no_postsPlay);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      "Are you sure, you wish to delete this playlist and all songs in this playlist?",
                      style: TextStyle(
                          color: c.primaryColor(), fontWeight: FontWeight.w800),
                    ),
                  ),
                  GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Icon(
                        Icons.close,
                        color: Colors.grey,
                      ))
                ],
              ),
              content: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CupertinoButton(
                      child: Text("Cancel"),
                      onPressed: () {
                        Navigator.pop(context);
                      }),
                  CupertinoButton(
                      child: Text("Continue"),
                      onPressed: () {
                        Navigator.pop(context);
                        c.getshared("token").then((token) {
                          deletePlayList(token, id);
                        });
                      })
                ],
              ));
        });
      },
    );
  }

  savePlayList(token, id, name) async {
    setState(() {
      pwd.text = '';
    });
    try {
      var dio = Dio();
      // final result = await InternetAddress.lookup('google.com');
      // if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      FormData formData = new FormData.fromMap({
        "edit_playlist_songs": "edit_playlist_songs@sns",
        "token": token,
        "id": id,
        "name": name,
      });
      try {
        form_response = await dio.post(
          c.getBaseUrl() + 'edit_playlist.php',
          data: formData,
        );
      } on DioError catch (e) {
        print(e.message);
      }

      print("formData $formData");
      print("form_response $form_response");
      // decodePlay(form_response.toString());

      c.showInSnackBar(context, "Updated Playlist Name!");
      c.getshared("token").then((token) {
        setState(() {
          _token = token;
        });
        if (token != '' && token != null && token != ' ' && token != 'null') {
          c.getshared("user_id").then((user_id) {
            // print("CatVal $value");
            if (user_id != '' &&
                user_id != null &&
                user_id != ' ' &&
                user_id != 'null') {
              MyPlaylist(token, user_id);
            }
          });
        } else {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => LoginPage()));
        }
      });
    } catch (e, s) {
      print("Error " + e.toString() + " Stack " + s.toString());
    }
  }

  deletePlayList(token, id) async {
    setState(() {
      pwd.text = '';
    });
    try {
      var dio = Dio();
      // final result = await InternetAddress.lookup('google.com');
      // if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      FormData formData = new FormData.fromMap({
        "delete_playlist": "delete_playlist@sns",
        "token": token,
        "id": id,
      });
      try {
        form_response = await dio.post(
          c.getBaseUrl() + 'edit_playlist.php',
          data: formData,
        );
      } on DioError catch (e) {
        print(e.message);
      }

      print("formData for deleted $formData");
      print("form_response fore deleted $form_response");
      // decodePlay(form_response.toString());

      c.showInSnackBar(context, "Deleted Playlist!");
      c.getshared("token").then((token) {
        setState(() {
          _token = token;
        });
        if (token != '' && token != null && token != ' ' && token != 'null') {
          c.getshared("user_id").then((user_id) {
            // print("CatVal $value");
            if (user_id != '' &&
                user_id != null &&
                user_id != ' ' &&
                user_id != 'null') {
              MyPlaylist(token, user_id);
            }
          });
        } else {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => LoginPage()));
        }
      });
    } catch (e, s) {
      print("Error " + e.toString() + " Stack " + s.toString());
    }
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
        if (player != null) {
          player!.dispose();
        }
        Navigator.push(
            context,
            CupertinoPageRoute(
                builder: (_) => MyPlayListPlayer(
                    index: id,
                    allData: data_Songs,
                    maxlength: data_Songs.length,
                    mode: "playlist")));
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
      appBar: c.getAppBar("Sound & Soulful"),
      drawer: c.getDrawer(context),
      backgroundColor: Colors.white,
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          SafeArea(
              child: Column(
            children: [
              Expanded(
                child: ListView(
                  shrinkWrap: true,
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
                                      itemBuilder:
                                          (BuildContext context, int i) {
                                        return GestureDetector(
                                          onLongPress: () {
                                            setState(() {
                                              pwd.text =
                                                  data_MyPlaylist[i]['name'];
                                              showAlert(
                                                  context,
                                                  data_MyPlaylist[i]
                                                      ['playlist_id']);
                                            });
                                          },
                                          onTap: () {
                                            loadSong(data_MyPlaylist[i]
                                                ['playlist_id']);
                                          },
                                          child: Container(
                                            decoration: c.neuroMorphicDecor(),
                                            padding: EdgeInsets.all(10),
                                            margin: EdgeInsets.only(bottom: 10),
                                            child: ListTile(
                                              contentPadding: EdgeInsets.all(8),
                                              title: AutoSizeText(
                                                c.capitalize(
                                                    data_MyPlaylist[i]['name']),
                                                textAlign: TextAlign.left,
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w800,
                                                    fontFamily: c.fontFamily(),
                                                    color: c.getColor("grey")),
                                              ),
                                              trailing: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  GestureDetector(
                                                    onTap: () {
                                                      setState(() {
                                                        pwd.text =
                                                            data_MyPlaylist[i]
                                                                ['name'];
                                                        showAlert(
                                                            context,
                                                            data_MyPlaylist[i][
                                                                'playlist_id']);
                                                      });
                                                    },
                                                    child: const Padding(
                                                      padding:
                                                          EdgeInsets.all(8.0),
                                                      child: Icon(Icons.edit),
                                                    ),
                                                  ),
                                                  GestureDetector(
                                                    onTap: () {
                                                      showConfirm(
                                                          context,
                                                          data_MyPlaylist[i]
                                                              ['playlist_id']);
                                                    },
                                                    child: const Padding(
                                                      padding:
                                                          EdgeInsets.all(8.0),
                                                      child: Icon(
                                                          Icons.delete_forever),
                                                    ),
                                                  ),
                                                  const Padding(
                                                    padding:
                                                        EdgeInsets.all(8.0),
                                                    child: Icon(Icons
                                                        .arrow_forward_ios),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      }),
                                ),
                    ),
                  ],
                ),
              ),
            ],
          )),
          c.getPLayerSnackbar(context)
        ],
      ),
    );
  }
}
