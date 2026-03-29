import '../../../../model/artist/artist.dart';
import '../../../../model/songs/song.dart';

class LibraryItemData {
  Song song;
  Artist artist;

  LibraryItemData({required this.song, required this.artist});
}
