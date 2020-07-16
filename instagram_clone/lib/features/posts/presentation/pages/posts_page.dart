import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_clone/core/widgets/loading_indicator.dart';
import 'package:instagram_clone/features/comment/presentation/bloc/comment_bloc.dart';
import 'package:instagram_clone/features/posts/presentation/widgets/post_tile.dart';
import 'package:instagram_clone/features/reaction/presentation/bloc/reaction_bloc.dart';
import 'package:video_player/video_player.dart';

import 'package:instagram_clone/features/posts/domain/entities/post.dart';
import 'package:instagram_clone/features/posts/presentation/bloc/post_bloc.dart';
import 'package:instagram_clone/features/posts/presentation/widgets/video_player.dart';
import 'package:meta/meta.dart';

class PostsPage extends StatefulWidget {
  final PostBloc postBloc;
  final ReactionBloc reactionBloc;
  final CommentBloc commentBloc;

  const PostsPage({
    Key key,
    @required this.postBloc,
    @required this.reactionBloc,
    @required this.commentBloc,
  }) : super(key: key);

  @override
  _PostsPageState createState() => _PostsPageState();
}

class _PostsPageState extends State<PostsPage> {
  final List<Post> posts = [];
  final int _limit = 10;
  final ScrollController _scrollController = ScrollController();
  bool isLoading = false;
  int currentOffset;

  PostBloc get _postBloc => widget.postBloc;
  ReactionBloc get _reactionBloc => widget.reactionBloc;
  CommentBloc get _commentBloc => widget.commentBloc;

  @override
  void initState() {
    currentOffset = 0;
    _postBloc.add(GetPosts(limit: _limit, offset: currentOffset));
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
              _scrollController.position.maxScrollExtent &&
          posts.length % _limit == 0) {
        currentOffset = posts.length ~/ _limit;
        _postBloc.add(GetPosts(limit: _limit, offset: currentOffset));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<PostBloc, PostState>(
          listener: (context, state) {
            if (state is GetPostsError) {
              Scaffold.of(context).showSnackBar(
                SnackBar(
                  content: Text('${state.message}'),
                  backgroundColor: Colors.red,
                ),
              );
            } else //
            if (state is PostsLoaded) {
              setState(() {
                isLoading = false;
                posts.addAll(state.posts);
              });
            } else //
            if (state is GetPostsLoading) {
              setState(() {
                isLoading = true;
              });
            }
          },
        ),
        BlocListener<ReactionBloc, ReactionState>(
          listener: (context, state) {
            if (state is CreateReactionError) {
              Scaffold.of(context).showSnackBar(
                SnackBar(
                  content: Text('${state.message}'),
                  backgroundColor: Colors.red,
                ),
              );
            } else //
            if (state is ReactionCreated) {
              Scaffold.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Reaction sent successfully'),
                  backgroundColor: Colors.green,
                ),
              );
            }
          },
        ),
      ],
      child: ListView.builder(
        controller: _scrollController,
        itemCount: posts.length + 1,
        itemBuilder: (context, index) {
          if (index == posts.length) {
            return _buildLoadingIndicator();
          }
          final Post post = posts[index];
          return PostTile(
            post: post,
            reactionBloc: _reactionBloc,
            commentBloc: _commentBloc,
          );
        },
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return Opacity(
      opacity: isLoading ? 1.0 : 0.0,
      child: LoadingIndicator(),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
