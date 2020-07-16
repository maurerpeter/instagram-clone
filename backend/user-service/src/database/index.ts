import 'reflect-metadata';
import { createConnection, Connection, getConnection } from 'typeorm';
import User from './models/user';
import { UserRepository } from './repositories/user-repository';
import Follow from './models/follow';
import { FollowRepository } from './repositories/follow-repository';

export const createDatabaseConnection = (
  connectionUrl: string
): Promise<Connection> =>
  createConnection({
    type: 'postgres',
    url: connectionUrl,
    entities: [User, Follow],
    synchronize: true,
    logging: false,
    dropSchema: false,
  });

export const getUserRepository = (): UserRepository =>
  getConnection().getCustomRepository(UserRepository);

export const getFollowRepository = (): FollowRepository =>
  getConnection().getCustomRepository(FollowRepository);
