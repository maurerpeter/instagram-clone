import { Router } from 'express';
import { getMessages } from '../controllers/message-controller';
import { authorize } from '../controllers/auth-controller';

export const messageRouter: Router = Router();

messageRouter.route('/messages').get(authorize, getMessages);
