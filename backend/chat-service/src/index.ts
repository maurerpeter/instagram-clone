import express from 'express';
import { json } from 'body-parser';
import { config } from './config';
import { createDatabaseConnection } from './database';
import morgan from 'morgan';
import cors from 'cors';
import routes from './routes';
import { MessageBroker } from './message-broker';

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

const PORT = config.PORT;
createDatabaseConnection(config.DATABASE_CONNECTION_STRING).then(() => {
  console.log('Connection to database established');
  server.listen(PORT, () => {
    console.log(`[auth-client]: is running on port=${PORT}`);
    MessageBroker.connect();
  });
});
