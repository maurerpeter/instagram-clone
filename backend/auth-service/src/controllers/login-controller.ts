import { RequestHandler } from 'express';
import { sign } from 'jsonwebtoken';
import { config } from '../config';
import { getUserRepository } from '../database';

export const login: RequestHandler = async (request, response) => {
  try {
    const { email, password } = request.body;
    const userRepository = getUserRepository();
    const user = await userRepository.findOne({ email, password });
    if (user) {
      const token = sign({ username: email }, config.JWT_SECRET);
      response.json({ token });
    } else {
      response.status(401).send('Email/password combination is incorrect');
    }
  } catch (error) {
    console.error('[login]', error);
    response.sendStatus(500);
  }
};
