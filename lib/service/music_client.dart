import 'dart:convert';
import 'package:http/http.dart' as http;

class Music {
  final String filename;
  final String basename;
  final String lastmod;
  final int size;
  final String type;
  final String etag;
  final String mime;
  String url = '';

  Music({
    required this.filename,
    required this.basename,
    required this.lastmod,
    required this.size,
    required this.type,
    required this.etag,
    required this.mime,
  });

  factory Music.fromJson(Map<String, dynamic> json) {
    return Music(
      filename: json['filename'],
      basename: json['basename'],
      lastmod: json['lastmod'],
      size: json['size'],
      type: json['type'],
      etag: json['etag'],
      mime: json['mime'],
    );
  }
}

class Playlist {
  final String filename;
  final String basename;
  final String lastmod;
  final int size;
  final String type;
  final String? etag;

  Playlist({
    required this.filename,
    required this.basename,
    required this.lastmod,
    required this.size,
    required this.type,
    this.etag,
  });

  factory Playlist.fromJson(Map<String, dynamic> json) {
    return Playlist(
      filename: json['filename'],
      basename: json['basename'],
      lastmod: json['lastmod'],
      size: json['size'],
      type: json['type'],
      etag: json['etag'],
    );
  }
}

class MusicClient {
  final String apiUrl = "https://alist-music.deno.dev/api/audio";
  final int maxRetries = 10; // 可以定义一个合适的最大重试次数

  // 请求获取音乐列表，增加了重试逻辑
  Future<List<Music>> fetchMusicList({int? num}) async {
    Uri uri = Uri.parse('$apiUrl/randomFile');
    if (num != null) {
      uri = uri.replace(queryParameters: {'num': num.toString()});
    }

    int retries = 0;
    while(retries < maxRetries) {
      try {
        print('Attempting to fetch music list (Attempt: ${retries + 1})'); // 日志记录
        final response = await http.get(uri);
        return _processResponse(response);
      } catch (e) {
        print('Error fetching music list: $e'); // 日志记录错误
        retries++; // 请求失败，增加重试次数
        if(retries >= maxRetries) {
          throw Exception('Failed to load music after multiple attempts: $e');
        }
        // 可能会增加一小段延时来避免立即重试，这取决于实际情况
        await Future.delayed(Duration(seconds: 1));
      }
    }
    return []; // 如果所有重试尝试都失败了，返回空的音乐列表
  }

  // 请求搜索音乐
  Future<List<Music>> searchMusic(String query) async {
    Uri uri = Uri.parse('$apiUrl/search').replace(queryParameters: {'q': query});

    final response = await http.get(uri);
    return _processResponse(response);
  }

  // 请求获取歌单列表
  Future<List<Playlist>> fetchPlaylistList({int? num}) async {
    Uri uri = Uri.parse('$apiUrl/randomDir');
    if (num != null) {
      uri = uri.replace(queryParameters: {'num': num.toString()});
    }

    final response = await http.get(uri);
    Map<String, dynamic> result = json.decode(response.body);
    if (response.statusCode == 200 && result['success']) {
      List<dynamic> data = result['data'];
      return data.map<Playlist>((json) => Playlist.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load playlists');
    }
  }

  // 处理响应并解析音乐列表
  List<Music> _processResponse(http.Response response) {
    Map<String, dynamic> result = json.decode(response.body);
    if (response.statusCode == 200 && result['success']) {
      List<dynamic> data = result['data'];
      return data
          .map<Music>((json) => Music.fromJson(json))
          .map((e) {
            e.url = 'http://evans.x3322.net:6788/d${e.filename}';
            return e;
          })
          .toList();
    } else {
      throw Exception('Failed to load music');
    }
  }
}