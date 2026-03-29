import 'package:flutter/material.dart';
import 'package:w10/model/comment/comment.dart';
import 'package:w10/model/songs/song.dart';
import '../../../../data/repositories/artist/artist_repository.dart';
import '../../../../model/artist/artist.dart';
import '../../../utils/async_value.dart';


class ArtistsViewModel extends ChangeNotifier {
  final ArtistRepository artistRepository;

  AsyncValue<List<Artist>> artistsValue = AsyncValue.loading();
  
  List<Song> songs = [];
  List<Comment> comments = [];

  ArtistsViewModel({required this.artistRepository}) {
    _init();
  }

  void _init() async {
    fetchArtists();
  }

  void fetchArtists() async {
    // 1- Loading state
    artistsValue = AsyncValue.loading();
    notifyListeners();

    try {
      // 2- Fetch is successfull
      List<Artist> artists = await artistRepository.fetchArtists();
      artistsValue = AsyncValue.success(artists);
    } catch (e) {
      // 3- Fetch is unsucessfull
      artistsValue = AsyncValue.error(e);
    }
    notifyListeners();
  }
  Future<void> fetchArtistSongs(String artistId) async {
      songs = await artistRepository.getSongsByArtist(artistId);
    notifyListeners();
  }

  Future<void> fetchArtistComments(String artistId) async {
    comments = await artistRepository.getComments(artistId);
    notifyListeners();
  }

  Future<void> addComment(String artistId, String text) async {
    await artistRepository.addComment(artistId, text);
    comments = await artistRepository.getComments(artistId);

    notifyListeners();
  }

}
