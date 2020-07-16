import { RequestHandler } from 'express';
import { getMessageRepository } from '../database';
import { getUsername } from './util';

interface GetMessagesQueryParams {
  limit?: string;
  offset?: string;
  username?: string;
}

export const getMessages: RequestHandler = async (request, response) => {
  try {
    const { username, limit, offset } = request.query as GetMessagesQueryParams;
    const fromUsername = getUsername(request);
    const messageRepository = getMessageRepository();
    const messages = await messageRepository.findByUsersWithPagination({
      limit,
      offset,
      fromUsername,
      toUsername: username,
    });
    response.json(messages.map((message) => message.toJson()));
  } catch (error) {
    console.error(error);
    response.sendStatus(500);
  }
};
