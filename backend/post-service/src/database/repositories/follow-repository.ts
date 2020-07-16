import { Repository, EntityRepository } from 'typeorm';
import Follow from '../models/follow';

@EntityRepository(Follow)
export class FollowRepository extends Repository<Follow> {}
