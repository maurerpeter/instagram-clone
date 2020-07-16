import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:instagram_clone/features/users/domain/entities/user.dart';

import '../../../../core/error/failures.dart';

abstract class UserRepository {
  Future<Either<Failure, List<User>>> getUsers(String username);

  Future<Either<Failure, List<User>>> getFollowedUsers(String username);

  Future<Either<Failure, Unit>> updateProfilePicture(File picture);

  Future<Either<Failure, Unit>> followUser(String id);

  Future<Either<Failure, Unit>> unfollowUser(String id);
}
