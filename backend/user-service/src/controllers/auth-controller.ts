import { RequestHandler } from 'express';
import { config } from '../config';
import { verify } from 'jsonwebtoken';
import { getUserRepository } from '../database';

const isString = (value: unknown): value is string => typeof value === 'string';

export const authorize: RequestHandler = async (request, response, next) => {
  const { authorization } = request.headers;
  let token: string | undefined;
  if (authorization) {
    token = authorization.split(' ')[1];
  }
  if (!token) {
    response
      .status(401)
      .send('Authorization JWT token is missing from headers');
    return;
  }
  verify(token, config.JWT_SECRET, async (_, payload) => {
    if (payload) {
      const { username } = payload as { username: string };
      if (isString(username)) {
        const userRepository = getUserRepository();
        const user = await userRepository.findOne({ username });
        if (user) {
          next();
          return;
        }
      }
    }
    response.status(401).send('You are not logged in properly');
  });
};
