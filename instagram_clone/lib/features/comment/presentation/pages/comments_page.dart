import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_clone/core/widgets/loading_indicator.dart';
import 'package:meta/meta.dart';

import 'package:instagram_clone/features/comment/presentation/bloc/comment_bloc.dart';

class CommentsPage extends StatelessWidget {
  final CommentBloc commentBloc;
  final String postId;
  final _commentTextController = TextEditingController();

  CommentsPage({
    Key key,
    @required this.commentBloc,
    @required this.postId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Comments'),
      ),
      body: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              Flexible(
                child: BlocConsumer<CommentBloc, CommentState>(
                  bloc: commentBloc,
                  listener: (context, state) {
                    if (state is CreateCommentError) {
                      Scaffold.of(context).showSnackBar(
                        SnackBar(
                          content: Text('${state.message}'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    } else //
                    if (state is CommentCreated) {
                      if (state is CommentCreated) {
                        commentBloc.add(GetComments(postId: postId));
                      }
                    }
                  },
                  builder: (context, state) {
                    if (state is GetCommentsLoading) {
                      return LoadingIndicator();
                    } else //
                    if (state is CommentsLoaded) {
                      return ListView.builder(
                        itemCount: state.comments.length,
                        itemBuilder: (context, index) {
                          final comment = state.comments[index];
                          return ListTile(
                            leading: CircleAvatar(
                              child: comment.from.profilePictureUrl == null
                                  ? const Text('No image')
                                  : Image.network(
                                      comment.from.profilePictureUrl),
                            ),
                            trailing: Container(
                              width: 300,
                              child: Text(
                                '${comment.from.username}: ${comment.content}',
                                overflow: TextOverflow.ellipsis,
                                maxLines: 3,
                              ),
                            ),
                          );
                        },
                      );
                    }
                    return Container();
                  },
                ),
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: _commentTextController,
                      onSubmitted: (String comment) {
                        commentBloc.add(
                          CommentToPost(postId: postId, content: comment),
                        );
                      },
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Write your comment...'),
                    ),
                  ),
                  Container(
                    width: 50.0,
                    child: IconButton(
                      icon: Icon(Icons.send),
                      onPressed: () {
                        commentBloc.add(
                          CommentToPost(
                            postId: postId,
                            content: _commentTextController.text,
                          ),
                        );
                        _commentTextController.clear();
                        FocusScope.of(context).unfocus();
                      },
                    ),
                  )
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
