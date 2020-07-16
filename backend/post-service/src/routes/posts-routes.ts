import { Router } from 'express';
import { createPost, getPosts } from '../controllers/post-controller';
import { authorize } from '../controllers/auth-controller';

export const postsRouter: Router = Router();

postsRouter.route('/posts').post(authorize, createPost);
postsRouter.route('/posts').get(authorize, getPosts);
