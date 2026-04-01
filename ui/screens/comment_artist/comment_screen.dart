import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:w10/ui/widgets/comment/comment_tile.dart';
import '../artists/view_model/artists_view_model.dart';

class CommentScreen extends StatefulWidget {
  final String artistId;

  const CommentScreen({super.key, required this.artistId});

  @override
  State<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ArtistsViewModel>();

    return Scaffold(
      appBar: AppBar(title: const Text("Artist Detail")),

      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 10),
            const Text("Songs"),

            vm.songs.isEmpty
              ? const Text("No songs available")
              : ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: vm.songs.length,
                itemBuilder: (context, index) {
                  final song = vm.songs[index];
                  return ListTile(
                  title: Text(song.title),
                  subtitle: Text('Artist ID: ${song.artistId}'),
                  );
                },
              ),

            const SizedBox(height: 20),

            const Text("Comments"),

            vm.comments.isEmpty
                ? const Text("No comments yet")
                : ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: vm.comments.length,
                    itemBuilder: (context, index) {
                      return CommentTile(comment: vm.comments[index]);
                    },
                  ),
          ],
        ),
      ),

      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _controller,
                decoration: const InputDecoration(
                  hintText: "Write a comment...",
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.send),
              onPressed: () {
                final text = _controller.text;

                if (text.trim().isEmpty) return;

                vm.addComment(widget.artistId, text);

                _controller.clear();
              },
            ),
          ],
        ),
      ),
    );
  }
}