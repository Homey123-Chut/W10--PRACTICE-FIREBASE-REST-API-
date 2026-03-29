import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../model/songs/song.dart';
import '../../dtos/song_dto.dart';
import 'song_repository.dart';

class SongRepositoryFirebase extends SongRepository {
  final Uri songsUri = Uri.https(
    'w9-database-c101d-default-rtdb.asia-southeast1.firebasedatabase.app',
    '/songs.json',
  );

  @override
  Future<List<Song>> fetchSongs() async {
    final http.Response response = await http.get(songsUri);

    if (response.statusCode == 200) {
      // 1 - Send the retrieved list of songs
      Map<String, dynamic> songJson = json.decode(response.body);

      List<Song> result = [];
      for (final entry in songJson.entries) {
        result.add(SongDto.fromJson(entry.key, entry.value));
      }
      return result;
    } else {
      // 2- Throw expcetion if any issue
      throw Exception('Failed to load posts');
    }
  }

  @override
  Future<Song?> fetchSongById(String id) async {
    final Uri songUri = Uri.https(
      'w9-database-c101d-default-rtdb.asia-southeast1.firebasedatabase.app',
      '/songs/$id.json',
    );

    final http.Response response = await http.get(songUri);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      if (data == null) return null;

      return SongDto.fromJson(id, data);
    } else {
      throw Exception('Failed to load song');
    }
  }

  @override
  Future<void> likeSong(String songId, int likes) async {
    final Uri likeUri = Uri.https(
      'w9-database-c101d-default-rtdb.asia-southeast1.firebasedatabase.app',
      '/songs/$songId/like.json',
    );

    final http.Response response = await http.patch(
      likeUri,
      body: json.encode(likes),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to like the song');
    }
}
}