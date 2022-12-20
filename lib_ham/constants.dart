import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:quran_app/annotations.dart';
// import 'package:quran_app/bookmark.dart';
// import 'package:quran_app/home.dart';
// import 'package:quran_app/profile.dart';
// import 'package:quran_app/settings.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sns/allSongs.dart';
import 'package:sns/home.dart';
import 'package:sns/login.dart';
import 'package:sns/myPlayList.dart';
import 'package:sns/static.dart';

class Constants {
  fontFamily({type = "regular"}) {
    return type == 'regular' ? 'Poppins-Regular' : 'Pacifico';
  }

  getBaseUrl() {
    return 'https://sns.alliedtechnologies.co/app_api/';
  }

  getDrawer(context) {
    return Drawer(
      backgroundColor: backgroundColor(),
      child: SafeArea(
        child: ListView(
          children: [
            DrawerHeader(child: Image.asset("assets/logo.png")),
            Divider(
              height: 0.5,
            ),
            ListTile(
              leading: Icon(Icons.wb_incandescent_outlined),
              title: Text(
                'Subliminals',
                style: TextStyle(
                    fontSize: getFontSizeLabel(context),
                    color: primaryColor(),
                    fontWeight: FontWeight.w300),
              ),
              onTap: () {
                Navigator.push(
                    context, CupertinoPageRoute(builder: (context) => Home()));
              },
            ),
            Divider(
              height: 0.5,
            ),
            ListTile(
              leading: Icon(Icons.audiotrack_outlined),
              title: Text(
                'Songs',
                style: TextStyle(
                    fontSize: getFontSizeLabel(context),
                    color: primaryColor(),
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
              leading: Icon(Icons.audio_file_outlined),
              title: Text(
                'My Playlists',
                style: TextStyle(
                    fontSize: getFontSizeLabel(context),
                    color: primaryColor(),
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
              leading: Icon(Icons.short_text_sharp),
              title: Text(
                'Instructions',
                style: TextStyle(
                    fontSize: getFontSizeLabel(context),
                    color: primaryColor(),
                    fontWeight: FontWeight.w300),
              ),
              onTap: () {
                Navigator.push(
                    context,
                    CupertinoPageRoute(
                        builder: (context) => InAppBrowserExampleScreen(
                            url:
                                "https://sns.alliedtechnologies.co/instruction-app.php?source=app")));
              },
            ),
            Divider(
              height: 0.5,
            ),
            ListTile(
              leading: Icon(Icons.settings_input_antenna_sharp),
              title: Text(
                'How It Works',
                style: TextStyle(
                    fontSize: getFontSizeLabel(context),
                    color: primaryColor(),
                    fontWeight: FontWeight.w300),
              ),
              onTap: () {
                Navigator.push(
                    context,
                    CupertinoPageRoute(
                        builder: (context) => InAppBrowserExampleScreen(
                            url:
                                "https://sns.alliedtechnologies.co/works-app.php?source=app")));
              },
            ),
            Divider(
              height: 0.5,
            ),
            ListTile(
              leading: Icon(Icons.spatial_audio_off_outlined),
              title: Text(
                'Listening Tips',
                style: TextStyle(
                    fontSize: getFontSizeLabel(context),
                    color: primaryColor(),
                    fontWeight: FontWeight.w300),
              ),
              onTap: () {
                Navigator.push(
                    context,
                    CupertinoPageRoute(
                        builder: (context) => InAppBrowserExampleScreen(
                            url:
                                "https://sns.alliedtechnologies.co/tips_app.php?source=app")));
              },
            ),
            Divider(
              height: 0.5,
            ),
            ListTile(
              leading: Icon(Icons.help_center_outlined),
              title: Text(
                'FAQ',
                style: TextStyle(
                    fontSize: getFontSizeLabel(context),
                    color: primaryColor(),
                    fontWeight: FontWeight.w300),
              ),
              onTap: () {
                Navigator.push(
                    context,
                    CupertinoPageRoute(
                        builder: (context) => InAppBrowserExampleScreen(
                            url:
                                "https://sns.alliedtechnologies.co/faq-app.php?source=app")));
              },
            ),
            Divider(
              height: 0.5,
            ),
            ListTile(
              leading: Icon(Icons.mail_outline),
              title: Text(
                'Contact',
                style: TextStyle(
                    fontSize: getFontSizeLabel(context),
                    color: primaryColor(),
                    fontWeight: FontWeight.w300),
              ),
              onTap: () {
                Navigator.push(
                    context,
                    CupertinoPageRoute(
                        builder: (context) => InAppBrowserExampleScreen(
                            url:
                                "https://sns.alliedtechnologies.co/contact_us_app.php?source=app")));
              },
            ),
            Divider(
              height: 0.5,
            ),
            ListTile(
              leading: Icon(Icons.handshake_outlined),
              title: Text(
                'Disclaimer',
                style: TextStyle(
                    fontSize: getFontSizeLabel(context),
                    color: primaryColor(),
                    fontWeight: FontWeight.w300),
              ),
              onTap: () {
                Navigator.push(
                    context,
                    CupertinoPageRoute(
                        builder: (context) => InAppBrowserExampleScreen(
                            url:
                                "https://sns.alliedtechnologies.co/disclaimer_app.php?source=app")));
              },
            ),
            Divider(
              height: 0.5,
            ),
            ListTile(
              leading: Icon(Icons.padding_outlined),
              title: Text(
                'Privacy Policy',
                style: TextStyle(
                    fontSize: getFontSizeLabel(context),
                    color: primaryColor(),
                    fontWeight: FontWeight.w300),
              ),
              onTap: () {
                Navigator.push(
                    context,
                    CupertinoPageRoute(
                        builder: (context) => InAppBrowserExampleScreen(
                            url:
                                "https://sns.alliedtechnologies.co/privacy_app.php?source=app")));
              },
            ),
            Divider(
              height: 0.5,
            ),
            ListTile(
              leading: Icon(Icons.padding_outlined),
              title: Text(
                'Terms Of Service',
                style: TextStyle(
                    fontSize: getFontSizeLabel(context),
                    color: primaryColor(),
                    fontWeight: FontWeight.w300),
              ),
              onTap: () {
                Navigator.push(
                    context,
                    CupertinoPageRoute(
                        builder: (context) => InAppBrowserExampleScreen(
                            url:
                                "https://sns.alliedtechnologies.co/terms-of-service-pp.php?source=app")));
              },
            ),
            Divider(
              height: 0.5,
            ),
            ListTile(
              leading: Icon(Icons.track_changes),
              title: Text(
                'Intellectual Property Notice',
                style: TextStyle(
                    fontSize: getFontSizeLabel(context),
                    color: primaryColor(),
                    fontWeight: FontWeight.w300),
              ),
              onTap: () {
                Navigator.push(
                    context,
                    CupertinoPageRoute(
                        builder: (context) => InAppBrowserExampleScreen(
                            url:
                                "https://sns.alliedtechnologies.co/intellectual-property-notice-app.php?source=app")));
              },
            ),
            Divider(
              height: 0.5,
            ),
            ListTile(
              leading: Icon(Icons.settings_power_sharp),
              title: Text(
                'Logout',
                style: TextStyle(
                    fontSize: getFontSizeLabel(context),
                    color: primaryColor(),
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
                leading: Icon(Icons.upgrade, size: 20),
                title: Text(
                  'Version 1.0.1',
                  style: TextStyle(
                      fontSize: getFontSizeLabel(context) - 3,
                      color: primaryColor(),
                      fontWeight: FontWeight.w300),
                ),
              ),
            ),
          ],
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
    return const Color(0xfff2f2f2);
  }

  getFontSizeMedium(context) {
    return deviceHeight(context) * 0.018;
  }

  getFontSize(context) {
    return deviceHeight(context) * 0.018;
  }

  deviceHeight(context) {
    var isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
    return isPortrait
        ? MediaQuery.of(context).size.height
        : MediaQuery.of(context).size.width;
  }

  getFontSizeSmall(context) {
    return deviceHeight(context) * 0.015;
  }

  getFontSizeLabel(context) {
    return deviceHeight(context) * 0.021;
  }

  getFontSizeLarge(context) {
    return deviceHeight(context) * 0.050;
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
