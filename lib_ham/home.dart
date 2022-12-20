import 'dart:convert';
import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sns/category.dart';
import 'package:sns/login.dart';
import 'NoInternet.dart';
import 'bottomNav.dart';
import 'constants.dart';
import 'register.dart';
import 'package:intro_slider/intro_slider.dart';
import 'package:path_provider/path_provider.dart';
import 'package:carousel_slider/carousel_slider.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
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

  Subliminals(token) async {
    print("Token i have is $token");
    try {
      var dio = Dio();
      // final result = await InternetAddress.lookup('google.com');
      // if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      FormData formData = new FormData.fromMap({
        "sublimal_list": "sublimal_list@sns",
        "token": token,
      });
      try {
        form_response = await dio.post(
          c.getBaseUrl() + 'sublimal_list_api.php',
          data: formData,
        );
      } on DioError catch (e) {
        print(e.message);
      }
      decodeSubliminals(form_response.toString());
      c.setshared("Subliminals", form_response.toString());
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

  late List data_Subliminals, temp_data = [];
  late List testimonial;
  decodeSubliminals(js) {
    print("Subliminals are $js");
    setState(() {
      var jsonval = json.decode(js);
      data_Subliminals = jsonval["response"][0]['sublimal_list'];
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

  decodeTestimonial(js) {
    print("testimonial are $js");
    setState(() {
      var jsonval = json.decode(js);
      testimonial = (jsonval["response"][0]['testimonial_list']);

      print("\n\ntestimonial lisr are $testimonial");
      if (jsonval["response"][0]['status'] == "failed") {
        setState(() {
          isLoadingTesti = false;
          no_postsTesti = true;
        });
      } else if (jsonval["response"][0]['status'] == "success") {
        setState(() {
          isLoadingTesti = false;
        });
      }
    });
  }

  var user_id, alias;
  int selectedTopics = 0;
  bool isLoading = true, no_posts = false;
  bool isLoadingTesti = true, no_postsTesti = false;

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

  void initState() {
    super.initState();
    c.getshared("token").then((token) {
      if (token != '' && token != null && token != ' ' && token != 'null') {
        c.getshared("Subliminals").then((value) {
          // print("CatVal $value");
          if (value != '' && value != null && value != ' ' && value != 'null') {
            decodeSubliminals(value);
          }
          Subliminals(token);
          allTestimonials(token);
        });
        AllSongs(token);
      } else {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => LoginPage()));
      }
    });
  }

  allTestimonials(token) async {
    print("Token i have is $token");
    try {
      var dio = Dio();
      // final result = await InternetAddress.lookup('google.com');
      // if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      FormData formData = new FormData.fromMap({
        "testimonial": "testimonial@sns",
        "token": token,
      });
      try {
        form_response = await dio.post(
          c.getBaseUrl() + 'testimonial_fetch_api.php',
          data: formData,
        );
      } on DioError catch (e) {
        print(e.message);
      }
      decodeTestimonial(form_response.toString());
      c.setshared("testimonial_list", form_response.toString());
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: c.getAppBar("Home"),
      drawer: c.getDrawer(context),
      backgroundColor: Colors.white,
      body: WillPopScope(
        onWillPop: () => _exitApp(context),
        child: SafeArea(
            child: ListView(
          shrinkWrap: true,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 12, 10, 0),
              child: AutoSizeText(
                "Testimonials",
                textAlign: TextAlign.start,
                style: TextStyle(
                    fontSize: c.getFontSizeLabel(context) + 8,
                    fontWeight: FontWeight.w800,
                    color: c.getColor("grey")),
              ),
            ),
            c.getDivider(1.0),
            isLoadingTesti
                ? Container()
                : Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: SizedBox(
                      height: c.deviceHeight(context) * 0.27,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20), // Image border
                        child: Container(
                          // width: c.deviceWidth(context) * 0.96,
                          color: Colors.black,
                          child: CarouselSlider.builder(
                            options: CarouselOptions(
                              aspectRatio: 16 / 9,
                              viewportFraction: 1,
                              initialPage: 0,
                              enableInfiniteScroll: false,
                              reverse: false,
                              autoPlay: true,
                              autoPlayInterval: Duration(seconds: 3),
                              autoPlayAnimationDuration:
                                  Duration(milliseconds: 100),
                              autoPlayCurve: Curves.fastOutSlowIn,
                              enlargeCenterPage: false,
                              scrollDirection: Axis.horizontal,
                              height: MediaQuery.of(context).orientation ==
                                      Orientation.portrait
                                  ? MediaQuery.of(context).size.height * 0.40
                                  : MediaQuery.of(context).size.height * 0.75,
                            ),
                            itemCount: testimonial.length,
                            itemBuilder: (BuildContext context, int i,
                                    int pageViewIndex) =>
                                InkWell(
                              onTap: () {
                                Future.delayed(Duration(seconds: 1), () {});
                              },
                              child: SizedBox.fromSize(
                                  size: Size.fromRadius(c.deviceWidth(context) *
                                      0.9), // Image radius
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.all(20.0),
                                          child: Text.rich(
                                            textAlign: TextAlign.center,
                                            TextSpan(
                                              children: [
                                                TextSpan(
                                                  text: testimonial[i]
                                                          ['description']
                                                      .toString(),
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize:
                                                          c.getFontSizeLabel(
                                                                  context) -
                                                              2),
                                                ),
                                                TextSpan(
                                                  text: "\n~" +
                                                      testimonial[i]
                                                              ['user_name']
                                                          .toString(),
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.white,
                                                      fontSize:
                                                          c.getFontSizeLarge(
                                                                  context) -
                                                              12),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  )),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 12, 10, 0),
              child: AutoSizeText(
                "Subliminals",
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
                      ? const Center(
                          child: Text("No Subliminal Found"),
                        )
                      : Container(
                          padding: EdgeInsets.all(20),
                          color: Colors.white,
                          child: GridView.builder(
                              shrinkWrap: true,
                              itemCount: data_Subliminals.length,
                              physics: NeverScrollableScrollPhysics(),
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                childAspectRatio: 12 / 19,
                                crossAxisCount: 3,
                                crossAxisSpacing: 10,
                                mainAxisSpacing: 10,
                              ),
                              itemBuilder: (BuildContext context, int i) {
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        CupertinoPageRoute(
                                            builder: (_) => Category(
                                                sublimals: data_Subliminals[i]
                                                    ['id'],
                                                name: data_Subliminals[i]
                                                    ['name'])));
                                  },
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      SizedBox(
                                          child: Padding(
                                        padding: const EdgeInsets.all(2.0),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(2.0),
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                            child: CachedNetworkImage(
                                              width:
                                                  c.deviceWidth(context) * 0.28,
                                              height:
                                                  c.deviceWidth(context) * 0.28,
                                              imageUrl: data_Subliminals[i]
                                                      ['base_url'] +
                                                  "" +
                                                  data_Subliminals[i]
                                                      ['image_path'],
                                              placeholder: (context, url) =>
                                                  const Padding(
                                                padding: EdgeInsets.all(58.0),
                                                child:
                                                    CircularProgressIndicator(),
                                              ),
                                              fit: BoxFit.cover,
                                              errorWidget: (context, url,
                                                      error) =>
                                                  const Icon(
                                                      Icons.circle_outlined),
                                            ),
                                          ),
                                        ),
                                      )),
                                      AutoSizeText(
                                        data_Subliminals[i]['name'],
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize:
                                                c.getFontSizeLabel(context) - 4,
                                            // fontWeight: FontWeight.w800,
                                            color: c.getColor("grey")),
                                      ),
                                    ],
                                  ),
                                );
                              }),
                        ),
            )
          ],
        )),
      ),
      // bottomNavigationBar: BottomNav(currentPage: 0),
    );
  }
}
