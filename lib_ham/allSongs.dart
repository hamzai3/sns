import 'dart:convert';
import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

class AllSongs extends StatefulWidget {
  final sublimals, play_id;
  AllSongs({this.sublimals, this.play_id});
  @override
  _AllSongsState createState() => _AllSongsState();
}

class _AllSongsState extends State<AllSongs> {
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

  AllSongs(token) async {
    print("Token i have is $token");
    try {
      var dio = Dio();
      // final result = await InternetAddress.lookup('google.com');
      // if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      FormData formData = new FormData.fromMap({
        "all_songs": "all_songs@sns",
        "token": token,
      });
      try {
        form_response = await dio.post(
          c.getBaseUrl() + 'fetch_all_songs_api.php',
          data: formData,
        );
      } on DioError catch (e) {
        print(e.message);
      }
      decodeAllSongs(form_response.toString());
      c.setshared("AllSongs", form_response.toString());
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

  late List data_AllSongs, temp_data = [];
  decodeAllSongs(js) {
    print("AllSongs are $js");
    setState(() {
      var jsonval = json.decode(js);
      data_AllSongs = jsonval["response"][0]['song_list'];
      if (jsonval["response"][0]['status'] == "failed") {
        setState(() {
          isLoading = false;
          no_posts = true;
        });
      } else if (jsonval["response"][0]['status'] == "success") {
        setState(() {
          isLoading = false;
          count = data_AllSongs.length;
          paginate(50);
        });
      }
    });
  }

  var user_id, alias;
  int selectedTopics = 0;
  bool isLoading = true, no_posts = false;

  void initState() {
    super.initState();
    c.getshared("token").then((token) {
      if (token != '' && token != null && token != ' ' && token != 'null') {
        c.getshared("AllSongs").then((value) {
          // print("CatVal $value");
          if (value != '' && value != null && value != ' ' && value != 'null') {
            decodeAllSongs(value);
          }
          AllSongs(token);
        });
      } else {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => LoginPage()));
      }
    });
  }

  int from = 0, to = 10, count = 0;
  paginate(val) {
    setState(() {
      from = val - 10;
      to = val;
      print("From $from and to $to");

      if (temp_data.isEmpty) {
        temp_data = data_AllSongs;
      }
      data_AllSongs = [];
      print("temp lent = ");
      print(temp_data.length);
      for (int d = 0; d < temp_data.length; d++) {
        if (d > from && d < to) {
          print("here $d is greater than $from and less tghab $to where");
          data_AllSongs.add(temp_data[d]);
        }
      }
      print("data lent = ");
      print(data_AllSongs.length);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: c.getAppBar("All Songs"),
      drawer: c.getDrawer(context),
      backgroundColor: Colors.white,
      body: SafeArea(
          child: ListView(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        children: [
          // Padding(
          //   padding: const EdgeInsets.fromLTRB(10, 12, 10, 0),
          //   child: AutoSizeText(
          //     "All Songs",
          //     textAlign: TextAlign.start,
          //     style: TextStyle(
          //         fontSize: c.getFontSizeLabel(context) + 8,
          //         fontWeight: FontWeight.w800,
          //         color: c.getColor("grey")),
          //   ),
          // ),
          c.getDivider(10.0),
          SizedBox(
            height: c.deviceHeight(context) * 0.73,
            child: isLoading
                ? Container()
                : no_posts
                    ? Center(
                        child: Text("No AllSongs found in this subliminal"),
                      )
                    : Container(
                        color: Colors.white,
                        child: ListView.builder(
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            physics: AlwaysScrollableScrollPhysics(),
                            itemCount: data_AllSongs.length,
                            itemBuilder: (BuildContext context, int i) {
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      CupertinoPageRoute(
                                          builder: (_) => MyPlayer(
                                                index: i,
                                                allData: data_AllSongs,
                                                maxlength: data_AllSongs.length,
                                              )));
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
                                          imageUrl: data_AllSongs[i]
                                                  ['base_url'] +
                                              "" +
                                              data_AllSongs[i]['image'],
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
                                      data_AllSongs[i]['name'],
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
          SizedBox(
              height: 55,
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  itemCount: int.parse(
                      (int.parse(count.toString()) / 10).round().toString()),
                  itemBuilder: (BuildContext context, int i) {
                    i = i + 1;
                    return GestureDetector(
                      onTap: () {
                        print(i * 10);
                        paginate(i * 10);
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          padding: EdgeInsets.all(10),
                          // color: c.primaryColor(),
                          decoration: BoxDecoration(
                            color: i * 10 == to ? Colors.black : Colors.white,
                            border: Border.all(
                              color: Colors.black,
                              style: BorderStyle.solid,
                              width: 1.0,
                            ),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 1.0),
                            child: Text(
                              'Page ${(i)}',
                              style: TextStyle(
                                  fontSize: i * 10 == to
                                      ? c.getFontSize(context) - 2
                                      : c.getFontSize(context) - 4,
                                  color: i * 10 == to
                                      ? Colors.white
                                      : Colors.black,
                                  fontWeight: i * 10 == to
                                      ? FontWeight.w700
                                      : FontWeight.w100),
                            ),
                          ),
                        ),
                      ),
                    );
                  })),
        ],
      )),
    );
  }
}
