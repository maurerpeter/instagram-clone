import express from 'express';
import { json } from 'body-parser';
import { config } from './config';
import { createDatabaseConnection } from './database';
import morgan from 'morgan';
import cors from 'cors';
import routes from './routes';
import { MessageBroker } from './message-broker/message-broker';
import path from 'path';

process.on('uncaughtException', (error) => {
  console.error(error);
  process.exit(1);
});

process.on('unhandledRejection', (error) => {
  console.error(error);
  process.exit(1);
});

const server = express();
server.use(cors());
server.use(morgan('tiny'));
server.use(json());

server.use(routes);

server.use('/users/media', express.static(path.join(__dirname, 'uploads')));

createDatabaseConnection(config.DATABASE_CONNECTION_STRING).then(() => {
  console.log('[user-service]: Connection to database established');
  const PORT = config.PORT;
  MessageBroker.connect();
  server.listen(PORT, () => {
    console.log(`[user-service]: is running on port=${PORT}`);
  });
});
