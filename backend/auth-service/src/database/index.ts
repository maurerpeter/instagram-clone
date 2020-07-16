import 'reflect-metadata';
import { createConnection, Connection, getConnection } from 'typeorm';
import User from './models/user';
import { UserRepository } from './repositories/user-repository';

export const createDatabaseConnection = (
  connectionUrl: string
): Promise<Connection> =>
  createConnection({
    type: 'postgres',
    url: connectionUrl,
    entities: [User],
    synchronize: true,
    logging: false,
    dropSchema: false,
  });

export const getUserRepository = (): UserRepository =>
  getConnection().getCustomRepository(UserRepository);
