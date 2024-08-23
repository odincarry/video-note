import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:video_player/video_player.dart';

import '../../utils/storage.dart';

class SidebarXController extends ChangeNotifier {
  SidebarXController({
    bool? extended,
  }) {
    _setExtedned(extended ?? false);
  }

  var _extended = false;

  final _extendedController = StreamController<bool>.broadcast();
  Stream<bool> get extendStream =>
      _extendedController.stream.asBroadcastStream();

  bool get extended => _extended;

  void toggleExtended() {
    _extended = !_extended;
    _extendedController.add(_extended);
    notifyListeners();
  }

  void _setExtedned(bool val) {
    _extended = val;
    notifyListeners();
  }

  @override
  void dispose() {
    _extendedController.close();
    super.dispose();
  }
}

class VideoReaderPage extends StatefulWidget {
  final Uri videoUri;
  const VideoReaderPage({super.key, required this.videoUri});

  @override
  State<StatefulWidget> createState() => _VideoReaderPage();
}


late final VideoPlayerController videoPlayerController;




class _VideoReaderPage extends State<VideoReaderPage> with SingleTickerProviderStateMixin  {
  final controller =  SidebarXController(extended: true);
  late AnimationController animationController;
  late Animation<double> _animation;
  final textController = TextEditingController(
    text: '',
  );
  late final ChewieController chewieController = ChewieController(
    videoPlayerController: VideoPlayerController.networkUrl(widget.videoUri),
    autoPlay: true,
    looping: true,
    playbackSpeeds: [0.5, 1, 1.5, 2],
    subtitleBuilder: (context, subtitle) => Container(
      padding: const EdgeInsets.all(10.0),
      child: Text(
        subtitle,
        style: const TextStyle(color: Colors.red),
      ),
    ),
  );

  final storage =  const FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      duration: const Duration(milliseconds: 300), vsync: this,
    );

    if (controller.extended) {
      animationController?.forward();
    } else {
      animationController?.reverse();
    }
    controller.extendStream.listen((extended) {
      if (animationController?.isCompleted ?? false) {
        animationController?.reverse();
      } else {
        animationController?.forward();
      }
    },
    );

    _animation = CurvedAnimation(
      parent: animationController,
      curve: Curves.easeIn,
    );

    SharedStorage.read('test.video_note_content').then((value) {
      textController.text = value?? '';
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text('播放器'),
        ),
        body: Container(
          decoration: const BoxDecoration(
            color: Colors.indigo,
          ),
          child: Row(
              children: [
                Expanded(
                  child: Center(
                    child: Chewie(
                      controller: chewieController,
                    ),
                  ),
                ),
                AnimatedBuilder(
                  animation: controller,
                  builder: (context, child) {
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      width: controller.extended? 300 : 100,
                      height: double.infinity,
                      padding: const EdgeInsets.all(10),
                      margin: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        children: [
                          AnimatedBuilder(
                            animation: _animation,
                            builder: (context, _) {
                              final value = ((1 - _animation.value) * 6).toInt();
                              if (value <= 0) {
                                return SafeArea(
                                    child: Column(
                                      children: [
                                        Container(
                                          color: Colors.grey,
                                          child: Row(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: [
                                              IconButton(
                                                iconSize: 20,
                                                icon: const Icon(Icons.save_outlined),
                                                onPressed: () async {
                                                  final aaa = await SharedStorage.write('test.video_note_content', textController.text);
                                                },
                                              ),
                                              IconButton(
                                                iconSize: 20,
                                                icon: const Icon(Icons.file_open_outlined),
                                                onPressed: () {
                                                  // ...
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(
                                            height: 10
                                        ),
                                        SingleChildScrollView(
                                            child: Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: SizedBox(
                                                    height: 800,
                                                    child: TextField(
                                                      controller: textController,
                                                      maxLines: null,
                                                      keyboardType: TextInputType.multiline,
                                                      decoration: const InputDecoration.collapsed(hintText: "Enter your text here"),
                                                    )
                                                )
                                            )
                                        ),
                                      ],
                                    )
                                );
                              }
                              return const Spacer();
                            },
                          ),
                          const Spacer(),
                          InkWell(
                            key: const Key('side-note'),
                            onTap: () {
                              controller.toggleExtended();
                              print(_animation.value);
                            },
                            child: Row(
                              mainAxisAlignment: controller.extended
                                  ? MainAxisAlignment.end
                                  : MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Icon(
                                    controller.extended ? Icons.arrow_back_ios_new : Icons.arrow_forward_ios,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ]
          ),
        ) // This trail/ This trailing comma makes auto-formatting nicer for build methods.
    );
  }

}
