import 'package:flutter/material.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter_filip/provider/notifiers/play_button_state.dart';
import 'package:flutter_filip/provider/notifiers/repeat_state.dart';
import 'package:flutter_filip/provider/player_manager.dart';
import 'package:flutter_filip/res/app_svg.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/svg.dart';

class AddRemoveSongButtons extends StatelessWidget {
  const AddRemoveSongButtons({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    var playerManager = Provider.of<PlayerManager>(context);

    return Column(
      children: [
        Text(playerManager.currentSongTitle),
        // Padding(
        //   padding: const EdgeInsets.only(bottom: 20.0),
        //   child: Row(
        //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        //     children: [
        //       FloatingActionButton(
        //         onPressed: playerManager.addSong,
        //         child: Icon(Icons.favorite),
        //       ),
        //       FloatingActionButton(
        //         onPressed: playerManager.removeSong,
        //         child: Icon(Icons.delete),
        //       ),
        //     ],
        //   ),
        // ),
      ],
    );
  }
}

class AudioProgressBar extends StatelessWidget {
  const AudioProgressBar({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Consumer<PlayerManager>(builder: (ctx, playerManager, child) {
      return ProgressBar(
        progress: playerManager.progressBarState.current,
        buffered: playerManager.progressBarState.buffered,
        total: playerManager.progressBarState.total,
        onSeek: playerManager.seek,
      );
    });
  }
}

class AudioControlButtons extends StatelessWidget {
  const AudioControlButtons({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Consumer<PlayerManager>(builder: (ctx, playerManager, child) {
      return SizedBox(
        height: 60,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            RepeatButton(
              playerManager: playerManager,
            ),
            PreviousSongButton(
              playerManager: playerManager,
            ),
            PlayButton(
              playerManager: playerManager,
            ),
            NextSongButton(
              playerManager: playerManager,
            ),
            PlayListButton(
              playerManager: playerManager,
            ),
          ],
        ),
      );
    });
  }
}

class RepeatButton extends StatelessWidget {
  const RepeatButton({
    required this.playerManager,
  });

  final PlayerManager playerManager;

  @override
  Widget build(context) {
    late Icon icon;
    switch (playerManager.repeatState) {
      case RepeatState.repeatSong:
        icon = Icon(Icons.repeat_one);
        break;
      case RepeatState.repeatPlaylist:
        icon = Icon(Icons.repeat);
        break;
      case RepeatState.shuffle:
        icon = Icon(Icons.shuffle);
    }
    return IconButton(
      icon: icon,
      onPressed: playerManager.onRepeatButtonPressed,
    );
  }
}

class PreviousSongButton extends StatelessWidget {
  const PreviousSongButton({
    required this.playerManager,
  });

  final PlayerManager playerManager;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.skip_previous),
      onPressed: (playerManager.isFirstSong)
          ? null
          : playerManager.onPreviousSongButtonPressed,
    );
  }
}

class PlayButton extends StatelessWidget {
  const PlayButton({
    required this.playerManager,
  });

  final PlayerManager playerManager;

  @override
  Widget build(context) {
    switch (playerManager.playButtonState) {
      case ButtonState.loading:
        return Container(
          margin: EdgeInsets.all(8.0),
          width: 32.0,
          height: 32.0,
          child: CircularProgressIndicator(),
        );
      case ButtonState.paused:
        return IconButton(
          icon: Icon(Icons.play_arrow),
          iconSize: 32.0,
          onPressed: playerManager.play,
        );
      case ButtonState.playing:
        return IconButton(
          icon: Icon(Icons.pause),
          iconSize: 32.0,
          onPressed: playerManager.pause,
        );
    }
  }
}

class NextSongButton extends StatelessWidget {
  const NextSongButton({
    required this.playerManager,
  });

  final PlayerManager playerManager;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.skip_next),
      onPressed: (playerManager.isLastSong)
          ? null
          : playerManager.onNextSongButtonPressed,
    );
  }
}

final _sheetController = ScrollController();

class PlayListButton extends StatelessWidget {
  const PlayListButton({
    required this.playerManager,
  });

  final PlayerManager playerManager;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showBottomSheetDialog(context);
      },
      child: SvgPicture.asset(
        AppSvg.drawer,
        height: 20,
      ),
    );
  }


  void showBottomSheetDialog(BuildContext context) {

    double screenHeight = MediaQuery.of(context).size.height; // 获取屏幕高度
    double desiredHeightPercentage = 0.7; // 你希望弹窗高度占屏幕高度的百分比，例如90%

    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (BuildContext bc) {
          return Container(
            height: screenHeight * desiredHeightPercentage,
            color: Colors.white,
            child: SafeArea(
              child: Column(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      '当前播放列表',
                      style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: ListView.separated(
                        shrinkWrap: true, // 重要！必须配合使用
                        physics: NeverScrollableScrollPhysics(), // 禁止ListView本身的滚动
                        itemCount: playerManager.currentSongList.length,
                        itemBuilder: (context, index) {
                          // 这里构建你的列表项
                          return ListTile(
                            dense: true,
                            title: Text(playerManager.currentSongList[index].title),
                          );
                        },
                        separatorBuilder: (BuildContext context, int index) {
                          // 这里构建你的分割线
                          return Divider(
                            height: 1,
                            thickness: 1, // 分割线粗细
                            indent: 16, // 分割线左侧缩进
                            endIndent: 16, // 分割线右侧缩进
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
    );
  }
}
