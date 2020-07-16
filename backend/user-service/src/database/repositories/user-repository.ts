import { Repository, EntityRepository } from 'typeorm';
import User from '../models/user';
import { getFollowRepository } from '..';

@EntityRepository(User)
export class UserRepository extends Repository<User> {
  findByFollower = async (followerUsername?: string): Promise<User[]> => {
    const followRepository = getFollowRepository();
    if (!followerUsername) {
      return await this.find();
    }

    const userFollows = (
      await followRepository.find({
        relations: ['followed', 'follower'],
      })
    ).filter((follow) => follow.follower.username === followerUsername);

    return userFollows.map((userFollow) => userFollow.followed);
  };
}
