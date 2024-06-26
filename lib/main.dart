import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_filip/provider/player_manager.dart';
import 'package:flutter_filip/provider/playlist_provider.dart';
import 'package:flutter_filip/res/app_colors.dart';
import 'package:flutter_filip/service/music_client.dart';
import 'package:flutter_filip/view/home_view.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:provider/provider.dart';

void setBackground() async {
  if(Platform.isAndroid) {
    await JustAudioBackground.init(
      androidNotificationChannelId: 'com.ryanheise.bg_demo.channel.audio',
      androidNotificationChannelName: 'Audio playback',
      androidNotificationOngoing: true,
    );
  }
}

void main() {
  setBackground();
  final musicClient = MusicClient();
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(
          create: (context) => PlayerManager(musicClient: musicClient)),
      ChangeNotifierProvider(create: (_) => PlaylistProvider(musicClient: musicClient))
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: backgroundColor,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomeView(),
    );
  }
}
