import dotenv from 'dotenv';
import convict from 'convict';

dotenv.config();

const environmentConfig = convict({
  PORT: {
    doc: 'Port of the application',
    format: 'port',
    default: 3002,
  },
  DATABASE_CONNECTION_STRING: {
    doc: 'Connection string of the database',
    format: String,
    default: '',
    env: 'DATABASE_CONNECTION_STRING',
  },
  JWT_SECRET: {
    doc: 'Secret for JWT signing',
    format: String,
    default: 'verySecretKey123',
    env: 'JWT_SECRET',
  },
  AMQP_URL: {
    doc: 'URL of AMQP',
    format: String,
    default: '',
    env: 'AMQP_URL',
  },
  PUBLIC_URL: {
    doc: 'URL of the service from the outside',
    format: String,
    default: '',
    env: 'PUBLIC_URL',
  },
});

environmentConfig.validate({ allowed: 'strict' });

export const config = environmentConfig.getProperties();
