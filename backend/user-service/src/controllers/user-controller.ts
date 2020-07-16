import { RequestHandler } from 'express';
import { getUserRepository, getFollowRepository } from '../database';
import User, { UserProps } from '../database/models/user';
import { getUsername } from './util';
import Follow from '../database/models/follow';
import { MessageBroker } from '../message-broker/message-broker';
import multer from 'multer';
import { createReadStream, createWriteStream, unlinkSync } from 'fs';
import { config } from '../config';

const upload = multer({ dest: 'uploads/' });

export const getUsers: RequestHandler = async (request, response) => {
  try {
    const { followedBy, username, excludeSelf } = request.query;
    const usernameOfRequester = getUsername(request);
    const userRepository = getUserRepository();
    const users = await userRepository.findByFollower(followedBy as string);
    response.json(
      users
        .map((user) => user.toJson())
        .filter((user) =>
          username ? user.username.includes(username as string) : true
        )
        .filter((user) =>
          excludeSelf === 'true' ? user.username !== usernameOfRequester : true
        )
    );
  } catch (error) {
    console.error('[user]', error);
    response.sendStatus(500);
  }
};

export const createUser: RequestHandler = async (request, response) => {
  try {
    const userProps = request.body as UserProps;
    const userRepository = getUserRepository();
    const maybeUser = await userRepository.findOne({
      username: userProps.username,
    });
    if (maybeUser) {
      console.log(`[user] user{username:${userProps.username}} already exists`);
      response.sendStatus(409);
      return;
    }

    const toBeUser = new User(userProps);
    const createdUser = await userRepository.save(toBeUser);
    response.status(201).json(createdUser.toJson());
    console.log(`[user] user${JSON.stringify(createdUser.toJson())} created`);
    await MessageBroker.syncWithServices({
      method: 'CREATE',
      user: {
        username: userProps.username,
        profilePictureUrl: userProps.profilePictureUrl,
      },
    });
    console.log(`[user] user${JSON.stringify(createdUser.toJson())} synced`);
  } catch (error) {
    console.error('[user]', error);
    response.sendStatus(500);
  }
};

export const patchUser: RequestHandler[] = [
  upload.single('media'),
  async (request, response): Promise<void> => {
    try {
      console.log(`Received file: ${request.file.originalname}`);
      console.log(`req.file.path=${request.file.path}`);
      const fileExt = request.file.originalname.split('.').pop();
      const src = createReadStream(request.file.path);
      const filename = `${Date.now()}.${fileExt}`;
      const dest = createWriteStream(`uploads/${filename}`);
      src.pipe(dest);
      src.on('end', async () => {
        unlinkSync(request.file.path);
        const { id } = request.params;

        const userRepository = getUserRepository();

        const user = await userRepository.findOne({ id });
        if (!user) {
          response.sendStatus(401);
          return;
        }

        user.profilePictureUrl = `${config.PUBLIC_URL}/users/media/${filename}`;
        const updatedUser = await userRepository.save(user);
        await MessageBroker.syncWithServices({
          method: 'UPDATE',
          user: {
            username: updatedUser.username,
            profilePictureUrl: updatedUser.profilePictureUrl,
          },
        });

        response.status(201).json(updatedUser.toJson());
      });
      src.on('error', (err) => {
        response.send(err);
      });
    } catch (error) {
      console.error(error);
      response.sendStatus(500);
    }
  },
];

export const followUser: RequestHandler = async (request, response) => {
  try {
    const { id } = request.params;
    const toBeFollowerUsername = getUsername(request);

    const userRepository = getUserRepository();
    const followRepository = getFollowRepository();

    const follower = await userRepository.findOne({
      username: toBeFollowerUsername,
    });
    if (!follower) {
      console.log(
        `[user] follower{username:${toBeFollowerUsername}} doesn't exist`
      );
      response.sendStatus(404);
      return;
    }

    const followed = await userRepository.findOne({ id });
    if (!followed) {
      console.log(`[user] followed{id:${id}} doesn't exist`);
      response.sendStatus(404);
      return;
    }

    const maybeFollow = await followRepository.findOne({ follower, followed });
    if (maybeFollow) {
      console.log(
        `[user] follow{followed{username:${followed.username}}, follower{username:${toBeFollowerUsername}}} already exists`
      );
      response.sendStatus(409);
      return;
    }

    followed.numberOffFollowers += 1;
    const updatedFollowed = await userRepository.save(followed);

    const toBeFollow = new Follow({ follower, followed: updatedFollowed });
    const createdFollow = await followRepository.save(toBeFollow);
    console.log(
      `[user] follow${JSON.stringify(createdFollow.toJson())} created`
    );

    await MessageBroker.syncWithServices({
      method: 'CREATE',
      follow: {
        followed: {
          username: followed.username,
        },
        follower: {
          username: follower.username,
        },
      },
    });

    await MessageBroker.sendFollowNotification(createdFollow);

    response.status(201).json(createdFollow.toJson());
  } catch (error) {
    console.error('[user]', error);
    response.sendStatus(500);
  }
};

export const unFollowUser: RequestHandler = async (request, response) => {
  try {
    const { id } = request.params;
    const toBeUnFollowerUsername = getUsername(request);
    const userRepository = getUserRepository();
    const followRepository = getFollowRepository();
    const follower = await userRepository.findOne({
      username: toBeUnFollowerUsername,
    });
    if (!follower) {
      console.log(
        `[user] follower{username:${toBeUnFollowerUsername}} doesn't exist`
      );
      response.sendStatus(404);
      return;
    }

    const followed = await userRepository.findOne({ id });
    if (!followed) {
      console.log(`[user] followed{id:${id}} doesn't exist`);
      response.sendStatus(404);
      return;
    }
    const toBeUnFollowedUsername = followed.username;

    const maybeFollow = await followRepository.findOne({ follower, followed });
    if (!maybeFollow) {
      console.log(
        `[user] follow{followed{username:${toBeUnFollowedUsername}}, follower{username:${toBeUnFollowerUsername}}} doesn't exist`
      );
      response.sendStatus(404);
      return;
    }

    await followRepository.remove(maybeFollow);

    followed.numberOffFollowers -= 1;
    await userRepository.save(followed);
    console.log(
      `[user] follow${JSON.stringify({
        follower: { username: toBeUnFollowerUsername },
        followed: { username: toBeUnFollowedUsername },
      })} removed`
    );

    await MessageBroker.syncWithServices({
      method: 'DELETE',
      follow: {
        follower: {
          username: toBeUnFollowerUsername,
        },
        followed: {
          username: toBeUnFollowedUsername,
        },
      },
    });

    response.sendStatus(204);
  } catch (error) {
    console.error('[user]', error);
    response.sendStatus(500);
  }
};
