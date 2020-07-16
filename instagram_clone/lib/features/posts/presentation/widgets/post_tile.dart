import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_clone/features/comment/presentation/bloc/comment_bloc.dart';
import 'package:instagram_clone/features/comment/presentation/pages/comments_page.dart';
import 'package:instagram_clone/features/posts/domain/entities/post.dart';
import 'package:instagram_clone/features/posts/presentation/widgets/video_player.dart';
import 'package:instagram_clone/features/reaction/presentation/bloc/reaction_bloc.dart';
import 'package:video_player/video_player.dart';
import 'package:meta/meta.dart';

class PostTile extends StatefulWidget {
  final Post post;
  final ReactionBloc reactionBloc;
  final CommentBloc commentBloc;

  const PostTile({
    Key key,
    @required this.post,
    @required this.reactionBloc,
    @required this.commentBloc,
  }) : super(key: key);

  @override
  _PostTileState createState() => _PostTileState();
}

class _PostTileState extends State<PostTile> {
  final _commentTextController = TextEditingController();
  Post get _post => widget.post;
  ReactionBloc get _reactionBloc => widget.reactionBloc;
  CommentBloc get _commentBloc => widget.commentBloc;

  bool isWritingComment;
  bool isHappy;
  bool isSad;

  @override
  void initState() {
    isWritingComment = false;
    isHappy = false;
    isSad = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CommentBloc, CommentState>(
      bloc: _commentBloc,
      builder: (context, state) {
        return ListTile(
          title: Card(
            elevation: 5.0,
            child: Container(
              padding: const EdgeInsets.all(10.0),
              margin: const EdgeInsets.all(10.0),
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      CircleAvatar(
                        child: _post.user.profilePictureUrl == null
                            ? const Text('No image')
                            : Image.network(
                                _post.user.profilePictureUrl,
                              ),
                      ),
                      Text(_post.user.username),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: _post.type == 'video'
                        ? VideoPlayerWidget(
                            videoPlayerController:
                                VideoPlayerController.network(_post.mediaUrl),
                            looping: false,
                          )
                        : AspectRatio(
                            aspectRatio: 1.0,
                            child: Image.network(_post.mediaUrl),
                          ),
                  ),
                  Row(
                    children: <Widget>[
                      IconButton(
                        icon: Icon(Icons.mood),
                        onPressed: () {
                          _reactionBloc.add(
                            ReactToPost(postId: _post.id, type: 'happy'),
                          );
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.mood_bad),
                        onPressed: () {
                          _reactionBloc.add(
                            ReactToPost(postId: _post.id, type: 'sad'),
                          );
                        },
                      ),
                      IconButton(
                          icon: Icon(Icons.comment),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CommentsPage(
                                  commentBloc: _commentBloc
                                    ..add(GetComments(postId: _post.id)),
                                  postId: _post.id,
                                ),
                              ),
                            );
                            // setState(() {
                            //   isWritingComment = !isWritingComment;
                            // });
                          }),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(1.0),
                        child: Text(_post.description),
                      ),
                    ],
                  ),
                  // if (isWritingComment) ...[
                  //   TextField(
                  //     controller: _commentTextController,
                  //     onSubmitted: (String comment) {
                  //       _commentBloc.add(
                  //         CommentToPost(postId: _post.id, content: comment),
                  //       );
                  //     },
                  //   ),
                  // ]
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
