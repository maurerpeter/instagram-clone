import 'package:dartz/dartz.dart';
import 'package:instagram_clone/core/error/exceptions.dart';
import 'package:instagram_clone/core/error/failures.dart';
import 'package:instagram_clone/features/auth/domain/entities/jwt_token.dart';
import 'package:instagram_clone/features/auth/domain/repositories/auth_repository.dart';
import 'package:instagram_clone/features/reaction/data/datasources/reaction_remote_data_source.dart';
import 'package:instagram_clone/features/reaction/domain/entities/reaction.dart';
import 'package:instagram_clone/features/reaction/domain/repositories/reaction_repository.dart';
import 'package:meta/meta.dart';

class ReactionRepositoryImpl implements ReactionRepository {
  final ReactionRemoteDataSource remoteDataSource;
  final AuthRepository authRepository;

  ReactionRepositoryImpl({
    @required this.remoteDataSource,
    @required this.authRepository,
  });

  @override
  Future<Either<Failure, Unit>> createReaction({
    String postId,
    String type,
  }) async {
    try {
      final jwtToken = await _getJwtToken();
      await remoteDataSource.createReaction(
        jwtToken: jwtToken,
        postId: postId,
        type: type,
      );
      return Right(unit);
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteReaction(String id) async {
    try {
      final jwtToken = await _getJwtToken();
      await remoteDataSource.deleteReaction(jwtToken: jwtToken, id: id);
      return Right(unit);
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<Reaction>>> getReactions({String postId}) async {
    try {
      final jwtToken = await _getJwtToken();
      final List<Reaction> reactions = await remoteDataSource.getReactions(
        jwtToken: jwtToken,
        postId: postId,
      );
      return Right(reactions);
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  /// Throws [ServerException] when no token is found
  Future<JwtToken> _getJwtToken() async {
    final failureOrToken = await authRepository.getToken();
    final jwtToken = failureOrToken.fold(
      (_) {
        throw ServerException();
      },
      (token) => token,
    );
    return jwtToken;
  }
}
