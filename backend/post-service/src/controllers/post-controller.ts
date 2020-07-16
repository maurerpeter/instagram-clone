import { RequestHandler } from 'express';
import multer from 'multer';
import { createReadStream, createWriteStream, unlinkSync } from 'fs';
import { PostType } from '../constants';
import { getUsername } from './util';
import { getUserRepository, getPostRepository } from '../database';
import Post from '../database/models/post';
import { config } from '../config';
import { MessageBroker } from '../message-broker';

const upload = multer({ dest: 'uploads/' });

interface GetPostsQueryParams {
  limit?: string;
  offset?: string;
  followedBy?: string; // username
}

interface CreatePost {
  description: string;
  type: PostType;
}

export const getPosts: RequestHandler = async (request, response) => {
  try {
    const { limit, offset, followedBy } = request.query as GetPostsQueryParams;
    const postRepository = getPostRepository();
    const posts = await postRepository.findByFollowerWithPagination({
      limit,
      offset,
      followerUsername: followedBy,
    });
    response.json(posts.map((post) => post.toJson()));
  } catch (error) {
    console.error(error);
    response.sendStatus(500);
  }
};

export const createPost: RequestHandler[] = [
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

        const { description, type } = request.body as CreatePost;
        const username = getUsername(request);

        const userRepository = getUserRepository();
        const postRepository = getPostRepository();

        const user = await userRepository.findOne({ username });
        if (!user) {
          response.sendStatus(401);
          return;
        }

        const toBePost = new Post({
          user,
          description,
          type,
          mediaUrl: `${config.PUBLIC_URL}/posts/media/${filename}`,
        });
        const createdPost = await postRepository.save(toBePost);
        console.log(
          `post${JSON.stringify(createdPost.toJson())} created successfully`
        );
        await MessageBroker.sendPostNotification(createdPost);
        response.status(201).json(createdPost.toJson());
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
