import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sns/home.dart';
import 'constants.dart';
import 'register.dart';
import 'package:intro_slider/intro_slider.dart';

class Intros extends StatefulWidget {
  @override
  _IntrosState createState() => _IntrosState();
}

class _IntrosState extends State<Intros> {
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

  void initState() {
    super.initState();
  }

  void onDonePress() {
    print("End of slides");
    Navigator.pop(context);
    Navigator.push(context, CupertinoPageRoute(builder: (context) => Home()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      body: WillPopScope(
        onWillPop: () => _exitApp(context),
        child: SafeArea(
            child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: IntroSlider(
            // scrollPhysics: ScrollPhysics.,

            key: UniqueKey(),
            listContentConfig: [
              ContentConfig(
                verticalScrollbarBehavior: ScrollbarBehavior.hide,
                styleTitle: TextStyle(
                    color: Colors.black,
                    fontSize: c.getFontSizeLabel(context) + 8,
                    height: 1.8,
                    fontFamily: c.fontFamily(type: "pacifico")),
                title: "How To Start Using Subliminals",
                heightImage: c.deviceHeight(context) * 0.3,
                widthImage: c.deviceWidth(context) * 0.8,
                description: "4 Steps",
                pathImage: "assets/steps.png",
                backgroundColor: Color.fromARGB(255, 255, 255, 255),
                styleDescription: TextStyle(
                  color: Colors.black,
                  fontSize: 22,
                  height: 2.8,
                ),
                textAlignDescription: TextAlign.center,
              ),
              ContentConfig(
                verticalScrollbarBehavior: ScrollbarBehavior.hide,
                styleTitle: TextStyle(
                    color: Colors.black,
                    fontSize: c.getFontSizeLabel(context) + 8,
                    height: 1.8,
                    fontFamily: c.fontFamily(type: "pacifico")),
                title: "Step 1: Explore our library.",
                heightImage: c.deviceHeight(context) * 0.3,
                widthImage: c.deviceWidth(context) * 0.8,
                description:
                    "Browse our library of over 100+ subliminal affirmations meditation tracks. We currently have subliminals for all areas of life including: love & relationships, money, business, talent and appearance.",
                pathImage: "assets/intro1.png",
                backgroundColor: Color.fromARGB(255, 255, 255, 255),
                styleDescription: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  height: 1.8,
                ),
                textAlignDescription: TextAlign.center,
              ),
              ContentConfig(
                verticalScrollbarBehavior: ScrollbarBehavior.hide,
                styleTitle: TextStyle(
                    color: Colors.black,
                    fontSize: c.getFontSizeLabel(context) + 8,
                    height: 1.8,
                    fontFamily: c.fontFamily(type: "pacifico")),
                maxLineTitle: 3,
                title: "Step 2: Choose a background sound.",
                heightImage: c.deviceHeight(context) * 0.15,
                widthImage: c.deviceWidth(context) * 0.8,
                description:
                    "For every single one of our subliminals, we offer 3-5 different background sounds. The tracks contain identical subliminal affirmations and binaural beat frequencies, so you can choose whichever background sound you prefer! Also, the affirmations we've created for each subliminal are listed out below the tracks so you will always know what affirmations are included in the track, even though you won't be able to consciously hear them.",
                pathImage: "assets/intro2.png",
                backgroundColor: Color.fromARGB(255, 255, 255, 255),
                styleDescription: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  height: 1.8,
                ),
                textAlignDescription: TextAlign.center,
              ),
              ContentConfig(
                verticalScrollbarBehavior: ScrollbarBehavior.hide,
                styleTitle: TextStyle(
                    color: Colors.black,
                    fontSize: c.getFontSizeLabel(context) + 8,
                    height: 1.8,
                    fontFamily: c.fontFamily(type: "pacifico")),
                title: "Step 3: Listen consistently. ",
                heightImage: c.deviceHeight(context) * 0.3,
                widthImage: c.deviceWidth(context) * 0.8,
                description:
                    "Research shows that it takes 21 days to form a new habit. The same is true for your brain! Be sure to listen to subliminals consistently for best results.",
                pathImage: "assets/intro3.png",
                backgroundColor: Color.fromARGB(255, 255, 255, 255),
                styleDescription: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  height: 1.8,
                ),
                textAlignDescription: TextAlign.center,
              ),
              ContentConfig(
                verticalScrollbarBehavior: ScrollbarBehavior.hide,
                styleTitle: TextStyle(
                    color: Colors.black,
                    fontSize: c.getFontSizeLabel(context) + 8,
                    height: 1.8,
                    fontFamily: c.fontFamily(type: "pacifico")),
                maxLineTitle: 3,
                title: "Step 4: Watch for evidence of shifts + changes.",
                heightImage: c.deviceHeight(context) * 0.2,
                widthImage: c.deviceWidth(context) * 0.8,
                description:
                    "Once you've started listening, keep your eyes open for any changes or shifts you may experience! Often, the early evidence of manifestation is small but still very significant. Remember to keep an open mind, have faith in the thing you're shifting in your life and get excited about the small changes as you begin to notice them.",
                pathImage: "assets/intro4.png",
                backgroundColor: Color.fromARGB(255, 255, 255, 255),
                styleDescription: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  height: 1.8,
                ),
                textAlignDescription: TextAlign.center,
              ),
            ],
            onDonePress: onDonePress,
          ),
        )),
      ),
    );
  }
}
