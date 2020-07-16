import dotenv from 'dotenv';
import convict from 'convict';

dotenv.config();

const environmentConfig = convict({
  PORT: {
    doc: 'Port of the application',
    format: 'port',
    default: 3000,
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
  USER_SERVICE_URL: {
    doc: 'Url to user-service',
    format: String,
    default: '',
    env: 'USER_SERVICE_URL',
  },
});

environmentConfig.validate({ allowed: 'strict' });

export const config = environmentConfig.getProperties();
