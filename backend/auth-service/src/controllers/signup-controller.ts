import { RequestHandler } from 'express';
import User from '../database/models/user';
import { getUserRepository } from '../database';
import fetch from 'node-fetch';
import { config } from '../config';

const registerToUserService = (email: string): void => {
  fetch(`${config.USER_SERVICE_URL}/private/users`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ email, username: email }),
  })
    .then((res) => {
      if (res.ok) {
        return res;
      } else {
        throw new Error(res.statusText);
      }
    })
    .then((res) => res.json())
    .then((res) =>
      console.log(`[signUp] registered user${JSON.stringify(res)}`)
    );
  return;
};

export const signUp: RequestHandler = async (request, response) => {
  try {
    const { email, password } = request.body;
    const userRepository = getUserRepository();
    const user = await userRepository.findOne({ email });
    if (user) {
      response.status(400).send('Email/password combination already exists');
    } else {
      const newUser = new User({ email, password });
      const createdUser = await userRepository.save(newUser);
      if (!createdUser) {
        response.sendStatus(500);
      } else {
        registerToUserService(email);
        response.sendStatus(204);
      }
    }
  } catch (error) {
    console.error('[signUp]', error);
    response.sendStatus(500);
  }
};
