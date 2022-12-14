// This example demonstrates how to play a playlist with a mix of URI and asset
// audio sources, and the ability to add/remove/reorder playlist items.
//
// To run:
//
// flutter run -t lib/example_playlist.dart

import 'dart:convert';

import 'package:audio_session/audio_session.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:just_audio/just_audio.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:sns/constants.dart';
import 'package:sns/login.dart';
import 'common.dart';
import 'package:rxdart/rxdart.dart';

class MyPlayListPlayer extends StatefulWidget {
  final index, allData, maxlength, mode;
  MyPlayListPlayer({this.index, this.allData, this.maxlength, this.mode});

  @override
  MyPlayListPlayerState createState() => MyPlayListPlayerState();
}

class MyPlayListPlayerState extends State<MyPlayListPlayer>
    with WidgetsBindingObserver {
  late AudioPlayer _player;
  late final _playlist;
  int _addedCount = 0;
  final _scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();
  Constants c = new Constants();
  @override
  void initState() {
    super.initState();
    print(widget.allData[0]);
    loadPlaylist();
    ambiguate(WidgetsBinding.instance)!.addObserver(this);
    _player = AudioPlayer();
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.black,
    ));
    _init();

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
  late List _UserPlayList;
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
          _UserPlayList = jsonval["response"][0]['playlist'];
          if (jsonval["response"][0]['status'] == "failed") {
            setState(() {
              isLoadingPlay = false;
              no_postsPlay = true;
            });
          } else if (jsonval["response"][0]['status'] == "success") {
            setState(() {
              isLoadingPlay = false;
              no_postsPlay = false;
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

  showConfirm(BuildContext context, ind) {
    // print(no_postsPlay);
    var id = widget.allData[ind]['id'];
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
                      "Are you sure, you wish to delete this song from playlist?",
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
                          deletePlayList(token, id, ind);
                        });
                      })
                ],
              ));
        });
      },
    );
  }

  deletePlayList(token, id, ind) async {
    setState(() {
      pwd.text = '';
    });
    try {
      var dio = Dio();
      // final result = await InternetAddress.lookup('google.com');
      // if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      FormData formData = new FormData.fromMap({
        "delete_playlist_song": "delete_playlist@sns",
        "token": token,
        "song_id": id,
        "play_id": widget.index,
      });
      try {
        form_response = await dio.post(
          c.getBaseUrl() + 'remove_from_playlist.php',
          data: formData,
        );
      } on DioError catch (e) {
        print(e.message);
      }

      print("formData for deleted $formData");
      print("form_response fore deleted $form_response");
      // decodePlay(form_response.toString());

      c.showInSnackBar(context, "Song Removed from playlist!");
      _playlist.removeAt(ind);
    } catch (e, s) {
      print("Error " + e.toString() + " Stack " + s.toString());
    }
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

      c.showInSnackBar(context, "Created Playlist, click + again to add songs");
      // playList(token, id).then((value) {
      //   Future.delayed(Duration(milliseconds: 1500), () {
      //     showAlert(context);
      //   });
      // });

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
        "song_id": widget.allData[_player.sequenceState!.currentIndex]['id'],
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
                  "Add to Playlist",
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
                      : StatefulBuilder(
                          // You need this, notice the parameters below:
                          builder:
                              (BuildContext context, StateSetter setState) {
                          return SizedBox(
                            height: 300,
                            width: 400,
                            child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: _UserPlayList.length,
                                itemBuilder: (BuildContext context, int i) {
                                  return ListTile(
                                    onTap: () {
                                      c.getshared("token").then((token) {
                                        if (token != '' &&
                                            token != null &&
                                            token != ' ' &&
                                            token != 'null') {
                                          c
                                              .getshared("user_id")
                                              .then((user_id) {
                                            // print("CatVal $value");
                                            if (user_id != '' &&
                                                user_id != null &&
                                                user_id != ' ' &&
                                                user_id != 'null') {
                                              Navigator.of(context)
                                                  .pop("cancel");
                                              addSongToPlaylist(
                                                  token,
                                                  user_id,
                                                  _UserPlayList[i]
                                                      ['playlist_id']);
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
                                            c.capitalize(
                                                _UserPlayList[i]['name']),
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
                          );
                        })
            ],
          );
        });
      },
    );
  }

  void showModalBottomSheetCupetino() async {
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
              padding: EdgeInsets.all(30),
              child: Text(
                widget.allData[_player.sequenceState!.currentIndex]
                        ['affirmation']
                    .toString(),
                textAlign: TextAlign.left,
                style: TextStyle(
                    fontSize: c.getFontSizeLabel(context) - 3,
                    color: c.getColor("grey")),
              ),
            ),
          ],
        ),
      ),
    );
  }

  loadPlaylist() {
    setState(() {
      _playlist = ConcatenatingAudioSource(children: [
        // Remove this audio source from the Windows and Linux version because it's not supported yet
        if (kIsWeb ||
            ![TargetPlatform.windows, TargetPlatform.linux]
                    .contains(defaultTargetPlatform) &&
                widget.allData != null)
          AudioSource.uri(
            Uri.parse(widget.allData[0]['audio'].toString()),
            tag: AudioMetadata(
              title: widget.allData[0]['name'].toString(),
              album: widget.allData[0]['description'].toString(),
              artwork: widget.allData[0]['base_url'].toString() +
                  widget.allData[0]['image'].toString(),
            ),
          ),
      ]);
      for (int d = 0; d < widget.allData.length; d++) {
        if (d != 0) {
          _playlist.add(AudioSource.uri(
            Uri.parse(widget.allData[d]['audio'].toString()),
            tag: AudioMetadata(
              title: widget.allData[d]['name'].toString(),
              album: widget.allData[d]['description'].toString(),
              artwork: widget.allData[d]['base_url'].toString() +
                  widget.allData[d]['image'].toString(),
            ),
          ));
        }
      }
    });
  }

  Future<void> _init() async {
    final session = await AudioSession.instance;
    await session.configure(const AudioSessionConfiguration.speech());
    // Listen to errors during playback.
    _player.playbackEventStream.listen((event) {},
        onError: (Object e, StackTrace stackTrace) {
      print('A stream error occurred: $e');
    });
    try {
      // Preloading audio is not currently supported on Linux.
      await _player.setAudioSource(_playlist,
          preload: kIsWeb || defaultTargetPlatform != TargetPlatform.linux);
    } catch (e) {
      // Catch load errors: 404, invalid url...
      print("Error loading audio source: $e");
    }
    // Show a snackbar whenever reaching the end of an item in the playlist.
    _player.positionDiscontinuityStream.listen((discontinuity) {
      if (discontinuity.reason == PositionDiscontinuityReason.autoAdvance) {
        _showItemFinished(discontinuity.previousEvent.currentIndex);
      }
    });
    _player.processingStateStream.listen((state) {
      if (state == ProcessingState.completed) {
        _showItemFinished(_player.currentIndex);
      }
    });
  }

  void _showItemFinished(int? index) {
    if (index == null) return;
    final sequence = _player.sequence;
    if (sequence == null) return;
    final source = sequence[index];
    final metadata = source.tag as AudioMetadata;
    _scaffoldMessengerKey.currentState?.showSnackBar(SnackBar(
      content: Text('Finished playing ${metadata.title}'),
      duration: const Duration(seconds: 1),
    ));
  }

  @override
  void dispose() {
    ambiguate(WidgetsBinding.instance)!.removeObserver(this);
    _player.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      // Release the player's resources when not in use. We use "stop" so that
      // if the app resumes later, it will still remember what position to
      // resume from.
      _player.stop();
    }
  }

  Stream<PositionData> get _positionDataStream =>
      Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
          _player.positionStream,
          _player.bufferedPositionStream,
          _player.durationStream,
          (position, bufferedPosition, duration) => PositionData(
              position, bufferedPosition, duration ?? Duration.zero));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldMessengerKey,
      appBar: c.getAppBar("Sound & Soulful"),
      drawer: c.getDrawer(context),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: StreamBuilder<SequenceState?>(
                stream: _player.sequenceStateStream,
                builder: (context, snapshot) {
                  final state = snapshot.data;
                  if (state?.sequence.isEmpty ?? true) {
                    return const SizedBox();
                  }
                  final metadata = state!.currentSource!.tag as AudioMetadata;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(child: Image.network(metadata.artwork)),
                        ),
                      ),
                      Text(metadata.album,
                          style: Theme.of(context).textTheme.headline6),
                      Text(metadata.title),
                    ],
                  );
                },
              ),
            ),
            ControlButtons(_player),
            StreamBuilder<PositionData>(
              stream: _positionDataStream,
              builder: (context, snapshot) {
                final positionData = snapshot.data;
                return SeekBar(
                  duration: positionData?.duration ?? Duration.zero,
                  position: positionData?.position ?? Duration.zero,
                  bufferedPosition:
                      positionData?.bufferedPosition ?? Duration.zero,
                  onChangeEnd: (newPosition) {
                    _player.seek(newPosition);
                  },
                );
              },
            ),
            const SizedBox(height: 8.0),
            Row(
              children: [
                StreamBuilder<LoopMode>(
                  stream: _player.loopModeStream,
                  builder: (context, snapshot) {
                    final loopMode = snapshot.data ?? LoopMode.off;
                    const icons = [
                      Icon(Icons.repeat, color: Colors.grey),
                      Icon(Icons.repeat, color: Colors.orange),
                      Icon(Icons.repeat_one, color: Colors.orange),
                    ];
                    const cycleModes = [
                      LoopMode.off,
                      LoopMode.all,
                      LoopMode.one,
                    ];
                    final index = cycleModes.indexOf(loopMode);
                    return IconButton(
                      icon: icons[index],
                      onPressed: () {
                        _player.setLoopMode(cycleModes[
                            (cycleModes.indexOf(loopMode) + 1) %
                                cycleModes.length]);
                      },
                    );
                  },
                ),
                Expanded(
                  child: Text(
                    "Playlist",
                    style: Theme.of(context).textTheme.headline6,
                    textAlign: TextAlign.center,
                  ),
                ),
                StreamBuilder<bool>(
                  stream: _player.shuffleModeEnabledStream,
                  builder: (context, snapshot) {
                    final shuffleModeEnabled = snapshot.data ?? false;
                    return IconButton(
                      icon: shuffleModeEnabled
                          ? const Icon(Icons.shuffle, color: Colors.orange)
                          : const Icon(Icons.shuffle, color: Colors.grey),
                      onPressed: () async {
                        final enable = !shuffleModeEnabled;
                        if (enable) {
                          await _player.shuffle();
                        }
                        await _player.setShuffleModeEnabled(enable);
                      },
                    );
                  },
                ),
                StreamBuilder<bool>(
                  stream: _player.shuffleModeEnabledStream,
                  builder: (context, snapshot) {
                    final shuffleModeEnabled = snapshot.data ?? false;
                    return IconButton(
                      icon: const Icon(Icons.list_alt, color: Colors.grey),
                      onPressed: () async {
                        showModalBottomSheetCupetino();
                      },
                    );
                  },
                ),
              ],
            ),
            SizedBox(
              height: 240.0,
              child: StreamBuilder<SequenceState?>(
                stream: _player.sequenceStateStream,
                builder: (context, snapshot) {
                  final state = snapshot.data;
                  final sequence = state?.sequence ?? [];
                  return ReorderableListView(
                    onReorder: (int oldIndex, int newIndex) {
                      if (oldIndex < newIndex) newIndex--;
                      _playlist.move(oldIndex, newIndex);
                    },
                    children: [
                      for (var i = 0; i < sequence.length; i++)
                        Dismissible(
                          key: ValueKey(sequence[i]),
                          background: Container(
                            color: Colors.redAccent,
                            alignment: Alignment.centerRight,
                            child: const Padding(
                              padding: EdgeInsets.only(right: 8.0),
                              child: Icon(Icons.delete, color: Colors.white),
                            ),
                          ),
                          onDismissed: (dismissDirection) {
                            _playlist.removeAt(i);
                          },
                          child: GestureDetector(
                            onLongPress: () {
                              showConfirm(context, i);
                            },
                            child: Material(
                              color: i == state!.currentIndex
                                  ? Colors.grey.shade300
                                  : null,
                              child: ListTile(
                                leading: Image.network(sequence[i].tag.artwork),
                                title: Text(sequence[i].tag.title as String),
                                onTap: () {
                                  _player.seek(Duration.zero, index: i);
                                },
                              ),
                            ),
                          ),
                        ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ControlButtons extends StatelessWidget {
  final AudioPlayer player;

  const ControlButtons(this.player, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: const Icon(Icons.volume_up),
          onPressed: () {
            showSliderDialog(
              context: context,
              title: "Adjust volume",
              divisions: 10,
              min: 0.0,
              max: 1.0,
              value: player.volume,
              stream: player.volumeStream,
              onChanged: player.setVolume,
            );
          },
        ),
        StreamBuilder<SequenceState?>(
          stream: player.sequenceStateStream,
          builder: (context, snapshot) => IconButton(
            icon: const Icon(Icons.skip_previous),
            onPressed: player.hasPrevious ? player.seekToPrevious : null,
          ),
        ),
        StreamBuilder<PlayerState>(
          stream: player.playerStateStream,
          builder: (context, snapshot) {
            final playerState = snapshot.data;
            final processingState = playerState?.processingState;
            final playing = playerState?.playing;
            if (processingState == ProcessingState.loading ||
                processingState == ProcessingState.buffering) {
              return Container(
                margin: const EdgeInsets.all(8.0),
                width: 64.0,
                height: 64.0,
                child: const CircularProgressIndicator(),
              );
            } else if (playing != true) {
              return IconButton(
                icon: const Icon(Icons.play_arrow),
                iconSize: 64.0,
                onPressed: player.play,
              );
            } else if (processingState != ProcessingState.completed) {
              return IconButton(
                icon: const Icon(Icons.pause),
                iconSize: 64.0,
                onPressed: player.pause,
              );
            } else {
              return IconButton(
                icon: const Icon(Icons.replay),
                iconSize: 64.0,
                onPressed: () => player.seek(Duration.zero,
                    index: player.effectiveIndices!.first),
              );
            }
          },
        ),
        StreamBuilder<SequenceState?>(
          stream: player.sequenceStateStream,
          builder: (context, snapshot) => IconButton(
            icon: const Icon(Icons.skip_next),
            onPressed: player.hasNext ? player.seekToNext : null,
          ),
        ),
        StreamBuilder<double>(
          stream: player.speedStream,
          builder: (context, snapshot) => IconButton(
            icon: Text("${snapshot.data?.toStringAsFixed(1)}x",
                style: const TextStyle(fontWeight: FontWeight.bold)),
            onPressed: () {
              showSliderDialog(
                context: context,
                title: "Adjust speed",
                divisions: 10,
                min: 0.5,
                max: 1.5,
                value: player.speed,
                stream: player.speedStream,
                onChanged: player.setSpeed,
              );
            },
          ),
        ),
      ],
    );
  }
}

class AudioMetadata {
  final String album;
  final String title;
  final String artwork;

  AudioMetadata({
    required this.album,
    required this.title,
    required this.artwork,
  });
}
