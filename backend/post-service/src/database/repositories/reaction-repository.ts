import { Repository, EntityRepository } from 'typeorm';
import Reaction from '../models/reaction';

@EntityRepository(Reaction)
export class ReactionRepository extends Repository<Reaction> {
  findByPostId = async (postId?: string): Promise<Reaction[]> => {
    if (!postId) {
      return this.find({ relations: ['from', 'post'] });
    }
    const reactions = await this.find({ relations: ['from', 'post'] });
    return reactions.filter((reaction) => reaction.post.id === postId);
  };
}
