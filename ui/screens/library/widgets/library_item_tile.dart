import 'package:flutter/material.dart';
import '../view_model/library_item_data.dart';

class LibraryItemTile extends StatefulWidget {
  const LibraryItemTile({
    super.key,
    required this.data,
    required this.isPlaying,
    required this.onTap,
    required this.onLike,
  });

  final LibraryItemData data;
  final bool isPlaying;
  final VoidCallback onTap;
  final VoidCallback onLike;

  @override
  State<LibraryItemTile> createState() => _LibraryItemTileState();
}

class _LibraryItemTileState extends State<LibraryItemTile> {
  bool isLiked = false;

  void onLikePressed() {
    if (!isLiked) {
      setState(() {
        isLiked = true;
      });

      widget.onLike();
    }
  }
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
        ),
        child: ListTile(
          onTap: widget.onTap,
          title: Text(widget.data.song.title),
          subtitle: Row(
            children: [
              Text("${widget.data.song.duration.inMinutes} mins"),
              SizedBox(width: 20),
              Text("${widget.data.song.like} likes"),
              SizedBox(width: 20),
              Text(widget.data.artist.name),
              SizedBox(width: 20),
              Text(widget.data.artist.genre),
              SizedBox(width: 20),

            ],
          ),
          leading: CircleAvatar(
            backgroundImage: NetworkImage(widget.data.song.imageUrl.toString()),
          ),
           trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: Icon(
                  Icons.favorite,
                  color: isLiked ? Colors.red : Colors.grey,
                ),
                onPressed: () {
                  onLikePressed();
                },
              ),
              SizedBox(width: 10),
              if (widget.isPlaying)
                Text(
                  "Playing",
                  style: TextStyle(color: Colors.amber),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
