import 'package:w10/model/comment/comment.dart';
import 'package:w10/model/songs/song.dart';

import '../../../model/artist/artist.dart';
 

abstract class ArtistRepository {
  Future<List<Artist>> fetchArtists({bool forceFetch = false});
  
  Future<Artist?> fetchArtistById(String id);

  Future<List<Song>> getSongsByArtist(String artistId);

  Future<List<Comment>> getComments(String artistId);

  Future<void> addComment(String artistId, String text);
}
