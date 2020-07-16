import 'reflect-metadata';
import { createConnection, Connection, getConnection } from 'typeorm';
import User from './models/user';
import { UserRepository } from './repositories/user-repository';
import Post from './models/post';
import { PostRepository } from './repositories/post-repository';
import Follow from './models/follow';
import { FollowRepository } from './repositories/follow-repository';
import Reaction from './models/reaction';
import { ReactionRepository } from './repositories/reaction-repository';
import Comment from './models/comment';
import { CommentRepository } from './repositories/comment-repository';

export const createDatabaseConnection = (
  connectionUrl: string
): Promise<Connection> =>
  createConnection({
    type: 'postgres',
    url: connectionUrl,
    entities: [User, Post, Follow, Reaction, Comment],
    synchronize: true,
    logging: false,
    dropSchema: false,
  });

export const getUserRepository = (): UserRepository =>
  getConnection().getCustomRepository(UserRepository);

export const getFollowRepository = (): FollowRepository =>
  getConnection().getCustomRepository(FollowRepository);

export const getPostRepository = (): PostRepository =>
  getConnection().getCustomRepository(PostRepository);

export const getReactionRepository = (): ReactionRepository =>
  getConnection().getCustomRepository(ReactionRepository);

export const getCommentRepository = (): CommentRepository =>
  getConnection().getCustomRepository(CommentRepository);
