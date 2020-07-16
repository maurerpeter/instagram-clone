import { decode } from 'jsonwebtoken';
import { Request } from 'express';

export const getUsername = (request: Request): string => {
  if (request.headers.authorization) {
    const token = request.headers.authorization.split(' ')[1];
    const { username } = decode(token) as {
      username: string;
    };
    return username;
  }
  return '';
};
