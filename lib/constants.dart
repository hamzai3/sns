import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sns/Subscribe.dart';
import 'package:sns/allSongs.dart';
import 'package:sns/home.dart';
import 'package:sns/login.dart';
import 'package:sns/myPlayList.dart';
import 'package:sns/static.dart';
import 'SamplePlay.dart';

import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart' as con;

class Constants {
  fontFamily({type = "regular"}) {
    return type == 'regular' ? 'Poppins-Regular' : 'Pacifico';
  }

  btnGradient() {
    return LinearGradient(
        begin: Alignment.topCenter,
        end: const Alignment(0, 5),
        colors: [
          Color(0xff333333),
          Color(0xff000000),
        ]);
  }

  getPLayerSnackbar(context) {
    return player != null && player!.duration != null
        ? Container(
            width: deviceWidth(context) * 0.9,
            margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 50),
            height: 85,
            decoration: BoxDecoration(
                // gradient: LinearGradient(
                //     begin: Alignment.topLeft,
                //     end: const Alignment(0, 5),
                //     colors:
                //       // snapshot.data?.lightMutedColor?.color ??
                //       // Colors.grey,
                //       Color(0xff252525),
                //       // snapshot.data?.mutedColor?.color ?? Colors.grey,
                //     ]),
                color: Color(0xff252525),
                borderRadius: BorderRadius.circular(20)),
            child: Padding(
              padding: const EdgeInsets.all(5),
              child: ListTile(
                contentPadding: EdgeInsets.all(5),
                leading: Stack(
                  children: [
                    CircleAvatar(
                      child: Image.network(
                        image ?? "",
                      ),
                      // backgroundImage: NetworkImage(
                      //   image ?? "",
                      // ),
                      radius: 30,
                      backgroundColor: Colors.grey,
                    ),
                    CircleAvatar(
                      child: Image.asset(
                        "assets/snack.gif",
                      ),
                      // backgroundImage: NetworkImage(
                      //   image ?? "",
                      // ),
                      radius: 30,
                      backgroundColor: Colors.transparent,
                    ),
                  ],
                ),
                onTap: () {
                  print(player!.position.toString());
                  Navigator.push(
                      context,
                      CupertinoPageRoute(
                          builder: (_) => MyPlayer(
                                index: indexx,
                                allData: allDatax,
                                maxlength: maxlengthx,
                                seekto: player!.position.inSeconds.toString(),
                              )));
                },
                title: Text(
                  name ?? "",
                  style: TextStyle(
                    color: Color(0xFF3BB8FF),
                  ),
                ),
                subtitle: Text(
                  "${(player!.duration!.inMinutes - player!.position.inMinutes).toString()}:00 Mins Remaining",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                trailing: StreamBuilder<PlayerState>(
                  stream: player!.playerStateStream,
                  builder: (context, snapshot) {
                    final playerState = snapshot.data;

                    final processingState = playerState?.processingState;

                    final playing = playerState?.playing;

                    return playing != true
                        ? IconButton(
                            icon: const Icon(Icons.play_arrow),
                            // iconSize: 64.0,
                            color: Colors.white,
                            onPressed: player!.play,
                          )
                        : IconButton(
                            icon: const Icon(Icons.pause),
                            // iconSize: 64.0,
                            color: Colors.white,
                            onPressed: player!.pause,
                          );
                  },
                ),
              ),
            ),
          )
        : Container();
  }

  getBaseUrl() {
    return 'https://cubecle.com/team/projects/soundnsoulful/app_api/';
  }

  getDrawer(context) {
    return Drawer(
      backgroundColor: backgroundColor(),
      child: Container(
        decoration: BoxDecoration(gradient: btnGradient()),
        child: SafeArea(
          child: ListView(
            children: [
              DrawerHeader(child: Image.asset("assets/sns_white.gif")),
              Divider(
                height: 0.5,
              ),
              ListTile(
                leading:
                    Icon(Icons.wb_incandescent_outlined, color: Colors.white),
                title: Text(
                  'Subliminals',
                  style: TextStyle(
                      fontSize: getFontSizeLabel(context) - 2,
                      color: Colors.white,
                      fontWeight: FontWeight.w300),
                ),
                onTap: () {
                  Navigator.push(context,
                      CupertinoPageRoute(builder: (context) => Home()));
                },
              ),
              Divider(
                height: 0.5,
              ),
              ListTile(
                leading: Icon(Icons.audiotrack_outlined, color: Colors.white),
                title: Text(
                  'Songs',
                  style: TextStyle(
                      fontSize: getFontSizeLabel(context) - 2,
                      color: Colors.white,
                      fontWeight: FontWeight.w300),
                ),
                onTap: () {
                  Navigator.push(context,
                      CupertinoPageRoute(builder: (context) => AllSongs()));
                },
              ),
              Divider(
                height: 0.5,
              ),
              ListTile(
                leading: Icon(Icons.audio_file_outlined, color: Colors.white),
                title: Text(
                  'My Playlists',
                  style: TextStyle(
                      fontSize: getFontSizeLabel(context) - 2,
                      color: Colors.white,
                      fontWeight: FontWeight.w300),
                ),
                onTap: () {
                  Navigator.push(context,
                      CupertinoPageRoute(builder: (context) => MyPlaylist()));
                },
              ),
              Divider(
                height: 0.5,
              ),
              ListTile(
                leading:
                    Icon(Icons.subscriptions_outlined, color: Colors.white),
                title: Text(
                  'Subscribe',
                  style: TextStyle(
                      fontSize: getFontSizeLabel(context) - 2,
                      color: Colors.white,
                      fontWeight: FontWeight.w300),
                ),
                onTap: () {
                  Navigator.push(context,
                      CupertinoPageRoute(builder: (context) => Subscribe()));
                },
              ),
              Divider(
                height: 0.5,
              ),
              ListTile(
                leading: Icon(Icons.short_text_sharp, color: Colors.white),
                title: Text(
                  'Instructions',
                  style: TextStyle(
                      fontSize: getFontSizeLabel(context) - 2,
                      color: Colors.white,
                      fontWeight: FontWeight.w300),
                ),
                onTap: () {
                  Navigator.push(
                      context,
                      CupertinoPageRoute(
                          builder: (context) => InAppBrowserExampleScreen(
                              url:
                                  "https://cubecle.com/team/projects/soundnsoulful/instruction-app.php")));
                },
              ),
              Divider(
                height: 0.5,
              ),
              ListTile(
                leading: Icon(Icons.settings_input_antenna_sharp,
                    color: Colors.white),
                title: Text(
                  'How It Works',
                  style: TextStyle(
                      fontSize: getFontSizeLabel(context) - 2,
                      color: Colors.white,
                      fontWeight: FontWeight.w300),
                ),
                onTap: () {
                  Navigator.push(
                      context,
                      CupertinoPageRoute(
                          builder: (context) => InAppBrowserExampleScreen(
                              url:
                                  "https://cubecle.com/team/projects/soundnsoulful/works-app.php")));
                },
              ),
              Divider(
                height: 0.5,
              ),
              ListTile(
                leading:
                    Icon(Icons.spatial_audio_off_outlined, color: Colors.white),
                title: Text(
                  'Listening Tips',
                  style: TextStyle(
                      fontSize: getFontSizeLabel(context) - 2,
                      color: Colors.white,
                      fontWeight: FontWeight.w300),
                ),
                onTap: () {
                  Navigator.push(
                      context,
                      CupertinoPageRoute(
                          builder: (context) => InAppBrowserExampleScreen(
                              url:
                                  "https://cubecle.com/team/projects/soundnsoulful/tips_app.php")));
                },
              ),
              Divider(
                height: 0.5,
              ),
              ListTile(
                leading: Icon(Icons.help_center_outlined, color: Colors.white),
                title: Text(
                  'FAQ',
                  style: TextStyle(
                      fontSize: getFontSizeLabel(context) - 2,
                      color: Colors.white,
                      fontWeight: FontWeight.w300),
                ),
                onTap: () {
                  Navigator.push(
                      context,
                      CupertinoPageRoute(
                          builder: (context) => InAppBrowserExampleScreen(
                              url:
                                  "https://cubecle.com/team/projects/soundnsoulful/faq-app.php")));
                },
              ),
              Divider(
                height: 0.5,
              ),
              ListTile(
                leading: Icon(Icons.mail_outline, color: Colors.white),
                title: Text(
                  'Contact',
                  style: TextStyle(
                      fontSize: getFontSizeLabel(context) - 2,
                      color: Colors.white,
                      fontWeight: FontWeight.w300),
                ),
                onTap: () {
                  Navigator.push(
                      context,
                      CupertinoPageRoute(
                          builder: (context) => InAppBrowserExampleScreen(
                              url:
                                  "https://cubecle.com/team/projects/soundnsoulful/contact_us_app.php")));
                },
              ),
              Divider(
                height: 0.5,
              ),
              ListTile(
                leading: Icon(Icons.handshake_outlined, color: Colors.white),
                title: Text(
                  'Disclaimer',
                  style: TextStyle(
                      fontSize: getFontSizeLabel(context) - 2,
                      color: Colors.white,
                      fontWeight: FontWeight.w300),
                ),
                onTap: () {
                  Navigator.push(
                      context,
                      CupertinoPageRoute(
                          builder: (context) => InAppBrowserExampleScreen(
                              url:
                                  "https://cubecle.com/team/projects/soundnsoulful/disclaimer_app.php")));
                },
              ),
              Divider(
                height: 0.5,
              ),
              ListTile(
                leading: Icon(Icons.padding_outlined, color: Colors.white),
                title: Text(
                  'Privacy Policy',
                  style: TextStyle(
                      fontSize: getFontSizeLabel(context) - 2,
                      color: Colors.white,
                      fontWeight: FontWeight.w300),
                ),
                onTap: () {
                  Navigator.push(
                      context,
                      CupertinoPageRoute(
                          builder: (context) => InAppBrowserExampleScreen(
                              url:
                                  "https://cubecle.com/team/projects/soundnsoulful/privacy-app.php")));
                },
              ),
              Divider(
                height: 0.5,
              ),
              ListTile(
                leading: Icon(Icons.padding_outlined, color: Colors.white),
                title: Text(
                  'Terms Of Service',
                  style: TextStyle(
                      fontSize: getFontSizeLabel(context) - 2,
                      color: Colors.white,
                      fontWeight: FontWeight.w300),
                ),
                onTap: () {
                  Navigator.push(
                      context,
                      CupertinoPageRoute(
                          builder: (context) => InAppBrowserExampleScreen(
                              url:
                                  "https://cubecle.com/team/projects/soundnsoulful/terms-of-service-app.php")));
                },
              ),
              Divider(
                height: 0.5,
              ),
              ListTile(
                leading: Icon(Icons.track_changes, color: Colors.white),
                title: Text(
                  'Intellectual Property Notice',
                  style: TextStyle(
                      fontSize: getFontSizeLabel(context) - 2,
                      color: Colors.white,
                      fontWeight: FontWeight.w300),
                ),
                onTap: () {
                  Navigator.push(
                      context,
                      CupertinoPageRoute(
                          builder: (context) => InAppBrowserExampleScreen(
                              url:
                                  "https://cubecle.com/team/projects/soundnsoulful/intellectual-property-notice-app.php")));
                },
              ),
              Divider(
                height: 0.5,
              ),
              ListTile(
                leading: Icon(Icons.settings_power_sharp, color: Colors.white),
                title: Text(
                  'Logout',
                  style: TextStyle(
                      fontSize: getFontSizeLabel(context) - 2,
                      color: Colors.white,
                      fontWeight: FontWeight.w300),
                ),
                onTap: () {
                  Navigator.push(context,
                      CupertinoPageRoute(builder: (context) => LoginPage()));
                },
              ),
              Divider(
                height: 0.5,
              ),
              GestureDetector(
                onDoubleTap: () {
                  showInSnackBar(context, "Current App Version is 1.0.1");
                },
                child: ListTile(
                  leading: Icon(Icons.upgrade, size: 20, color: Colors.white),
                  title: Text(
                    'Version 1.0.1',
                    style: TextStyle(
                        fontSize: getFontSizeLabel(context) - 3 - 2,
                        color: Colors.white,
                        fontWeight: FontWeight.w300),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  getAppBar(title) {
    return AppBar(
      automaticallyImplyLeading: true,
      backgroundColor: Colors.white,
      title: Text(
        title,
        style: TextStyle(color: primaryColor()),
      ),
      iconTheme: IconThemeData(color: Colors.black),
      leading: Builder(
        builder: (context) => // Ensure Scaffold is in context
            IconButton(
                icon: Icon(Icons.menu),
                onPressed: () => Scaffold.of(context).openDrawer()),
      ),
    );
  }

  deviceWidth(context) {
    var isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
    return isPortrait
        ? MediaQuery.of(context).size.width
        : MediaQuery.of(context).size.height;
  }

  primaryColor() {
    return const Color(0xff3b3939);
  }

  verseNumber() {
    return const Color(0xff496F51);
  }

  redColor() {
    return Color(0xC4F04444);
  }

  secondaryColor() {
    return const Color(0xffF42B5B);
  }

  tertiaryColor() {
    return const Color(0xffB9B9B9);
  }

  capitalize(str) {
    return "${str[0].toUpperCase()}${str.substring(1)}";
  }

  whiteColor() {
    return const Color(0xffffffff);
  }

  blackColor({opc = 1.0}) {
    return const Color(0xff0B0C0E).withOpacity(opc);
  }

  backgroundColor() {
    return const Color(0xffEEEEEE);
  }

  getFontSizeMedium(context) {
    return deviceHeight(context) * 0.018;
  }

  getFontSize(context) {
    return deviceHeight(context) * 0.018;
  }

  neuroMorphicDecor() {
    return con.BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          con.BoxShadow(
            blurRadius: 25.0,
            offset: Offset(-28, -20),
            color: Color.fromARGB(255, 241, 242, 243),
            inset: true,
          ),
          con.BoxShadow(
            blurRadius: 1.0,
            inset: true,
            offset: Offset(2, 4),
            color: Color(0xffa7a9af),
          )
        ]);
  }

  deviceHeight(context) {
    var isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
    return isPortrait
        ? MediaQuery.of(context).size.height
        : MediaQuery.of(context).size.width;
  }

  getFontSizeSmall(context) {
    return deviceHeight(context) * 0.020;
  }

  getFontSizeLabel(context) {
    return deviceHeight(context) * 0.021;
  }

  getFontSizeLarge(context) {
    return deviceHeight(context) * 0.040;
  }

  getColor(str) {
    if (str == 'green') {
      return Colors.green;
    } else if (str == 'red') {
      return Colors.red;
    } else if (str == 'yellow') {
      return Colors.yellow;
    } else if (str == 'blue') {
      return Colors.blue;
    } else if (str == 'orange') {
      return Colors.orange;
    } else if (str == 'pink') {
      return Colors.pink;
    }
  }

  getDivider(height) {
    return Divider(
      height: height,
      color: Colors.transparent,
    );
  }

  showInSnackBar(context, String value) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(value),
        duration: Duration(seconds: 3),
      ),
    );
  }

  Future<bool> setshared(String name, String value) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString(name, value);
    return true;
  }

  Future<String> getshared(String skey) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString(skey).toString();
  }

  Future clearShared() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.clear();
  }
}
