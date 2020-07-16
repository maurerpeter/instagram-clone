import 'package:dartz/dartz.dart';
import 'package:instagram_clone/core/error/failures.dart';
import 'package:instagram_clone/features/reaction/domain/entities/reaction.dart';
import 'package:meta/meta.dart';

abstract class ReactionRepository {
  Future<Either<Failure, List<Reaction>>> getReactions({
    @required String postId,
  });

  Future<Either<Failure, Unit>> createReaction({
    @required String postId,
    @required String type,
  });

  Future<Either<Failure, Unit>> deleteReaction(String id);
}
