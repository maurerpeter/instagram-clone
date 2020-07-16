import 'reflect-metadata';
import { createConnection, Connection, getConnection } from 'typeorm';
import User from './models/user';
import { UserRepository } from './repositories/user-repository';
import Follow from './models/follow';
import { FollowRepository } from './repositories/follow-repository';
import { MessageRepository } from './repositories/message-repository';
import Message from './models/message';

export const createDatabaseConnection = (
  connectionUrl: string
): Promise<Connection> =>
  createConnection({
    type: 'postgres',
    url: connectionUrl,
    entities: [User, Follow, Message],
    synchronize: true,
    logging: false,
    dropSchema: false,
  });

export const getUserRepository = (): UserRepository =>
  getConnection().getCustomRepository(UserRepository);

export const getFollowRepository = (): FollowRepository =>
  getConnection().getCustomRepository(FollowRepository);

export const getMessageRepository = (): MessageRepository =>
  getConnection().getCustomRepository(MessageRepository);
