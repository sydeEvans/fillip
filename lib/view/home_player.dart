import 'package:flutter/material.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter_filip/provider/notifiers/play_button_notifier.dart';
import 'package:flutter_filip/provider/notifiers/progress_notifier.dart';
import 'package:flutter_filip/provider/notifiers/repeat_button_notifier.dart';
import 'package:flutter_filip/provider/player_manager.dart';
import 'package:provider/provider.dart';

class AddRemoveSongButtons extends StatelessWidget {
  const AddRemoveSongButtons({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Consumer<PlayerManager>(
        builder: (ctx, playerManager, child) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              FloatingActionButton(
                onPressed: playerManager.addSong,
                child: Icon(Icons.favorite),
              ),
              FloatingActionButton(
                onPressed: playerManager.removeSong,
                child: Icon(Icons.delete),
              ),
            ],
          );
        },
      ),
    );
  }
}

class AudioProgressBar extends StatelessWidget {
  const AudioProgressBar({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Consumer<PlayerManager>(builder: (ctx, playerManager, child) {
      return ValueListenableBuilder<ProgressBarState>(
        valueListenable: playerManager.progressNotifier,
        builder: (_, value, __) {
          return ProgressBar(
            progress: value.current,
            buffered: value.buffered,
            total: value.total,
            onSeek: playerManager.seek,
          );
        },
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
            RepeatButton(playerManager: playerManager,),
            PreviousSongButton(playerManager: playerManager,),
            PlayButton(playerManager: playerManager,),
            NextSongButton(playerManager: playerManager,),
            ShuffleButton(playerManager: playerManager,),
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
  Widget build(BuildContext context) {
    return ValueListenableBuilder<RepeatState>(
      valueListenable: playerManager.repeatButtonNotifier,
      builder: (context, value, child) {
        Icon icon;
        switch (value) {
          case RepeatState.off:
            icon = Icon(Icons.repeat, color: Colors.grey);
            break;
          case RepeatState.repeatSong:
            icon = Icon(Icons.repeat_one);
            break;
          case RepeatState.repeatPlaylist:
            icon = Icon(Icons.repeat);
            break;
        }
        return IconButton(
          icon: icon,
          onPressed: playerManager.onRepeatButtonPressed,
        );
      },
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
    return ValueListenableBuilder<bool>(
      valueListenable: playerManager.isFirstSongNotifier,
      builder: (_, isFirst, __) {
        return IconButton(
          icon: Icon(Icons.skip_previous),
          onPressed:
              (isFirst) ? null : playerManager.onPreviousSongButtonPressed,
        );
      },
    );
  }
}

class PlayButton extends StatelessWidget {

  const PlayButton({
    required this.playerManager,
  });

  final PlayerManager playerManager;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ButtonState>(
      valueListenable: playerManager.playButtonNotifier,
      builder: (_, value, __) {
        switch (value) {
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
      },
    );
  }
}

class NextSongButton extends StatelessWidget {


  const NextSongButton({
    required this.playerManager,
  });

  final PlayerManager playerManager;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: playerManager.isLastSongNotifier,
      builder: (_, isLast, __) {
        return IconButton(
          icon: Icon(Icons.skip_next),
          onPressed: (isLast) ? null : playerManager.onNextSongButtonPressed,
        );
      },
    );
  }
}

class ShuffleButton extends StatelessWidget {

  const ShuffleButton({
    required this.playerManager,
  });

  final PlayerManager playerManager;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: playerManager.isShuffleModeEnabledNotifier,
      builder: (context, isEnabled, child) {
        return IconButton(
          icon: (isEnabled)
              ? Icon(Icons.shuffle)
              : Icon(Icons.shuffle, color: Colors.grey),
          onPressed: playerManager.onShuffleButtonPressed,
        );
      },
    );
  }
}
