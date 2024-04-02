import 'package:flutter/material.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter_filip/provider/notifiers/play_button_state.dart';
import 'package:flutter_filip/provider/notifiers/repeat_state.dart';
import 'package:flutter_filip/provider/player_manager.dart';
import 'package:provider/provider.dart';

class AddRemoveSongButtons extends StatelessWidget {
  const AddRemoveSongButtons({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    var playerManager = Provider.of<PlayerManager>(context);

    return Column(
      children: [
        Text(playerManager.currentSongTitle),
        Padding(
          padding: const EdgeInsets.only(bottom: 20.0),
          child: Row(
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
          ),
        ),
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
            ShuffleButton(
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

class ShuffleButton extends StatelessWidget {
  const ShuffleButton({
    required this.playerManager,
  });

  final PlayerManager playerManager;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: (playerManager.isShuffleModeEnabled)
          ? Icon(Icons.shuffle)
          : Icon(Icons.shuffle, color: Colors.grey),
      onPressed: playerManager.onShuffleButtonPressed,
    );
  }
}
