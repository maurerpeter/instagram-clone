import { Router } from 'express';
import { login } from '../controllers/login-controller';
import { signUp } from '../controllers/signup-controller';
import { userValidator } from '../validator';

export const authRouter: Router = Router();

authRouter.route('/login').post(userValidator, login);
authRouter.route('/signup').post(userValidator, signUp);
