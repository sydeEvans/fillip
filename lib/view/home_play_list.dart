import 'package:flutter/material.dart';
import 'package:flutter_filip/provider/player_manager.dart';
import 'package:flutter_filip/provider/playlist_provider.dart';
import 'package:provider/provider.dart';

class HomePlayList extends StatelessWidget {
  const HomePlayList({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var playlistProvider = Provider.of<PlaylistProvider>(context);
    var playerManager = Provider.of<PlayerManager>(context);

    var playlist = playlistProvider.playlist;
    var tileList = playlist.map((e){
      List<String> parts = e.filename.split('/'); // 使用 '/' 分割字符串
      String lastTwo = '${parts[parts.length - 2]}-${parts[parts.length - 1]}';
      return lastTwo;
    });

    return SizedBox(
      child: Column(
        children: [
          SizedBox(
            height: 20,
          ),
          Row(
            children: [
              Text(
                '歌单',
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Spacer(),
              InkWell(
                onTap: () => playlistProvider.refresh(),
                child: Text(
                  '刷新',
                  style: TextStyle(
                      color: Colors.grey, fontWeight: FontWeight.bold),
                ),
              )
            ],
          ),
          playlist.isEmpty
              ? Container(
                  margin: EdgeInsets.all(8.0),
                  width: 32.0,
                  height: 32.0,
                  child: CircularProgressIndicator(),
                )
              : Column(
                  children: [
                    for (int i = 0; i < playlist.length; i++)
                      ListTile(
                        onTap: () {
                          playerManager.replacePlaylist(key: playlist[i].filename);
                        },
                        contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 0),
                        dense: true,
                        title: Text(
                          tileList.elementAt(i),
                          style: TextStyle(fontSize: 14),
                        ),
                        trailing: Icon(Icons.play_arrow),
                      )
                  ],
                ),
        ],
      ),
    );
  }
}
