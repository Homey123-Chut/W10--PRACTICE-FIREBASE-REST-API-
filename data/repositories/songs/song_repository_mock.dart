// song_repository_mock.dart

import '../../../model/songs/song.dart';
import 'song_repository.dart';

class SongRepositoryMock implements SongRepository {
  final List<Song> _songs = [
    Song(
      id: "song_1",
      title: "Time to Rise",
      duration: Duration(milliseconds: 210000),
      artistId: "artist_1",
      imageUrl: Uri.parse("https://images.unsplash.com/photo-1470225620780-dba8ba36b745"),
      like: 2,
    ),
    Song(
      id: "song_2",
      title: "Khmer & Ronan Bloods",
      duration: Duration(milliseconds: 185000),
      artistId: "artist_1",
      imageUrl: Uri.parse("https://images.unsplash.com/photo-1501386761578-eac5c94b800a"),
      like: 3,
    ),
    ];


  @override
  Future<List<Song>> fetchSongs() async {
    return Future.delayed(Duration(seconds: 4), () {
      throw _songs;
    });
  }

  @override
  Future<Song?> fetchSongById(String id) async {
    return Future.delayed(Duration(seconds: 4), () {
      return _songs.firstWhere(
        (song) => song.id == id,
        orElse: () => throw Exception("No song with id $id in the database"),
      );
    });
  }
}
