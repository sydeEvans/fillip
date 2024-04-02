import 'package:flutter/material.dart';
import 'package:flutter_filip/service/music_client.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';

import 'notifiers/play_button_state.dart';
import 'notifiers/progress_bar_state.dart';
import 'notifiers/repeat_state.dart';

class PlayerManager extends ChangeNotifier {
  var currentSongTitle = '';
  ProgressBarState progressBarState = ProgressBarState(
    current: Duration.zero,
    buffered: Duration.zero,
    total: Duration.zero,
  );
  RepeatState repeatState = RepeatState.repeatPlaylist;

  var isFirstSong = true;
  var isLastSong = true;
  var isShuffleModeEnabled = false;
  ButtonState playButtonState = ButtonState.paused;

  late final AudioPlayer _audioPlayer;
  late ConcatenatingAudioSource _playlist;

  late final MusicClient musicClient;

  PlayerManager({required this.musicClient}) {
    _init();
  }

  void _init() async {
    _audioPlayer = AudioPlayer();
    _setInitialPlaylist();
    _listenForChangesInPlayerState();
    _listenForChangesInPlayerPosition();
    _listenForChangesInBufferedPosition();
    _listenForChangesInTotalDuration();
    _listenForChangesInSequenceState();
  }

  _resetPlaylist(List<Music> resp) async {
    var list = resp.map((e) {
      return AudioSource.uri(Uri.parse(e.url), tag: MediaItem(
          id: e.url,
          title: e.basename,
          album: e.filename,
          artUri: Uri.parse('https://res.cloudinary.com/dp3ppkxo5/image/upload/v1693776174/spotify-astro/playlist_1_yci5uf.jpg'),
      ));
    }).toList();

    _playlist = ConcatenatingAudioSource(children: list);
    await _audioPlayer.setAudioSource(_playlist);
  }

  void _setInitialPlaylist() async {
    List<Music> resp = await musicClient.fetchMusicList(num: 10);
    _resetPlaylist(resp);
  }

  void replacePlaylist({ key = String }) async {
    var resp = await musicClient.searchMusic(key);

    _resetPlaylist(resp);
  }

  void _listenForChangesInPlayerState() {
    _audioPlayer.playerStateStream.listen((playerState) {
      final isPlaying = playerState.playing;
      final processingState = playerState.processingState;
      if (processingState == ProcessingState.loading ||
          processingState == ProcessingState.buffering) {
        playButtonState = ButtonState.loading;
      } else if (!isPlaying) {
        playButtonState = ButtonState.paused;
      } else if (processingState != ProcessingState.completed) {
        playButtonState = ButtonState.playing;
      } else {
        _audioPlayer.seek(Duration.zero);
        _audioPlayer.pause();
      }
    });
  }

  void _listenForChangesInPlayerPosition() {
    _audioPlayer.positionStream.listen((position) {
      final oldState = progressBarState;
      progressBarState = ProgressBarState(
        current: position,
        buffered: oldState.buffered,
        total: oldState.total,
      );

      notifyListeners();
    });
  }

  void _listenForChangesInBufferedPosition() {
    _audioPlayer.bufferedPositionStream.listen((bufferedPosition) {
      final oldState = progressBarState;
      progressBarState = ProgressBarState(
        current: oldState.current,
        buffered: bufferedPosition,
        total: oldState.total,
      );

      notifyListeners();
    });
  }

  void _listenForChangesInTotalDuration() {
    _audioPlayer.durationStream.listen((totalDuration) {
      final oldState = progressBarState;
      progressBarState = ProgressBarState(
        current: oldState.current,
        buffered: oldState.buffered,
        total: totalDuration ?? Duration.zero,
      );

      notifyListeners();
    });
  }

  void _listenForChangesInSequenceState() {
    _audioPlayer.sequenceStateStream.listen((sequenceState) {
      if (sequenceState == null) return;

      // update current song title
      final currentItem = sequenceState.currentSource;
      final title = currentItem?.tag as MediaItem;
      currentSongTitle = title.title ?? '';

      // update playlist
      final playlist = sequenceState.effectiveSequence;
      // final titles = playlist.map((item) => item.tag as String).toList();

      // update shuffle mode
      isShuffleModeEnabled = sequenceState.shuffleModeEnabled;

      // update previous and next buttons
      if (playlist.isEmpty || currentItem == null) {
        isFirstSong = true;
        isLastSong = true;
      } else {
        isFirstSong = playlist.first == currentItem;
        isLastSong = playlist.last == currentItem;
      }

      notifyListeners();
    });
  }

  void play() async {
    _audioPlayer.play();
  }

  void pause() {
    _audioPlayer.pause();
  }

  void seek(Duration position) {
    _audioPlayer.seek(position);
  }

  void dispose() {
    _audioPlayer.dispose();
  }

  void onRepeatButtonPressed() {
    // 计算得到枚举的下一个
    repeatState = RepeatState.values[(repeatState.index + 1) % RepeatState.values.length];

    switch (repeatState) {
      case RepeatState.off:
        _audioPlayer.setLoopMode(LoopMode.off);
        break;
      case RepeatState.repeatSong:
        _audioPlayer.setLoopMode(LoopMode.one);
        break;
      case RepeatState.repeatPlaylist:
        _audioPlayer.setLoopMode(LoopMode.all);
    }
  }

  void onPreviousSongButtonPressed() {
    _audioPlayer.seekToPrevious();
  }

  void onNextSongButtonPressed() {
    _audioPlayer.seekToNext();
  }

  void onShuffleButtonPressed() async {
    final enable = !_audioPlayer.shuffleModeEnabled;
    if (enable) {
      await _audioPlayer.shuffle();
    }
    await _audioPlayer.setShuffleModeEnabled(enable);
  }

  void addSong() {
    final songNumber = _playlist.length + 1;
    const prefix = 'https://www.soundhelix.com/examples/mp3';
    final song = Uri.parse('$prefix/SoundHelix-Song-$songNumber.mp3');
    _playlist.add(AudioSource.uri(song, tag: 'Song $songNumber'));
  }

  void removeSong() {
    final index = _playlist.length - 1;
    if (index < 0) return;
    _playlist.removeAt(index);
  }
}
