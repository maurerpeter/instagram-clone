import { Repository, EntityRepository } from 'typeorm';
import User from '../models/user';

@EntityRepository(User)
export class UserRepository extends Repository<User> {}
