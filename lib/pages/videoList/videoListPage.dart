
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:videonote/models/routerArg.dart';

class VideoListPage extends StatefulWidget {
  const VideoListPage({super.key});

  @override
  State<StatefulWidget> createState() => _VideoListPageState();
}

class _VideoListPageState extends State<VideoListPage> with WidgetsBindingObserver {
  final ScrollController scrollController = ScrollController();

  List<Uri> videoList = [
    Uri.parse('https://test-streams.mux.dev/x36xhzz/x36xhzz.m3u8'),
  ];

  @override
  initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);
  }

  @override
  didChangeDependencies(){
    super.didChangeDependencies();
  }

  @override
  deactivate(){
    super.deactivate();
  }

  @override
  dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }


  Widget _customBody() {
    return RefreshIndicator(
        onRefresh: () async {
          await Future.delayed(const Duration(seconds: 2));
        },
        child: videoList.isEmpty ?
        ListView.builder(
          itemCount: 1,
          itemBuilder: (context, index) {
            return const Text(
                '沒影片',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)
            );
          },
        ) : SafeArea(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                      child: ListView.builder(
                        controller: scrollController,
                        itemBuilder: (BuildContext context, int index) {
                          return InkWell(
                            onTap: () {
                              print(videoList[index]);
                              Navigator.pushNamed(context, '/videoView', arguments: VideoReaderArg(videoList[index]));
                            },
                            child: Container(
                              height: 80,
                              color: Colors.amber,
                              child: Center(child: Text('位置 ${videoList[index].path}'))
                            ),
                          );
                        },
                        itemCount: videoList.length,
                      )
                  ),

                ],
              ),
            )
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("影片目錄"),
        backgroundColor: Colors.cyan,
        automaticallyImplyLeading: false,
      ),
      body: _customBody(),
    );
  }
}
