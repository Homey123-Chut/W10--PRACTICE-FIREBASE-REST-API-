import 'package:flutter/material.dart';
import '../../../../data/repositories/artist/artist_repository.dart';
import '../../../../data/repositories/songs/song_repository.dart';
import '../../../../model/artist/artist.dart';
import '../../../states/player_state.dart';
import '../../../../model/songs/song.dart';
import '../../../utils/async_value.dart';
import 'library_item_data.dart';

class LibraryViewModel extends ChangeNotifier {
  final SongRepository songRepository;
  final ArtistRepository artistRepository;

  final PlayerState playerState;

  AsyncValue<List<LibraryItemData>> data = AsyncValue.loading();
  
  List<LibraryItemData>? _cache;

  LibraryViewModel({
    required this.songRepository,
    required this.playerState,
    required this.artistRepository,
  }) {
    playerState.addListener(notifyListeners);

    // init
    _init();
  }

  @override
  void dispose() {
    playerState.removeListener(notifyListeners);
    super.dispose();
  }

  void _init() async {
    fetchSong();
  }

  void fetchSong({bool forceRefresh = false}) async {
    if (!forceRefresh && _cache != null) {
      data = AsyncValue.success(_cache!);
      notifyListeners();
      return;
    }
    // 1- Loading state
    data = AsyncValue.loading();
    notifyListeners();

    try {
      // 1- Fetch songs
      List<Song> songs = await songRepository.fetchSongs();

      // 2- Fethc artist
      List<Artist> artists = await artistRepository.fetchArtists();

      // 3- Create the mapping artistid-> artist
      Map<String, Artist> mapArtist = {};
      for (Artist artist in artists) {
        mapArtist[artist.id] = artist;
      }

      List<LibraryItemData> data = songs
          .map(
            (song) =>
                LibraryItemData(song: song, artist: mapArtist[song.artistId]!),
          )
          .toList();

          _cache = data;

      this.data = AsyncValue.success(data);

    } catch (e) {
      // 3- Fetch is unsucessfull
      data = AsyncValue.error(e);
    }
    notifyListeners();
  }

  void clearCache() {
  _cache = null;
  }

  Future<void> refreshSongs() async {
  clearCache();
  fetchSong(forceRefresh: true);
}

  Future<void> likeSong(LibraryItemData data) async {
    final oldLike = data.song.like;
    final newSong = Song(
      id: data.song.id,
      title: data.song.title,
      artistId: data.song.artistId,
      duration: data.song.duration,
      imageUrl: data.song.imageUrl,
      like: oldLike + 1,
    );
    final oldSong = data.song;
    try {
      data.song = newSong;
      notifyListeners();

      await songRepository.likeSong(data.song.id, data.song.like);
    } catch (e) {

      data.song = oldSong;
      notifyListeners();
    }
  }

  bool isSongPlaying(Song song) => playerState.currentSong == song;

  void start(Song song) => playerState.start(song);
  void stop(Song song) => playerState.stop();
}
