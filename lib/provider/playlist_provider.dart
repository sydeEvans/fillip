import 'package:flutter/material.dart';
import 'package:flutter_filip/service/music_client.dart';

class PlaylistProvider extends ChangeNotifier {
  List<Playlist> playlist = [];

  late final MusicClient musicClient;

  PlaylistProvider({required this.musicClient}){
    _init();
  }

  _init() async {
    playlist = await musicClient.fetchPlaylistList(num: 5);
    notifyListeners();
  }

  refresh()  async {
    playlist = [];
    notifyListeners();
    _init();
  }
}