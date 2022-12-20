import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:sns/SamplePlay.dart';
import 'package:sns/constants.dart';
import 'package:sns/home.dart';
import 'package:sns/intros.dart';
import 'package:sns/login.dart';

void main() async {
  // await JustAudioBackground.init(
  //   androidNotificationChannelId: 'com.allied.bg_demo.channel.audio',
  //   androidNotificationChannelName: 'Sound & Soulful',
  //   androidNotificationOngoing: true,
  // );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Sound & Soulful',
      theme:
          ThemeData(primarySwatch: Colors.grey, fontFamily: 'Poppins-Regular'),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Constants c = Constants();

  Response? form_response;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    c.getshared("token").then((value) {
      print("toekn are $value");
      if (value != "null") {
        Future.delayed(Duration(seconds: 3), () {
          Navigator.push(context, CupertinoPageRoute(builder: (_) => Home()));
        });
      } else {
        Future.delayed(Duration(seconds: 3), () {
          Navigator.push(
              context, CupertinoPageRoute(builder: (_) => LoginPage()));
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(28.0),
              child: Image.asset("assets/sns.gif"),
            )
          ],
        ),
      ),
    );
  }
}
