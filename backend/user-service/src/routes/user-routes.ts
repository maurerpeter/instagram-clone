import { Router } from 'express';
import { userValidator } from '../validator';
import {
  getUsers,
  createUser,
  followUser,
  unFollowUser,
  patchUser,
} from '../controllers/user-controller';
import { authorize } from '../controllers/auth-controller';

export const userRouter: Router = Router();
userRouter.route('/private/users').post(userValidator, createUser);

userRouter.route('/users').get(authorize, getUsers);
userRouter.route('/users/:id').patch(authorize, patchUser);

userRouter.route('/users/:id/follow').patch(authorize, followUser);
userRouter.route('/users/:id/unfollow').patch(authorize, unFollowUser);
