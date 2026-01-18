package dao;

import entity.Comment;

import java.util.List;

public interface CommentDao {
    List<Comment> findByVideoId(int videoId);

    long countByVideoId(int videoId);

    Comment insert(Comment c);
}
