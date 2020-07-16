import { Repository, EntityRepository } from 'typeorm';
import Post from '../models/post';
import { getUserRepository } from '..';

interface PostsFindOptions {
  followerUsername?: string;
  limit?: string;
  offset?: string;
}

const paginate = (posts: Post[], take: number, skip: number): Post[] => {
  return posts.slice(skip * take, (skip + 1) * take);
};

@EntityRepository(Post)
export class PostRepository extends Repository<Post> {
  findWithPagination = async (
    limit?: string,
    offset?: string
  ): Promise<Post[]> => {
    if (limit === undefined || offset === undefined) {
      return this.find({ relations: ['user'] });
    }
    const take = parseInt(limit);
    const skip = parseInt(offset);
    const [result] = await this.findAndCount({
      relations: ['user'],
      take,
      skip,
    });
    return result;
  };

  findByFollowerWithPagination = async (
    options: PostsFindOptions
  ): Promise<Post[]> => {
    const { limit, offset, followerUsername } = options;

    if (limit === undefined || offset === undefined) {
      if (!followerUsername) {
        return this.find({ relations: ['user'] });
      } else {
        return this.getPostsOfFollowedUsers(followerUsername);
      }
    }

    const take = parseInt(limit);
    const skip = parseInt(offset);

    if (!followerUsername) {
      const [result] = await this.findAndCount({
        relations: ['user'],
        skip,
        take,
      });
      return result;
    }

    const postsOfFollowedUsers = await this.getPostsOfFollowedUsers(
      followerUsername
    );

    return paginate(postsOfFollowedUsers, take, skip);
  };

  private getPostsOfFollowedUsers = async (
    followerUsername: string
  ): Promise<Post[]> => {
    const userRepository = getUserRepository();

    const followedUsers = await userRepository.findByFollower(followerUsername);

    const posts = await this.find({
      relations: ['user'],
    });

    const postsOfFollowedUsers = posts.filter(
      (post) =>
        followedUsers.find((user) => user.id === post.user.id) !== undefined
    );
    return postsOfFollowedUsers;
  };
}
