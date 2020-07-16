import { Repository, EntityRepository } from 'typeorm';
import Comment from '../models/comment';

@EntityRepository(Comment)
export class CommentRepository extends Repository<Comment> {
  findByPostId = async (postId?: string): Promise<Comment[]> => {
    if (!postId) {
      return this.find({ relations: ['from', 'post'] });
    }
    const comments = await this.find({ relations: ['from', 'post'] });
    return comments.filter((comment) => comment.post.id === postId);
  };
}
