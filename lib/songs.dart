// import 'dart:convert';
// import 'dart:io';

// import 'package:auto_size_text/auto_size_text.dart';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:dio/dio.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
// import 'package:sns/login.dart';
// import 'package:syncfusion_flutter_sliders/sliders.dart';
// import 'NoInternet.dart';
// import 'bottomNav.dart';
// import 'constants.dart';
// import 'register.dart';
// import 'package:intro_slider/intro_slider.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:just_audio/just_audio.dart';

// class Songs extends StatefulWidget {
//   final cat_id, song_id;
//   Songs({this.cat_id, this.song_id});
//   @override
//   _SongsState createState() => _SongsState();
// }

// class _SongsState extends State<Songs> {
//   Constants c = Constants();
//   final _formKey = GlobalKey<FormState>();
//   TextEditingController email = TextEditingController();
//   TextEditingController pwd = TextEditingController();
//   final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
//   bool _isSubmitted = false;
//   // Response? form_response;
//   List<String> topics = [];
//   late AudioPlayer player;
//   bool _ready = false;

//   late List data_Songs, temp_data = [], _playList;
//   bool hide_password = true;
//   void showInSnackBar(String value) {
//     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//       content: AutoSizeText(value,
//           textAlign: TextAlign.center,
//           style: TextStyle(
//               fontSize: c.getFontSizeLabel(context),
//               fontFamily: c.fontFamily(),
//               color: Colors.white)),
//       duration: Duration(seconds: 2),
//       behavior: SnackBarBehavior.floating,
//       elevation: 5.0,
//     ));
//   }

//   void showModalBottomSheetCupetino(msg) async {
//     await showCupertinoModalBottomSheet(
//       useRootNavigator: true,
//       context: context,
//       bounce: true,
//       isDismissible: true,
//       // backgroundColor: const Color(0xff6B5A00),
//       builder: (context) => Material(
//         // color: const Color(0xff6B5A00),
//         child: ListView(
//           shrinkWrap: true,
//           // mainAxisSize: MainAxisSize.min,
//           children: <Widget>[
//             Container(
//               margin: const EdgeInsets.all(5.0),
//               padding: const EdgeInsets.all(5.0),
//               decoration: const BoxDecoration(
//                 border: Border(
//                   bottom: BorderSide(
//                     color: Colors.white,
//                     width: 1.0,
//                   ),
//                 ),
//               ),
//               child: AutoSizeText(
//                 "Affirmation",
//                 textAlign: TextAlign.center,
//                 style: TextStyle(
//                     fontFamily: c.fontFamily(type: "pacifico"),
//                     fontSize: c.getFontSizeLarge(context) - 15,
//                     color: c.getColor("grey")),
//               ),
//             ),
//             Padding(
//               padding: EdgeInsets.all(10),
//               child: Text(msg),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   loop() {
//     setState(() {});
//     Future.delayed(Duration(milliseconds: 900), () {
//       player.playing ? loop() : doop();
//     });
//   }

//   doop() {}
//   List<ContentConfig> listContentConfig = [];
//   var close = 0;
//   Future<bool> _exitApp(BuildContext context) async {
//     player.stop();
//     player.dispose();
//     Navigator.of(context).pop();
//     return Future.value(false);
//   }

//   Response? form_response;

//   Songs(token) async {
//     print("Token i have is $token");
//     try {
//       var dio = Dio();
//       final result = await InternetAddress.lookup('google.com');
//       if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
//         FormData formData = new FormData.fromMap({
//           "fetch_songs_by_category": "fetch_songs_by_category@sns",
//           "token": token,
//           "cat_id": widget.cat_id,
//         });
//         try {
//           form_response = await dio.post(
//             c.getBaseUrl() + 'fetch_songs_by_category.php',
//             data: formData,
//           );
//         } on DioError catch (e) {
//           print(e.message);
//         }
//         decodeSongs(form_response.toString());
//         c.setshared("Songs", form_response.toString());
//       } else {
//         Navigator.pushAndRemoveUntil(
//             context,
//             MaterialPageRoute(builder: (context) => NoInternet()),
//             ModalRoute.withName('/NoInternet'));
//       }
//     } catch (e, s) {
//       print("Error " + e.toString() + " Stack " + s.toString());
//     }
//   }

//   decodeSongs(js) {
//     try {
//       print("Songs $no_posts are $js");

//       var jsonval = json.decode(js);
//       data_Songs = jsonval["response"][0]['song_list'];

//       if (jsonval["response"][0]['status'] == "failed") {
//         setState(() {
//           isLoading = false;
//           no_posts = true;
//         });
//       } else if (jsonval["response"][0]['status'] == "success") {
//         setState(() {
//           isLoading = false;
//           songData.add(data_Songs[0]);
//           initPlayer();
//         });
//       }
//     } catch (e) {
//       setState(() {
//         isLoading = false;
//         no_posts = true;
//       });
//     }
//   }

//   playList(token, id) async {
//     print("Token i have is $token");
//     try {
//       var dio = Dio();
//       // final result = await InternetAddress.lookup('google.com');
//       // if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
//       FormData formData = new FormData.fromMap({
//         "fetch_playlist": "fetch_playlist@sns",
//         "token": token,
//         "id": id,
//       });
//       try {
//         form_response = await dio.post(
//           c.getBaseUrl() + 'playlist_fetch.php',
//           data: formData,
//         );
//       } on DioError catch (e) {
//         print(e.message);
//       }
//       decodePlay(form_response.toString());
//       c.setshared("playlist", form_response.toString());
//       // } else {
//       //   Navigator.pushAndRemoveUntil(
//       //       context,
//       //       MaterialPageRoute(builder: (context) => NoInternet()),
//       //       ModalRoute.withName('/NoInternet'));
//       // }
//     } catch (e, s) {
//       print("Error " + e.toString() + " Stack " + s.toString());
//     }
//   }

//   savePlayList(token, id, name) async {
//     setState(() {
//       pwd.text = '';
//     });
//     try {
//       var dio = Dio();
//       // final result = await InternetAddress.lookup('google.com');
//       // if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
//       FormData formData = new FormData.fromMap({
//         "create_playlist": "create_playlist@sns",
//         "token": token,
//         "user_id": id,
//         "name": name,
//       });
//       try {
//         form_response = await dio.post(
//           c.getBaseUrl() + 'playlist_create_api.php',
//           data: formData,
//         );
//       } on DioError catch (e) {
//         print(e.message);
//       }

//       print("formData $formData");
//       print("form_response $form_response");
//       // decodePlay(form_response.toString());

//       c.showInSnackBar(context, "Saved");
//       playList(token, id);
//       Future.delayed(Duration(milliseconds: 200), () {
//         showAlert(context);
//       });
//       // } else {
//       //   Navigator.pushAndRemoveUntil(
//       //       context,
//       //       MaterialPageRoute(builder: (context) => NoInternet()),
//       //       ModalRoute.withName('/NoInternet'));
//       // }
//     } catch (e, s) {
//       print("Error " + e.toString() + " Stack " + s.toString());
//     }
//   }

//   addSongToPlaylist(token, id, name) async {
//     try {
//       var dio = Dio();
//       // final result = await InternetAddress.lookup('google.com');
//       // if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
//       FormData formData = new FormData.fromMap({
//         "add_songs_playlist": "add_songs_playlist@sns",
//         "token": token,
//         "user_id": id,
//         "song_id": songData[0]['id'],
//         "id": name,
//       });
//       try {
//         form_response = await dio.post(
//           c.getBaseUrl() + 'playlist_create_api.php',
//           data: formData,
//         );
//       } on DioError catch (e) {
//         print(e.message);
//       }

//       print("formData $formData");
//       print("form_response $form_response");
//       // decodePlay(form_response.toString());

//       c.showInSnackBar(context, "Saved");
//       playList(token, id);
//       // } else {
//       //   Navigator.pushAndRemoveUntil(
//       //       context,
//       //       MaterialPageRoute(builder: (context) => NoInternet()),
//       //       ModalRoute.withName('/NoInternet'));
//       // }
//     } catch (e, s) {
//       print("Error " + e.toString() + " Stack " + s.toString());
//     }
//   }

//   decodePlay(js) {
//     print("PLayslist $no_posts are $js");
//     setState(() {
//       if (js != "") {
//         try {
//           var jsonval = json.decode(js);
//           _playList = jsonval["response"][0]['playlist'];
//           if (jsonval["response"][0]['status'] == "failed") {
//             setState(() {
//               isLoadingPlay = false;
//               no_postsPlay = true;
//             });
//           } else if (jsonval["response"][0]['status'] == "success") {
//             setState(() {
//               isLoadingPlay = false;
//             });
//           }
//         } catch (c) {
//           setState(() {
//             isLoadingPlay = false;
//             no_postsPlay = true;
//           });
//         }
//       } else {
//         setState(() {
//           isLoadingPlay = false;
//           no_postsPlay = true;
//         });
//       }
//       print("PLayslist  again $no_posts are $isLoadingPlay");
//     });
//   }

//   var user_id, alias;
//   int selectedTopics = 0;
//   bool isLoading = true,
//       no_posts = false,
//       isLoadingPlay = true,
//       no_postsPlay = false;
//   showAlert(BuildContext context) {
//     // print(no_postsPlay);
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return StatefulBuilder(builder: (context, setState) {
//           return AlertDialog(
//             title: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(
//                   "All to Playlist",
//                   style: TextStyle(
//                       color: c.primaryColor(), fontWeight: FontWeight.w800),
//                 ),
//                 GestureDetector(
//                     onTap: () {
//                       Navigator.pop(context);
//                     },
//                     child: Icon(
//                       Icons.close,
//                       color: Colors.grey,
//                     ))
//               ],
//             ),
//             content: TextFormField(
//               keyboardType: TextInputType.text,
//               // obscureText: hide_password,
//               controller: pwd,
//               style: TextStyle(
//                   fontSize: c.getFontSize(context), color: c.primaryColor()),
//               decoration: InputDecoration(
//                 hintText: "Enter Playlist Name",
//                 fillColor: c.primaryColor(),
//                 filled: false, // dont forget this line
//                 suffixIcon: GestureDetector(
//                     onTap: () {
//                       c.getshared("token").then((token) {
//                         if (token != '' &&
//                             token != null &&
//                             token != ' ' &&
//                             token != 'null') {
//                           c.getshared("user_id").then((user_id) {
//                             // print("CatVal $value");
//                             if (user_id != '' &&
//                                 user_id != null &&
//                                 user_id != ' ' &&
//                                 user_id != 'null') {
//                               Navigator.of(context).pop("cancel");
//                               savePlayList(token, user_id, pwd.text);
//                             }
//                           });
//                         }
//                       });
//                     },
//                     child: Icon(Icons.save)),
//                 hintStyle: TextStyle(
//                     fontSize: c.getFontSize(context), color: c.primaryColor()),
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(20),
//                   borderSide: BorderSide(
//                     style: BorderStyle.none,
//                   ),
//                 ),
//                 contentPadding: EdgeInsets.all(16),
//               ),
//             ),
//             actions: [
//               // Text("$isLoadingPlay $no_posts"),
//               isLoadingPlay
//                   ? CircularProgressIndicator()
//                   : no_postsPlay
//                       ? Text("There are no playlist(s)")
//                       : SizedBox(
//                           height: 300,
//                           width: 400,
//                           child: ListView.builder(
//                               shrinkWrap: true,
//                               itemCount: _playList.length,
//                               itemBuilder: (BuildContext context, int i) {
//                                 return ListTile(
//                                   onTap: () {
//                                     c.getshared("token").then((token) {
//                                       if (token != '' &&
//                                           token != null &&
//                                           token != ' ' &&
//                                           token != 'null') {
//                                         c.getshared("user_id").then((user_id) {
//                                           // print("CatVal $value");
//                                           if (user_id != '' &&
//                                               user_id != null &&
//                                               user_id != ' ' &&
//                                               user_id != 'null') {
//                                             Navigator.of(context).pop("cancel");
//                                             addSongToPlaylist(token, user_id,
//                                                 _playList[i]['playlist_id']);
//                                           }
//                                         });
//                                       }
//                                     });
//                                   },
//                                   leading: Icon(Icons.star),
//                                   title: Row(
//                                     children: [
//                                       Center(
//                                         child: Text(
//                                           c.capitalize(_playList[i]['name']),
//                                           style: TextStyle(
//                                             fontSize:
//                                                 c.getFontSizeLabel(context),
//                                             fontWeight: FontWeight.w800,
//                                           ),
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                   trailing: Icon(Icons.navigate_next),
//                                 );
//                               }),
//                         )
//             ],
//           );
//         });
//       },
//     );
//   }

//   int total_duration = 0;
//   void initState() {
//     super.initState();
//     player = AudioPlayer();
//     player.setLoopMode(LoopMode.one);
//     c.getshared("token").then((token) {
//       if (token != '' && token != null && token != ' ' && token != 'null') {
//         c.getshared("playlist").then((playlist) {
//           // print("CatVal $value");
//           if (playlist != '' &&
//               playlist != null &&
//               playlist != ' ' &&
//               playlist != 'null') {
//             decodePlay(playlist);
//           }
//           c.getshared("user_id").then((user_id) {
//             // print("CatVal $value");
//             if (user_id != '' &&
//                 user_id != null &&
//                 user_id != ' ' &&
//                 user_id != 'null') {
//               playList(token, user_id);
//             }
//           });
//         });
//         c.getshared("Songs").then((value) {
//           // print("CatVal $value");
//           if (value != '' && value != null && value != ' ' && value != 'null') {
//             decodeSongs(value);
//           }
//           Songs(token);
//         });
//       } else {
//         Navigator.push(
//             context, MaterialPageRoute(builder: (context) => LoginPage()));
//       }
//       initPlayer();
//     });
//   }

//   initPlayer() {
//     player.setUrl(data_Songs[0]['audio']).then((_) {
//       if (mounted) {
//         setState(() {
//           _ready = true;
//           total_duration = Duration(seconds: 100).inMinutes;
//           // isLoading = false;
//         });
//       }
//     });
//     print("Duration for audio");
//     player.bufferedPositionStream.listen((event) {
//       print(event.inMinutes.toString() + "Okay");
//     });
//     player.durationStream.listen((event) {
//       print("PLayback");
//       print(event!.inSeconds.toString());
//     }, onError: (Object e, StackTrace stackTrace) {
//       print('A stream error occurred: $e');
//     });
//   }

//   int currentPlay = 0;
//   List songData = [];
//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: () => _exitApp(context),
//       child: Scaffold(
//         key: _scaffoldKey,
//         appBar: c.getAppBar("Sound N Soulful"),
//         drawer: c.getDrawer(context),
//         backgroundColor: Colors.white,
//         body: SafeArea(
//             child: isLoading
//                 ? Container()
//                 : no_posts
//                     ? const Center(
//                         child:
//                             Text("There are no songs added in this category"),
//                       )
//                     : ListView(
//                         shrinkWrap: true,
//                         physics: NeverScrollableScrollPhysics(),
//                         children: [
//                           SizedBox(
//                             height: c.deviceHeight(context) * 0.80,
//                             child: Stack(
//                               children: [
//                                 Column(
//                                   children: [
//                                     Row(
//                                       children: [
//                                         Padding(
//                                           padding: const EdgeInsets.fromLTRB(
//                                               10, 12, 10, 0),
//                                           child: AutoSizeText(
//                                             "Songs",
//                                             textAlign: TextAlign.start,
//                                             style: TextStyle(
//                                                 fontSize: c.getFontSizeLabel(
//                                                         context) +
//                                                     8,
//                                                 fontWeight: FontWeight.w800,
//                                                 color: c.getColor("grey")),
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                     c.getDivider(10.0),
//                                     Center(
//                                       child: ClipRRect(
//                                         borderRadius:
//                                             BorderRadius.circular(2.0),
//                                         child: ClipRRect(
//                                           borderRadius:
//                                               BorderRadius.circular(8.0),
//                                           child: CachedNetworkImage(
//                                             width: c.deviceWidth(context) * 0.5,
//                                             height:
//                                                 c.deviceHeight(context) * 0.3,
//                                             imageUrl: songData[0]['base_url'] +
//                                                 "" +
//                                                 songData[0]['image'],
//                                             placeholder: (context, url) =>
//                                                 const Padding(
//                                               padding: EdgeInsets.all(58.0),
//                                               child:
//                                                   CircularProgressIndicator(),
//                                             ),
//                                             fit: BoxFit.cover,
//                                             errorWidget:
//                                                 (context, url, error) =>
//                                                     const Icon(
//                                                         Icons.circle_outlined),
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                     Row(
//                                       children: [
//                                         Expanded(
//                                           child: Padding(
//                                             padding: const EdgeInsets.fromLTRB(
//                                                 10, 12, 10, 0),
//                                             child: AutoSizeText(
//                                               data_Songs[0]['name'],
//                                               textAlign: TextAlign.start,
//                                               style: TextStyle(
//                                                   fontSize: c.getFontSizeLabel(
//                                                       context),
//                                                   // fontWeight: FontWeight.w800,
//                                                   color: c.getColor("grey")),
//                                             ),
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                     Center(
//                                       child: SizedBox(
//                                         height: c.deviceHeight(context) * 0.3,
//                                         child: Container(
//                                           color: Colors.white,
//                                           child: ListView.builder(
//                                               shrinkWrap: true,
//                                               itemCount: data_Songs.length,
//                                               itemBuilder:
//                                                   (BuildContext context,
//                                                       int i) {
//                                                 return Container(
//                                                   decoration: BoxDecoration(
//                                                     border: Border(
//                                                       bottom: i == currentPlay
//                                                           ? const BorderSide(
//                                                               color:
//                                                                   Colors.black,
//                                                               width: 0.2,
//                                                             )
//                                                           : const BorderSide(
//                                                               color:
//                                                                   Colors.grey,
//                                                               width: 0.2,
//                                                             ),
//                                                     ),
//                                                   ),
//                                                   child: ListTile(
//                                                     contentPadding:
//                                                         EdgeInsets.all(8),
//                                                     leading: ClipRRect(
//                                                       borderRadius:
//                                                           BorderRadius.circular(
//                                                               2.0),
//                                                       child: ClipRRect(
//                                                         borderRadius:
//                                                             BorderRadius
//                                                                 .circular(8.0),
//                                                         child:
//                                                             CachedNetworkImage(
//                                                           width: c.deviceWidth(
//                                                                   context) *
//                                                               0.2,
//                                                           height:
//                                                               c.deviceHeight(
//                                                                       context) *
//                                                                   0.1,
//                                                           imageUrl: data_Songs[
//                                                                       i]
//                                                                   ['base_url'] +
//                                                               "" +
//                                                               data_Songs[i]
//                                                                   ['image'],
//                                                           placeholder:
//                                                               (context, url) =>
//                                                                   const Padding(
//                                                             padding:
//                                                                 EdgeInsets.all(
//                                                                     58.0),
//                                                             child:
//                                                                 CircularProgressIndicator(),
//                                                           ),
//                                                           fit: BoxFit.cover,
//                                                           errorWidget: (context,
//                                                                   url, error) =>
//                                                               const Icon(Icons
//                                                                   .circle_outlined),
//                                                         ),
//                                                       ),
//                                                     ),
//                                                     title: Row(
//                                                       children: [
//                                                         Expanded(
//                                                           child: AutoSizeText(
//                                                             c.capitalize(
//                                                                 data_Songs[i]
//                                                                     ['name']),
//                                                             textAlign:
//                                                                 TextAlign.left,
//                                                             style: TextStyle(
//                                                                 fontFamily: c
//                                                                     .fontFamily(),
//                                                                 color:
//                                                                     c.getColor(
//                                                                         "grey")),
//                                                           ),
//                                                         ),
//                                                       ],
//                                                     ),
//                                                     trailing: Padding(
//                                                       padding:
//                                                           const EdgeInsets.all(
//                                                               8.0),
//                                                       child: Icon(Icons
//                                                           .arrow_forward_ios),
//                                                     ),
//                                                   ),
//                                                 );
//                                               }),
//                                         ),
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                                 Positioned(
//                                     bottom: 0,
//                                     child: Container(
//                                       color: Colors.grey[50],
//                                       child: SizedBox(
//                                         width: c.deviceWidth(context),
//                                         child: Column(
//                                           children: [
//                                             Row(
//                                               mainAxisAlignment:
//                                                   MainAxisAlignment
//                                                       .spaceBetween,
//                                               children: [
//                                                 GestureDetector(
//                                                   onTap: () {
//                                                     showModalBottomSheetCupetino(
//                                                         songData[0]
//                                                             ['affirmation']);
//                                                   },
//                                                   child: Padding(
//                                                     padding:
//                                                         const EdgeInsets.all(
//                                                             8.0),
//                                                     child: Icon(
//                                                       Icons.list_outlined,
//                                                       size: 40,
//                                                     ),
//                                                   ),
//                                                 ),
//                                                 Row(
//                                                   children: [
//                                                     GestureDetector(
//                                                       onTap: () {
//                                                         print(
//                                                             "Going $currentPlay");
//                                                         if (data_Songs.length >
//                                                             0) {
//                                                           if (currentPlay > 0) {
//                                                             setState(() {
//                                                               currentPlay =
//                                                                   currentPlay -
//                                                                       1;
//                                                               songData = [];
//                                                               if (data_Songs[
//                                                                       currentPlay] !=
//                                                                   null) {
//                                                                 songData.add(
//                                                                     data_Songs[
//                                                                         currentPlay]);
//                                                                 initPlayer();
//                                                               }
//                                                             });
//                                                           }
//                                                         }
//                                                       },
//                                                       child: const Icon(
//                                                         Icons
//                                                             .keyboard_double_arrow_left,
//                                                         size: 40,
//                                                       ),
//                                                     ),
//                                                     GestureDetector(
//                                                       onTap: () {
//                                                         loop();
//                                                         !player.playing
//                                                             ? player.play()
//                                                             : player.pause();
//                                                       },
//                                                       child: !player.playing
//                                                           ? const Icon(
//                                                               Icons.play_arrow,
//                                                               size: 60,
//                                                             )
//                                                           : const Icon(
//                                                               Icons.pause,
//                                                               size: 60,
//                                                             ),
//                                                     ),
//                                                     GestureDetector(
//                                                       onTap: () {
//                                                         print(
//                                                             "Going $currentPlay");
//                                                         print(
//                                                             data_Songs.length);
//                                                         if (data_Songs.length >
//                                                             0) {
//                                                           if (currentPlay >=
//                                                               0) {
//                                                             setState(() {
//                                                               currentPlay =
//                                                                   currentPlay +
//                                                                       1;
//                                                               songData = [];
//                                                               if (data_Songs[
//                                                                       currentPlay] !=
//                                                                   null) {
//                                                                 songData.add(
//                                                                     data_Songs[
//                                                                         currentPlay]);
//                                                                 initPlayer();
//                                                               }
//                                                             });
//                                                           }
//                                                         }
//                                                       },
//                                                       child: const Icon(
//                                                         Icons
//                                                             .keyboard_double_arrow_right,
//                                                         size: 40,
//                                                       ),
//                                                     ),
//                                                   ],
//                                                 ),
//                                                 GestureDetector(
//                                                   onTap: () {
//                                                     showAlert(context);
//                                                   },
//                                                   child: Padding(
//                                                     padding:
//                                                         const EdgeInsets.all(
//                                                             8.0),
//                                                     child: Icon(
//                                                       Icons.playlist_add,
//                                                       size: 40,
//                                                     ),
//                                                   ),
//                                                 ),
//                                               ],
//                                             ),
//                                             Row(
//                                               children: [
//                                                 Expanded(
//                                                   child: SfSlider(
//                                                     min: 0.0,
//                                                     activeColor:
//                                                         c.primaryColor(),
//                                                     max: double.parse(player
//                                                         .duration!.inSeconds
//                                                         .toString()),
//                                                     value: player
//                                                         .position.inSeconds,
//                                                     interval: 0.01,
//                                                     enableTooltip: true,
//                                                     minorTicksPerInterval: 1,
//                                                     onChanged:
//                                                         (dynamic value) async {
//                                                       // setState(() {
//                                                       //   player.seek(Duration(
//                                                       //       minutes: int.parse(
//                                                       //           double.parse(value.toString())
//                                                       //               .ceil()
//                                                       //               .toString())));
//                                                       // });
//                                                     },
//                                                   ),
//                                                 ),
//                                               ],
//                                             ),
//                                             Padding(
//                                               padding:
//                                                   const EdgeInsets.fromLTRB(
//                                                       18.0, 0, 18.0, 0),
//                                               child: Row(
//                                                 mainAxisSize: MainAxisSize.max,
//                                                 mainAxisAlignment:
//                                                     MainAxisAlignment
//                                                         .spaceBetween,
//                                                 children: [
//                                                   Text(
//                                                       "00:" +
//                                                           player.position
//                                                               .inSeconds
//                                                               .toString(),
//                                                       style: TextStyle(
//                                                           fontSize: c
//                                                               .getFontSizeSmall(
//                                                                   context),
//                                                           fontWeight:
//                                                               FontWeight.w800,
//                                                           color: c.getColor(
//                                                               "grey"))),
//                                                   Text(
//                                                       "$total_duration".toString() +
//                                                           ":00",
//                                                       style: TextStyle(
//                                                           fontSize: c
//                                                               .getFontSizeSmall(
//                                                                   context),
//                                                           fontWeight:
//                                                               FontWeight.w800,
//                                                           color: c.getColor(
//                                                               "grey")))
//                                                 ],
//                                               ),
//                                             ),
//                                           ],
//                                         ),
//                                       ),
//                                     )),
//                               ],
//                             ),
//                           )
//                         ],
//                       )),
//         // bottomNavigationBar: BottomNav(currentPage: 0),
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     player.stop();
//     player.dispose();
//     super.dispose();
//   }
// }
