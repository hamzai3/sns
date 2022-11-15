import 'dart:convert';

import 'package:audio_service/audio_service.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:sns/constants.dart';
import 'package:sns/login.dart';

class AudioManager extends StatefulWidget {
  final index, allData, maxlength;
  AudioManager({this.index, this.allData, this.maxlength});
  // const AudioManager({super.key});

  @override
  State<AudioManager> createState() => _AudioManagerState();
}

class _AudioManagerState extends State<AudioManager> {
  Constants c = Constants();
  late final PageManager _pageManager;
  bool noData = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List data = [];
  @override
  void initState() {
    super.initState();
    setState(() {
      if (widget.allData != null && widget.allData.length > 0) {
        print(widget.allData);
        print(widget.index);
        data.add(widget.allData[widget.index]);
        if (data.length > 0) {
          _pageManager = PageManager(data[0]['audio']);
        }
      } else {
        noData = true;
      }
    });

    c.getshared("token").then((token) {
      if (token != '' && token != null && token != ' ' && token != 'null') {
        c.getshared("playlist").then((playlist) {
          // print("CatVal $value");
          if (playlist != '' &&
              playlist != null &&
              playlist != ' ' &&
              playlist != 'null') {
            decodePlay(playlist);
          }
          c.getshared("user_id").then((user_id) {
            // print("CatVal $value");
            if (user_id != '' &&
                user_id != null &&
                user_id != ' ' &&
                user_id != 'null') {
              playList(token, user_id);
            }
          });
        });
      } else {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => LoginPage()));
      }
    });
  }

  TextEditingController pwd = TextEditingController();
  late List _playList;
  late Response form_response;

  Future playList(token, id) async {
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
      decodePlay(form_response.toString());
      c.setshared("playlist", form_response.toString());
      // } else {
      //   Navigator.pushAndRemoveUntil(
      //       context,
      //       MaterialPageRoute(builder: (context) => NoInternet()),
      //       ModalRoute.withName('/NoInternet'));
      // }
      return "DONE";
    } catch (e, s) {
      print("Error " + e.toString() + " Stack " + s.toString());
    }
  }

  bool no_postsPlay = false, isLoadingPlay = true;
  decodePlay(js) {
    print("PLayslist $no_postsPlay are $js");
    setState(() {
      if (js != "") {
        try {
          var jsonval = json.decode(js);
          _playList = jsonval["response"][0]['playlist'];
          if (jsonval["response"][0]['status'] == "failed") {
            setState(() {
              isLoadingPlay = false;
              no_postsPlay = true;
            });
          } else if (jsonval["response"][0]['status'] == "success") {
            setState(() {
              isLoadingPlay = false;
            });
          }
        } catch (c) {
          setState(() {
            isLoadingPlay = false;
            no_postsPlay = true;
          });
        }
      } else {
        setState(() {
          isLoadingPlay = false;
          no_postsPlay = true;
        });
      }
      print("PLayslist  again $no_postsPlay are $isLoadingPlay");
    });
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
        "create_playlist": "create_playlist@sns",
        "token": token,
        "user_id": id,
        "name": name,
      });
      try {
        form_response = await dio.post(
          c.getBaseUrl() + 'playlist_create_api.php',
          data: formData,
        );
      } on DioError catch (e) {
        print(e.message);
      }

      print("formData $formData");
      print("form_response $form_response");
      // decodePlay(form_response.toString());

      c.showInSnackBar(context, "Creating new playlist!");
      playList(token, id).then((value) {
        Future.delayed(Duration(milliseconds: 1500), () {
          showAlert(context);
        });
      });

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

  addSongToPlaylist(token, id, name) async {
    try {
      var dio = Dio();
      // final result = await InternetAddress.lookup('google.com');
      // if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      FormData formData = new FormData.fromMap({
        "add_songs_playlist": "add_songs_playlist@sns",
        "token": token,
        "user_id": id,
        "song_id": data[0]['id'],
        "id": name,
      });
      try {
        form_response = await dio.post(
          c.getBaseUrl() + 'playlist_create_api.php',
          data: formData,
        );
      } on DioError catch (e) {
        print(e.message);
      }

      print("formData $formData");
      print("form_response $form_response");
      // decodePlay(form_response.toString());

      c.showInSnackBar(context, "Song added to your playlist");
      playList(token, id);
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

  showAlert(BuildContext context) {
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
                  "All to Playlist",
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
              decoration: InputDecoration(
                hintText: "Enter Playlist Name",
                fillColor: c.primaryColor(),
                filled: false, // dont forget this line
                suffixIcon: GestureDetector(
                    onTap: () {
                      c.getshared("token").then((token) {
                        if (token != '' &&
                            token != null &&
                            token != ' ' &&
                            token != 'null') {
                          c.getshared("user_id").then((user_id) {
                            // print("CatVal $value");
                            if (user_id != '' &&
                                user_id != null &&
                                user_id != ' ' &&
                                user_id != 'null') {
                              Navigator.of(context).pop("cancel");
                              savePlayList(token, user_id, pwd.text);
                            }
                          });
                        }
                      });
                    },
                    child: Icon(Icons.save)),
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
            actions: [
              // Text("$isLoadingPlay $no_posts"),
              isLoadingPlay
                  ? CircularProgressIndicator()
                  : no_postsPlay
                      ? Text("There are no playlist(s)")
                      : SizedBox(
                          height: 300,
                          width: 400,
                          child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: _playList.length,
                              itemBuilder: (BuildContext context, int i) {
                                return ListTile(
                                  onTap: () {
                                    c.getshared("token").then((token) {
                                      if (token != '' &&
                                          token != null &&
                                          token != ' ' &&
                                          token != 'null') {
                                        c.getshared("user_id").then((user_id) {
                                          // print("CatVal $value");
                                          if (user_id != '' &&
                                              user_id != null &&
                                              user_id != ' ' &&
                                              user_id != 'null') {
                                            Navigator.of(context).pop("cancel");
                                            addSongToPlaylist(token, user_id,
                                                _playList[i]['playlist_id']);
                                          }
                                        });
                                      }
                                    });
                                  },
                                  leading: Icon(Icons.star),
                                  title: Row(
                                    children: [
                                      Center(
                                        child: Text(
                                          c.capitalize(_playList[i]['name']),
                                          style: TextStyle(
                                            fontSize:
                                                c.getFontSizeLabel(context),
                                            fontWeight: FontWeight.w800,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  trailing: Icon(Icons.navigate_next),
                                );
                              }),
                        )
            ],
          );
        });
      },
    );
  }

  void showModalBottomSheetCupetino(msg) async {
    await showCupertinoModalBottomSheet(
      useRootNavigator: true,
      context: context,
      bounce: true,
      isDismissible: true,
      // backgroundColor: const Color(0xff6B5A00),
      builder: (context) => Material(
        // color: const Color(0xff6B5A00),
        child: ListView(
          shrinkWrap: true,
          // mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              margin: const EdgeInsets.all(5.0),
              padding: const EdgeInsets.all(5.0),
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Colors.white,
                    width: 1.0,
                  ),
                ),
              ),
              child: AutoSizeText(
                "Affirmation",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontFamily: c.fontFamily(type: "pacifico"),
                    fontSize: c.getFontSizeLarge(context) - 15,
                    color: c.getColor("grey")),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10),
              child: Text(
                msg,
                style: TextStyle(
                    fontSize: c.getFontSizeLabel(context),
                    color: c.getColor("grey")),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _pageManager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: c.getAppBar("Sound N Soulful"),
      drawer: c.getDrawer(context),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: noData
            ? Center(
                child: Text("Seems like we don't have song here"),
              )
            : Column(
                children: [
                  // const Spacer(),
                  Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(2.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: CachedNetworkImage(
                          width: c.deviceWidth(context) * 0.5,
                          height: c.deviceHeight(context) * 0.25,
                          imageUrl: data[0]['base_url'] + data[0]['image'],
                          placeholder: (context, url) => const Padding(
                            padding: EdgeInsets.all(58.0),
                            child: CircularProgressIndicator(),
                          ),
                          fit: BoxFit.cover,
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.circle_outlined),
                        ),
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(10, 12, 10, 0),
                          child: AutoSizeText(
                            data[0]['name'],
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                fontSize: c.getFontSizeLabel(context) - 3,
                                // fontWeight: FontWeight.w800,
                                color: c.getColor("grey")),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Center(
                    child: SizedBox(
                      height: c.deviceHeight(context) * 0.42,
                      child: Container(
                        color: Colors.white,
                        child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: widget.allData.length,
                            itemBuilder: (BuildContext context, int i) {
                              return Container(
                                decoration: const BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                      color: Colors.grey,
                                      width: 0.2,
                                    ),
                                  ),
                                ),
                                child: ListTile(
                                  onTap: () {
                                    _pageManager.pause();
                                    if (Navigator.canPop(context)) {
                                      Navigator.of(context).pop();
                                    }
                                    Navigator.pushReplacement(
                                      context,
                                      PageRouteBuilder(
                                        pageBuilder:
                                            (context, animation1, animation2) =>
                                                AudioManager(
                                          index: i,
                                          allData: widget.allData,
                                          maxlength: widget.allData.length,
                                        ),
                                        transitionDuration: Duration.zero,
                                        reverseTransitionDuration:
                                            Duration.zero,
                                      ),
                                    );
                                  },
                                  contentPadding: EdgeInsets.all(8),
                                  leading: ClipRRect(
                                    borderRadius: BorderRadius.circular(2.0),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(8.0),
                                      child: CachedNetworkImage(
                                        width: c.deviceWidth(context) * 0.2,
                                        height: c.deviceHeight(context) * 0.1,
                                        imageUrl: widget.allData[i]
                                                ['base_url'] +
                                            widget.allData[i]['image'],
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
                                  title: Row(
                                    children: [
                                      Expanded(
                                        child: AutoSizeText(
                                          widget.allData[i]['name'],
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                              fontSize:
                                                  c.getFontSizeLabel(context) -
                                                      10,
                                              fontFamily: c.fontFamily(),
                                              color: c.getColor("grey")),
                                        ),
                                      ),
                                    ],
                                  ),
                                  trailing: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Icon(Icons.arrow_forward_ios),
                                  ),
                                ),
                              );
                            }),
                      ),
                    ),
                  ),

                  ValueListenableBuilder<ProgressBarState>(
                    valueListenable: _pageManager.progressNotifier,
                    builder: (_, value, __) {
                      return ProgressBar(
                        progress: value.current,
                        buffered: value.buffered,
                        total: value.total,
                        onSeek: _pageManager.seek,
                      );
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Add to PLayList
                      GestureDetector(
                        onTap: () {
                          showAlert(context);
                        },
                        child: Icon(
                          Icons.playlist_add,
                          size: 36,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () {
                              var ind = 0;
                              if (widget.maxlength >= 0 && widget.index > 0) {
                                ind = widget.index - 1;

                                _pageManager.pause();
                                if (Navigator.canPop(context)) {
                                  Navigator.of(context).pop();
                                }

                                Navigator.push(
                                  context,
                                  PageRouteBuilder(
                                    pageBuilder:
                                        (context, animation1, animation2) =>
                                            AudioManager(
                                      index: ind,
                                      allData: widget.allData,
                                      maxlength: widget.allData.length,
                                    ),
                                    transitionDuration: Duration.zero,
                                    reverseTransitionDuration: Duration.zero,
                                  ),
                                );
                              }
                            },
                            child: RotationTransition(
                              turns: AlwaysStoppedAnimation(180 / 360),
                              child: Icon(
                                Icons.double_arrow,
                                size: 39,
                              ),
                            ),
                          ),
                          ValueListenableBuilder<ButtonState>(
                            valueListenable: _pageManager.buttonNotifier,
                            builder: (_, value, __) {
                              switch (value) {
                                case ButtonState.loading:
                                  return Container(
                                    margin: const EdgeInsets.all(8.0),
                                    width: 39.0,
                                    height: 32.0,
                                    child: const CircularProgressIndicator(),
                                  );
                                case ButtonState.paused:
                                  return IconButton(
                                    icon: const Icon(Icons.play_arrow),
                                    iconSize: 42.0,
                                    onPressed: _pageManager.play,
                                  );
                                case ButtonState.playing:
                                  return IconButton(
                                    icon: const Icon(Icons.pause),
                                    iconSize: 39.0,
                                    onPressed: _pageManager.pause,
                                  );
                              }
                            },
                          ),
                          GestureDetector(
                            onTap: () {
                              if (widget.maxlength > (widget.index + 1)) {
                                var ind = widget.index + 1;
                                _pageManager.pause();

                                if (Navigator.canPop(context)) {
                                  Navigator.of(context).pop();
                                }

                                Navigator.push(
                                  context,
                                  PageRouteBuilder(
                                    pageBuilder:
                                        (context, animation1, animation2) =>
                                            AudioManager(
                                      index: ind,
                                      allData: widget.allData,
                                      maxlength: widget.allData.length,
                                    ),
                                    transitionDuration: Duration.zero,
                                    reverseTransitionDuration: Duration.zero,
                                  ),
                                );
                              }
                            },
                            child: RotationTransition(
                              turns: AlwaysStoppedAnimation(1),
                              child: Icon(
                                Icons.double_arrow,
                                size: 39,
                              ),
                            ),
                          ),
                        ],
                      ),
                      //Affiramtion Popup
                      GestureDetector(
                        onTap: () {
                          showModalBottomSheetCupetino(data[0]['affirmation']);
                        },
                        child: Icon(
                          Icons.queue_music_outlined,
                          size: 36,
                        ),
                      )
                    ],
                  )
                ],
              ),
      ),
    );
  }
}

class PageManager {
  final progressNotifier = ValueNotifier<ProgressBarState>(
    ProgressBarState(
      current: Duration.zero,
      buffered: Duration.zero,
      total: Duration.zero,
    ),
  );
  final buttonNotifier = ValueNotifier<ButtonState>(ButtonState.paused);

  // static const url =
  //     'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-2.mp3';

  late AudioPlayer _audioPlayer;
  PageManager(url) {
    _init(url);
  }

  void _init(url) async {
    _audioPlayer = AudioPlayer();
    await _audioPlayer.setUrl(url);
    AudioSource.uri(
      Uri.parse(url),
      tag: MediaItem(
        // Specify a unique ID for each media item:
        id: '1',
        // Metadata to display in the notification:
        album: "Sound N Soulful",
        title: "Now Playing",
        artUri: Uri.parse(
            'https://cdn.shopify.com/s/files/1/0411/3815/9784/files/IMG_0469_360x.PNG?v=1615926653'),
      ),
    );
    _audioPlayer.playerStateStream.listen((playerState) {
      final isPlaying = playerState.playing;
      final processingState = playerState.processingState;
      if (processingState == ProcessingState.loading ||
          processingState == ProcessingState.buffering) {
        buttonNotifier.value = ButtonState.loading;
      } else if (!isPlaying) {
        buttonNotifier.value = ButtonState.paused;
      } else if (processingState != ProcessingState.completed) {
        buttonNotifier.value = ButtonState.playing;
      } else {
        _audioPlayer.seek(Duration.zero);
        _audioPlayer.pause();
      }
    });

    _audioPlayer.positionStream.listen((position) {
      final oldState = progressNotifier.value;
      progressNotifier.value = ProgressBarState(
        current: position,
        buffered: oldState.buffered,
        total: oldState.total,
      );
    });

    _audioPlayer.bufferedPositionStream.listen((bufferedPosition) {
      final oldState = progressNotifier.value;
      progressNotifier.value = ProgressBarState(
        current: oldState.current,
        buffered: bufferedPosition,
        total: oldState.total,
      );
    });

    _audioPlayer.durationStream.listen((totalDuration) {
      final oldState = progressNotifier.value;
      progressNotifier.value = ProgressBarState(
        current: oldState.current,
        buffered: oldState.buffered,
        total: totalDuration ?? Duration.zero,
      );
    });
  }

  void play() {
    _audioPlayer.play();
  }

  void pause() {
    _audioPlayer.pause();
  }

  void seek(Duration position) {
    _audioPlayer.seek(position);
  }

  void dispose() {
    _audioPlayer.dispose();
  }
}

class ProgressBarState {
  ProgressBarState({
    required this.current,
    required this.buffered,
    required this.total,
  });
  final Duration current;
  final Duration buffered;
  final Duration total;
}

enum ButtonState { paused, playing, loading }
