import 'package:flutter/material.dart';
import 'package:videonote/pages/pages.dart';


import 'models/routerArg.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Route<dynamic>? onGenerateRoute(RouteSettings settings) {
      switch (settings.name) {
        case "/home":
          return MaterialPageRoute(builder: (BuildContext context) {
            return const VideoListPage();
          });
        case "/videoView":
          return MaterialPageRoute(builder: (BuildContext context) {
            final args = settings.arguments as VideoReaderArg;
            return VideoReaderPage(videoUri: args.videoUri);
          });
        case '/':
          return null;
        default:
          return MaterialPageRoute(builder: (BuildContext context) {
            return const VideoListPage();
          });
      }
    }
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'video-note',
          initialRoute: '/home',
          onGenerateRoute: onGenerateRoute,
        );
      });
  }
}
